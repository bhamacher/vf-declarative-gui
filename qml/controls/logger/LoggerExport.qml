import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12
import QtQml.StateMachine 1.12 as QMLSM // avoid any ambiguity with QtQuick's State item
import VeinEntity 1.0
import ZeraTranslation 1.0
import GlobalConfig 1.0
import ZeraComponents 1.0
import ZeraVeinComponents 1.0
import ZeraFa 1.0


Item {
    id: root

    // we need a reference to menu stack layout to move around
    property var menuStackLayout

    // layout calculations
    readonly property real rowHeight: parent.height > 0 ? parent.height/8 : 10
    readonly property real fontScale: 0.3
    readonly property real pointSize: rowHeight*fontScale
    readonly property real visibleWidth: parent.width - 2*GC.standardTextHorizMargin
    readonly property real labelWidth: visibleWidth / 4
    readonly property real contentWidth: visibleWidth * 3 / 4

    // vein entities
    /* Note: we discussed a while on this:
       Component _LoggingSystem.CustomerData contains the json filename the
       session was created with. The component was created during exporter
       implementation phase but it turned out later that it is useless here:
       exporter takes customer data from static data stored. There is no reason
       to touch CutomerData entity here. */
    property QtObject exportEntity: VeinEntity.getEntity("ExportModule") // our export worker
    readonly property QtObject loggerEntity: VeinEntity.getEntity("_LoggingSystem") // for databse/session...
    readonly property QtObject filesEntity: VeinEntity.getEntity("_Files") // mounted sticks
    readonly property QtObject statusEntity: VeinEntity.getEntity("StatusModule1") // for paths as zera-<devicetype>-<serno>
    // vein components for convenience
    readonly property string databaseName: loggerEntity ? loggerEntity.DatabaseFile : ""
    readonly property string sessionName: loggerEntity ? loggerEntity.sessionName : ""
    readonly property alias mountedPaths: mountedDrivesCombo.mountedPaths
    readonly property var devicePath: statusEntity ? "zera-" + statusEntity.INF_DeviceType + '-' + statusEntity.PAR_SerialNr : "zera-undef"

    // make current export type commonly accessible / set by combo export type
    property string exportType
    // make current output path commonly accessible / set by combo target drive
    readonly property alias selectedMountPath: mountedDrivesCombo.currentPath
    // keep storage file path on demand on user activities
    property string targetFilePath : {
        var storagePath = selectedMountPath + '/' + devicePath
        var fullPath = ""
        switch(exportType) {
        case "EXPORT_TYPE_MTVIS":
            fullPath = storagePath + "/mtvis/" + editExportName.text
            break
        case "EXPORT_TYPE_SQLITE":
            fullPath = storagePath + "/database/" + editExportName.text
            break
        }
        return fullPath
    }


    // 'enumerate' our export types
    readonly property var exportTypeEnum: {
        "EXPORT_TYPE_MTVIS": 0,
        "EXPORT_TYPE_SQLITE": 1,
    }

    // and the visible items
    Label { // Header
        id: captionLabel
        anchors.left: parent.left
        anchors.right: parent.right
        horizontalAlignment: Text.AlignHCenter
        text: Z.tr("Export stored data")
        font.pointSize: pointSize * 1.5
        height: rowHeight
    }
    Column {
        id: selectionColumn
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: GC.standardTextHorizMargin
        anchors.leftMargin: GC.standardTextHorizMargin
        anchors.top: captionLabel.bottom
        anchors.bottom: buttonExport.top
        Row { // Export type
            height: rowHeight
            Label {
                text: Z.tr("Export type:")
                width: labelWidth
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                verticalAlignment: Text.AlignVCenter
                font.pointSize: pointSize
            }
            ComboBox {
                id: exportTypeCombo
                width: contentWidth
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                font.pointSize: root.pointSize
                currentIndex: loggerEntity.ExistingSessions.length > 0 ? 0 : 1
                model: {
                    var comboList = []
                    if(loggerEntity.ExistingSessions.length > 0) {
                        comboList.push({ value: "EXPORT_TYPE_MTVIS", enabled: true, label: Z.tr("MtVis XML") + (sessionName === "" ? "" : " (" +Z.tr("Session:") + " " + sessionName + ")") })
                    }
                    else {
                        comboList.push({ value: "EXPORT_TYPE_MTVIS", enabled: false, label: Z.tr("MtVis XML - requires stored sessions") })
                    }
                    comboList.push({ value: "EXPORT_TYPE_SQLITE", enabled: true, label: Z.tr("SQLite DB (complete)") })
                    return comboList
                }
                // we need a customized delegate to support enable/disable (and
                // to get default behaviour back it's more than just copying examples...)
                delegate: ItemDelegate {
                    width: exportTypeCombo.width
                    text: highlighted ? "<font color='" + Material.accentColor + "'>" + modelData.label + "</font>" : modelData.label
                    highlighted: modelData.value === exportTypeCombo.currentPath
                    enabled: modelData.enabled
                    font.pointSize: root.pointSize
                }
                textRole: "label"
                valueRole: "value"
                onCurrentIndexChanged: {
                    exportType = model[currentIndex].value // tried property binding but that did not work
                }
            }
        }
        Row { // Target drive (visible only if more than one drive is inserted)
            height: rowHeight
            visible: mountedPaths.length > 1
            Label {
                text: Z.tr("Target drive:")
                width: labelWidth
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                verticalAlignment: Text.AlignVCenter
                font.pointSize: pointSize
            }
            MountedDrivesCombo {
                id: mountedDrivesCombo
                width: contentWidth
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                font.pointSize: root.pointSize
            }
        }
        Row { // Export Name
            height: rowHeight
            visible: exportType !== "EXPORT_TYPE_MTVIS" || sessionName !== ""
            Label {
                text: Z.tr("Export name:");
                width: labelWidth
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                verticalAlignment: Text.AlignVCenter
                font.pointSize: pointSize
            }
            ZLineEdit {
                id: editExportName
                width: contentWidth
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                pointSize: root.pointSize
                textField.anchors.rightMargin: 0
                property alias aliasExportType: root.exportType
                property var regExCurr
                validator: RegExpValidator {
                    regExp: editExportName.regExCurr
                }
                onAliasExportTypeChanged: {
                    // Note on regexes:
                    // our target is windows most likely so to avoid trouble:
                    // * allow lower case only - Windows is not case sensitive
                    // * start with a letter
                    // * for MTVis: do not allow '.' for paths
                    switch(exportType) {
                    case "EXPORT_TYPE_MTVIS":
                        regExCurr = /\b[a-z0-9][_\-a-z0-9]*\b/
                        // suggest sessionName (yes we need to ask for overwrite e.g for the cause
                        // of multiple storining of same session name in multiple dbs)
                        var sessionLow = sessionName.toLowerCase()
                        var jRegEx =  RegExp(regExCurr, 'g')
                        var match
                        var str = ""
                        // suggest only combinations od valid parts of session
                        while ((match = jRegEx.exec(sessionLow))) {
                            if(str !== "") {
                                str += '_'
                            }
                            str += match[0]
                        }
                        text = str
                        readOnly = sessionName === ""
                        placeholderText = Z.tr("Name of export path")
                        break
                    case "EXPORT_TYPE_SQLITE":
                        regExCurr = /\b[a-z0-9][._\-a-z0-9]*\b/
                        text = databaseName.substr(databaseName.lastIndexOf('/') + 1).toLowerCase()
                        readOnly = true
                        placeholderText = ""
                        break
                    }
                    setOutputPath()
                }
                onTextChanged: {
                    setOutputPath()
                }
            }
        }
        Button { // Quick link to select session from here
            height: rowHeight
            visible: exportType === "EXPORT_TYPE_MTVIS" && sessionName === ""
            id: buttonSessionSelect
            width: contentWidth
            anchors.right: parent.right
            text: Z.tr("Please select a session first...")
            font.pointSize: pointSize
            onClicked: {
                menuStackLayout.showSessionNameSelector()
            }
        }
    }
    Button { // the export 'action' button
        id: buttonExport
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.rightMargin: GC.standardTextHorizMargin
        height: rowHeight
        text: Z.tr("Export")
        font.pointSize: pointSize
        enabled: {
            var _enabled = editExportName.hasValidInput() && !stateMachineExport.running && mountedPaths.length > 0
            switch(exportType) {
            case "EXPORT_TYPE_MTVIS":
                _enabled = _enabled && sessionName !== "" && databaseName !== ""
                break
            }
            return _enabled
        }
        onClicked: {
            stateMachineExport.errorDescription = ""
            switch(exportType) {
            case "EXPORT_TYPE_MTVIS":
                stateMachineExport.initialState = stateMtViscallRpcMtVisMainXml
                stateMachineExport.running = true
                break
            case "EXPORT_TYPE_SQLITE":
                stateMachineExport.initialState = stateCopyFile
                stateMachineExport.running = true
                break
            }

        }
        QMLSM.StateMachine {
            id: stateMachineExport
            initialState: stateMtVisFinal // we need a default..
            // state machine helper stuff
            signal exportNextState()
            signal exportAbortState()
            property bool errorOccured
            property string errorDescription
            // rpc helper functions and more
            property var rpcIdMtVis;
            property var rpcIdCopyFile;
            function callRpcMtVis(engine, outputFilePath) {
                // Although unlikely it can happen that we loose database /
                // session / memory stick during the process (yes it is not a
                // 100% solution but better than starting blindly)
                var driveStillThere = mountedPaths.includes(selectedMountPath)
                if(!rpcIdMtVis && sessionName !== "" && databaseName !== "" && driveStillThere) {
                    rpcIdMtVis = exportEntity.invokeRPC("RPC_Convert(QString p_engine,QString p_inputPath,QString p_outputPath,QString p_session)", {
                                                       "p_session": sessionName,
                                                       "p_inputPath": databaseName,
                                                       "p_outputPath": outputFilePath,
                                                       "p_engine": engine})

                }
                else {
                    stateMachineExport.errorDescription = Z.tr("Cannot export - drive removed?")
                    exportAbortState()
                }
            }
            function callRpcFileCopy(source, dest) {
                var driveStillThere = mountedPaths.includes(selectedMountPath)
                if(!rpcIdCopyFile && databaseName !== "" && driveStillThere) {
                    rpcIdCopyFile = filesEntity.invokeRPC("RPC_CopyFile(QString p_dest,bool p_overwrite,QString p_source)", {
                                                       "p_source": source,
                                                       "p_dest": dest,
                                                       "p_overwrite": true })
                }
                else {
                    stateMachineExport.errorDescription = Z.tr("Cannot export - drive removed?")
                    exportAbortState()
                }
            }

            Connections {
                target: exportEntity
                onSigRPCFinished: {
                    if(t_identifier === stateMachineExport.rpcIdMtVis) {
                        stateMachineExport.rpcIdMtVis = undefined
                        if(t_resultData["RemoteProcedureData::resultCode"] === 0 &&
                                t_resultData["RemoteProcedureData::Return"] === true) { // ok
                            stateMachineExport.exportNextState()
                        }
                        else { // error
                            stateMachineExport.errorDescription = Z.tr("Export failed - drive removed?")
                            stateMachineExport.exportAbortState()
                        }
                    }
                }
            }
            Connections {
                target: filesEntity
                onSigRPCFinished: {
                    if(t_identifier === stateMachineExport.rpcIdCopyFile) {
                        stateMachineExport.rpcIdCopyFile = undefined
                        if(t_resultData["RemoteProcedureData::resultCode"] === 0 &&
                                t_resultData["RemoteProcedureData::Return"] === true) { // ok
                            stateMachineExport.exportNextState()
                        }
                        else { // error
                            stateMachineExport.errorDescription = Z.tr("Copy failed - drive removed?")
                            stateMachineExport.exportAbortState()
                        }
                    }
                }
            }
            // MTVis states (linear to keep it simple)
            QMLSM.State { // MTVis 1. call rpc for main.xml
                id: stateMtViscallRpcMtVisMainXml
                QMLSM.SignalTransition { targetState: stateMtViscallRpcMtVisResultXml; signal: stateMachineExport.exportNextState }
                QMLSM.SignalTransition { targetState: stateError; signal: stateMachineExport.exportAbortState }
                onEntered: { stateMachineExport.callRpcMtVis('zeraconverterengines.MTVisMain', targetFilePath + '/main.xml')  }
            }
            QMLSM.State { // MTVis 2. call rpc for result.xml
                id: stateMtViscallRpcMtVisResultXml
                QMLSM.SignalTransition { targetState: stateMtVisFinal; signal: stateMachineExport.exportNextState }
                QMLSM.SignalTransition { targetState: stateError; signal: stateMachineExport.exportAbortState }
                onEntered: { stateMachineExport.callRpcMtVis('zeraconverterengines.MTVisRes', targetFilePath + '/result.xml')  }
            }

            // SQLite copy state
            QMLSM.State { // call rpc to cpopy database
                id: stateCopyFile
                QMLSM.SignalTransition { targetState: stateMtVisFinal; signal: stateMachineExport.exportNextState }
                QMLSM.SignalTransition { targetState: stateError; signal: stateMachineExport.exportAbortState }
                onEntered: { stateMachineExport.callRpcFileCopy(databaseName, targetFilePath) }
            }

            QMLSM.State { // Error state
                id: stateError
                QMLSM.SignalTransition {
                    targetState: stateMtVisFinal
                    signal: stateMachineExport.exportNextState
                }
                onEntered: {
                    stateMachineExport.errorOccured = true
                    stateMachineExport.exportNextState()
                }
            }
            QMLSM.FinalState { // final state
                id: stateMtVisFinal
            }
            onFinished: {
                if(stateMachineExport.errorDescription === "") {
                    menuStackLayout.pleaseCloseMe(false)
                }
                else {
                    // TODO
                }
            }
        }
    }
}