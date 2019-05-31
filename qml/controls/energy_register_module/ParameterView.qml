import QtQuick 2.5
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import VeinEntity 1.0
import QwtChart 1.0
import ZeraTranslation  1.0
import GlobalConfig 1.0
import ModuleIntrospection 1.0
import "qrc:/qml/controls" as CCMP
import "qrc:/qml/vf-controls" as VFControls
import "qrc:/qml/controls/settings" as SettingsControls
import "qrc:/data/staticdata/FontAwesome.js" as FA

Item {
  id: root
  //holds the state data
  property QtObject logicalParent;
  property real rowHeight: height/7

  readonly property QtObject p1m1: VeinEntity.getEntity("POWER1Module1")
  readonly property QtObject p1m2: VeinEntity.getEntity("POWER1Module2")
  readonly property QtObject p1m3: VeinEntity.getEntity("POWER1Module3")


  SettingsControls.SettingsView {
    anchors.fill: parent
    model: parameterModel
  }
  VisualItemModel {
    id: parameterModel

    Rectangle {
      color: "transparent"
      border.color: Material.dividerColor
      height: root.rowHeight
      width: root.width
      enabled: logicalParent.canStartMeasurement
      Label {
        id: lblRefInput
        textFormat: Text.PlainText
        anchors.left: parent.left
        anchors.leftMargin: GC.standardTextMargin
        width: parent.width * 2 / 6
        anchors.verticalCenter: parent.verticalCenter
        text: ZTR["Reference input:"]
        font.pixelSize: Math.max(height/2, 20)
      }
      VFControls.VFComboBox {
        id: cbRefInput

        arrayMode: true

        entity: logicalParent.energyRegister
        controlPropertyName: "PAR_RefInput"
        model: ModuleIntrospection.sem1Introspection.ComponentInfo.PAR_RefInput.Validation.Data

        x: parent.width*2/6
        width: parent.width*3/6 - GC.standardMarginWithMin

        anchors.top: parent.top
        anchors.topMargin: GC.standardMargin
        anchors.bottom: parent.bottom
        anchors.bottomMargin: GC.standardMargin

        currentIndex: 0
        contentRowWidth: width
        contentRowHeight: height*GC.standardComboContentScale
        contentFlow: GridView.FlowTopToBottom
        centerVertical: true
        centerVerticalOffset: height/2

        opacity: enabled ? 1.0 : 0.7
      }
      VFControls.VFComboBox {
        id: cbRefMeasMode
        arrayMode: true
        enabled: logicalParent.canStartMeasurement
        controlPropertyName: "PAR_MeasuringMode"
        model: {
          switch(cbRefInput.currentText) {
          case "P":
            return ModuleIntrospection.p1m1Introspection.ComponentInfo.PAR_MeasuringMode.Validation.Data;
          case "Q":
            return ModuleIntrospection.p1m2Introspection.ComponentInfo.PAR_MeasuringMode.Validation.Data;
          case "S":
            return ModuleIntrospection.p1m3Introspection.ComponentInfo.PAR_MeasuringMode.Validation.Data;
          default:
            console.assert("Unhandled condition")
            return undefined;
          }
        }

        entity: {
          switch(cbRefInput.currentText) {
          case "P":
            return root.p1m1
          case "Q":
            return root.p1m2
          case "S":
            return root.p1m3
          default:
            console.assert("Unhandled condition")
            return undefined;
          }
        }

        x : parent.width*5/6
        width: parent.width/6-GC.standardMargin

        anchors.top: parent.top
        anchors.topMargin: GC.standardMargin
        anchors.bottom: parent.bottom
        anchors.bottomMargin: GC.standardMargin

        contentRowHeight: height*GC.standardComboContentScale
        contentFlow: GridView.FlowTopToBottom
      }
    }
    Rectangle {
      color: "transparent"
      border.color: Material.dividerColor
      height: root.rowHeight
      width: root.width
      enabled: logicalParent.canStartMeasurement
      Label {
        id: lblMode
        textFormat: Text.PlainText
        anchors.left: parent.left
        anchors.leftMargin: GC.standardTextMargin
        width: parent.width*2/6
        anchors.verticalCenter: parent.verticalCenter
        text: ZTR["Mode:"]
        font.pixelSize: Math.max(height/2, 20)
      }
      VFControls.VFComboBox {
        id: cbMode

        arrayMode: true

        entity: logicalParent.energyRegister
        controlPropertyName: "PAR_Targeted"
        entityIsIndex: true
        model: [ZTR["Start/Stop"],ZTR["Duration"]]

        x: parent.width*2/6
        width: parent.width*3/6-GC.standardMarginWithMin

        anchors.top: parent.top
        anchors.topMargin: GC.standardMargin
        anchors.bottom: parent.bottom
        anchors.bottomMargin: GC.standardMargin

        currentIndex: 0
        contentRowWidth: width
        contentRowHeight: height*GC.standardComboContentScale
        contentFlow: GridView.FlowTopToBottom
        centerVertical: true
        centerVerticalOffset: height/2

        opacity: enabled ? 1.0 : 0.7
      }
    }
    Rectangle {
      visible: cbMode.currentIndex !== 0
      color: "transparent"
      border.color: Material.dividerColor
      height: root.rowHeight * visible //don't waste space if not visible
      width: root.width

      Label {
        id: lblDuration
        textFormat: Text.PlainText
        anchors.left: parent.left
        anchors.leftMargin: GC.standardTextMargin
        width: parent.width * 2 / 6
        anchors.verticalCenter: parent.verticalCenter
        text: ZTR["Duration:"]
        font.pixelSize: Math.max(height/2, 20)
      }
      VFControls.VFLineEdit {
        entity: logicalParent.energyRegister
        controlPropertyName: "PAR_MeasTime"

        x: parent.width*2/6
        width: parent.width*3/6-GC.standardMarginWithMin

        anchors.top: parent.top
        anchors.bottom: parent.bottom

        enabled: logicalParent.canStartMeasurement
        validator: CCMP.ZDoubleValidator {
          bottom: ModuleIntrospection.sem1Introspection.ComponentInfo.PAR_MeasTime.Validation.Data[0];
          top: ModuleIntrospection.sem1Introspection.ComponentInfo.PAR_MeasTime.Validation.Data[1];
          decimals: GC.ceilLog10Of1DividedByX(ModuleIntrospection.sem1Introspection.ComponentInfo.PAR_MeasTime.Validation.Data[2]);
        }
      }
    }
    Rectangle {
      color: "transparent"
      border.color: Material.dividerColor
      height: root.rowHeight * 2
      width: root.width
      enabled: logicalParent.canStartMeasurement
      Label {
        textFormat: Text.PlainText
        anchors.left: parent.left
        anchors.leftMargin: GC.standardTextMargin
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -parent.height * 0.25
        text: ZTR["Start value:"]
        font.pixelSize: Math.max(height/2, 20)
      }
      VFControls.VFLineEdit {
        entity: logicalParent.energyRegister
        controlPropertyName: "PAR_T0Input"

        x: parent.width*2/6
        width: parent.width*3/6-GC.standardMarginWithMin

        anchors.top: parent.top
        height: parent.height * 0.5

        inputMethodHints: Qt.ImhPreferNumbers

        enabled: logicalParent.canStartMeasurement
        validator: CCMP.ZDoubleValidator {
          bottom: ModuleIntrospection.sem1Introspection.ComponentInfo.PAR_T0Input.Validation.Data[0];
          top: ModuleIntrospection.sem1Introspection.ComponentInfo.PAR_T0Input.Validation.Data[1];
          decimals: GC.ceilLog10Of1DividedByX(ModuleIntrospection.sem1Introspection.ComponentInfo.PAR_T0Input.Validation.Data[2]);
        }

      }
      // This is a line
      Rectangle {
          color: "transparent"
          border.color: Material.dividerColor
          height: 1
          width: parent.width*5/6 - GC.standardMargin
          anchors.left: parent.left
          anchors.verticalCenter: parent.verticalCenter
      }

      Label {
        textFormat: Text.PlainText
        anchors.left: parent.left
        anchors.leftMargin: GC.standardTextMargin
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: parent.height * 0.25
        text: ZTR["End value:"]
        font.pixelSize: Math.max(height/2, 20)
      }
      VFControls.VFLineEdit {
        entity: logicalParent.energyRegister
        controlPropertyName: "PAR_T1input"

        x: parent.width*2/6
        width: parent.width*3/6-GC.standardMarginWithMin

        anchors.bottom: parent.bottom
        height: parent.height * 0.5

        inputMethodHints: Qt.ImhPreferNumbers


        enabled: logicalParent.canStartMeasurement
        validator: CCMP.ZDoubleValidator {
          bottom: ModuleIntrospection.sem1Introspection.ComponentInfo.PAR_T1input.Validation.Data[0];
          top: ModuleIntrospection.sem1Introspection.ComponentInfo.PAR_T1input.Validation.Data[1];
          decimals: GC.ceilLog10Of1DividedByX(ModuleIntrospection.sem1Introspection.ComponentInfo.PAR_T1input.Validation.Data[2]);
        }
      }
      VFControls.VFComboBox {
        enabled: logicalParent.canStartMeasurement
        arrayMode: true
        fontSize: 16
        entity: logicalParent.energyRegister

        controlPropertyName: "PAR_TXUNIT"
        model: ModuleIntrospection.sem1Introspection.ComponentInfo.PAR_TXUNIT.Validation.Data

        height: parent.height - 2*GC.standardMargin
        anchors.verticalCenter: parent.verticalCenter
        contentRowHeight: height*0.5*GC.standardComboContentScale
        contentFlow: GridView.FlowTopToBottom
        anchors.right: parent.right
        anchors.rightMargin: GC.standardMargin
        width: parent.width/6

        opacity: enabled ? 1.0 : 0.7
      }

    }
    Rectangle {
      color: "transparent"
      border.color: Material.dividerColor
      height: root.rowHeight
      width: root.width

      Label {
        textFormat: Text.PlainText
        anchors.left: parent.left
        anchors.leftMargin: GC.standardTextMargin
        anchors.verticalCenter: parent.verticalCenter
        text: ZTR["Upper error margin:"]
        font.pixelSize: Math.max(height/2, 20)
      }
      VFControls.VFLineEdit {
        id: upperLimitInput
        x: parent.width*2/6
        width: parent.width*3/6-GC.standardMarginWithMin

        anchors.top: parent.top
        anchors.bottom: parent.bottom

        inputMethodHints: Qt.ImhPreferNumbers
        text: GC.errorMarginUpperValue

        enabled: logicalParent.canStartMeasurement
        validator: CCMP.ZDoubleValidator {bottom: -100; top: 100; decimals: 3;}
        function confirmInput() {
          upperLimitInput.text = upperLimitInput.textField.text
          GC.setErrorMargins(parseFloat(upperLimitInput.text), GC.errorMarginLowerValue);
        }
      }
    }
    Rectangle {
      color: "transparent"
      border.color: Material.dividerColor
      height: root.rowHeight
      width: root.width

      Label {
        textFormat: Text.PlainText
        anchors.left: parent.left
        anchors.leftMargin: GC.standardTextMargin
        anchors.verticalCenter: parent.verticalCenter
        text: ZTR["Lower error margin:"]
        font.pixelSize: Math.max(height/2, 20)
      }
      VFControls.VFLineEdit {
        id: lowerLimitInput
        x: parent.width*2/6
        width: parent.width*3/6-GC.standardMarginWithMin

        anchors.top: parent.top
        anchors.bottom: parent.bottom

        inputMethodHints: Qt.ImhPreferNumbers
        text: GC.errorMarginLowerValue

        enabled: logicalParent.canStartMeasurement
        validator: CCMP.ZDoubleValidator {bottom: -100; top: 100; decimals: 3;}
        function confirmInput() {
          lowerLimitInput.text = lowerLimitInput.textField.text
          GC.setErrorMargins(GC.errorMarginUpperValue, parseFloat(lowerLimitInput.text));
        }
      }
    }
  }
}
