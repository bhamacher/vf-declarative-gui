import QtQuick 2.5
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import VeinEntity 1.0
import QwtChart 1.0
import ZeraTranslation  1.0
import GlobalConfig 1.0
import ModuleIntrospection 1.0
import ZeraComponents 1.0
import "qrc:/qml/controls" as CCMP
import ZeraVeinComponents 1.0 as VFControls
import "qrc:/qml/controls/settings" as SettingsControls
import ZeraFa 1.0
import "qrc:/qml/helpers" as HELPERS

Item {
  id: root
  // properties to set by parent
  property QtObject logicalParent;
  property var validatorRefInput
  property var validatorMode
  property var validatorDutInput
  property var validatorDutConstant
  property var validatorDutConstUnit
  // either energy or mrate
  property var validatorEnergy
  property var validatorMrate

  // hack to determine if we are in ced-session and have to use POWER2Module1
  // to get/set measurement-modes
  readonly property bool usePower2: validatorRefInput.Data.includes("+P") && validatorRefInput.Data.includes("-P")

  readonly property real rowHeight: height/7
  readonly property real pointSize: rowHeight/2.5

  readonly property QtObject p1m1: !usePower2 ? VeinEntity.getEntity("POWER1Module1") : QtObject
  readonly property QtObject p1m2: !usePower2 ? VeinEntity.getEntity("POWER1Module2") : QtObject
  readonly property QtObject p1m3: !usePower2 ? VeinEntity.getEntity("POWER1Module3") : QtObject
  readonly property QtObject p2m1: usePower2 ? VeinEntity.getEntity("POWER2Module1") : QtObject

  readonly property real col1Width: 10/20
  readonly property real col2Width: 6/20
  readonly property real col3Width: 4/20

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
        textFormat: Text.PlainText
        anchors.left: parent.left
        anchors.leftMargin: GC.standardTextHorizMargin
        width: parent.width*col1Width
        anchors.verticalCenter: parent.verticalCenter
        text: Z.tr("Reference input:")
        font.pointSize: root.pointSize
      }
      VFControls.VFComboBox {
        id: cbRefInput

        arrayMode: true

        entity: logicalParent.errCalEntity
        controlPropertyName: "PAR_RefInput"
        model: validatorRefInput.Data

        x: parent.width*col1Width
        width: parent.width*col2Width - GC.standardMarginWithMin

        anchors.top: parent.top
        anchors.topMargin: GC.standardMargin
        anchors.bottom: parent.bottom
        anchors.bottomMargin: GC.standardMargin

        contentRowHeight: height*GC.standardComboContentScale
        contentFlow: GridView.FlowTopToBottom
      }

      VFControls.VFComboBox {
        arrayMode: true
        controlPropertyName: "PAR_MeasuringMode"
        fontSize: 16
        model: {
          if(usePower2) {
              return ModuleIntrospection.p2m1Introspection.ComponentInfo.PAR_MeasuringMode.Validation.Data;
          }
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
          if(usePower2) {
            return root.p2m1
          }
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

        anchors.right: parent.right
        width: parent.width*col3Width-GC.standardMargin

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
        textFormat: Text.PlainText
        anchors.left: parent.left
        anchors.leftMargin: GC.standardTextHorizMargin
        width: parent.width*col1Width
        anchors.verticalCenter: parent.verticalCenter
        text: Z.tr("Mode:")
        font.pointSize: root.pointSize
      }

      VFControls.VFComboBox {
        id: cbMode
        arrayMode: true
        entity: logicalParent.errCalEntity
        controlPropertyName: "PAR_Mode"
        model: validatorMode.Data
        x: parent.width*col1Width
        width: parent.width*col2Width - GC.standardMarginWithMin

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
        textFormat: Text.PlainText
        anchors.left: parent.left
        anchors.leftMargin: GC.standardTextHorizMargin
        width: parent.width*col1Width
        anchors.verticalCenter: parent.verticalCenter
        text: Z.tr("Device input:")
        font.pointSize: root.pointSize
      }
      VFControls.VFComboBox {
        arrayMode: true

        entity: logicalParent.errCalEntity
        controlPropertyName: "PAR_DutInput"
        model: validatorDutInput.Data;

        x: parent.width*col1Width
        width: parent.width*col2Width-GC.standardMarginWithMin

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
        textFormat: Text.PlainText
        anchors.left: parent.left
        anchors.leftMargin: GC.standardTextHorizMargin
        width: parent.width*col1Width
        anchors.verticalCenter: parent.verticalCenter
        text: Z.tr("DUT constant:")
        font.pointSize: root.pointSize
      }

      VFControls.VFLineEdit {
        entity: logicalParent.errCalEntity
        controlPropertyName: "PAR_DutConstant"

        x: parent.width*col1Width
        width: parent.width*col2Width-GC.standardMarginWithMin

        anchors.top: parent.top
        anchors.bottom: parent.bottom
        pointSize: root.pointSize

        validator: ZDoubleValidator {
          bottom: validatorDutConstant.Data[0];
          top: validatorDutConstant.Data[1];
          decimals: GC.ceilLog10Of1DividedByX(validatorDutConstant.Data[2]);
        }
      }

      VFControls.VFComboBox {
        arrayMode: true

        entity: logicalParent.errCalEntity
        controlPropertyName: "PAR_DUTConstUnit"
        model: validatorDutConstUnit.Data;

        anchors.top: parent.top
        anchors.topMargin: GC.standardMargin
        anchors.bottom: parent.bottom
        anchors.bottomMargin: GC.standardMargin
        anchors.right: parent.right
        width: parent.width*col3Width-GC.standardMargin

        contentRowHeight: height*GC.standardComboContentScale
        contentFlow: GridView.FlowTopToBottom
      }
    }
    Loader {
      active: validatorEnergy !== undefined
      sourceComponent: Rectangle {
        enabled: logicalParent.canStartMeasurement
        color: "transparent"
        border.color: Material.dividerColor
        height: root.rowHeight
        width: root.width

        Label {
          textFormat: Text.PlainText
          anchors.left: parent.left
          anchors.leftMargin: GC.standardTextHorizMargin
          width: parent.width*col1Width
          anchors.verticalCenter: parent.verticalCenter
          text: Z.tr("Energy:")
          font.pointSize: root.pointSize
        }

        // helper for strToCLocale
        HELPERS.TextHelper {
          id: tHelper
        }
        VFControls.VFLineEdit {
          id: energyVal
          property alias currentFactor: unitCombo.currentFactor
          entity: logicalParent.errCalEntity
          controlPropertyName: "PAR_Energy"

          x: parent.width*col1Width
          width: parent.width*col2Width-GC.standardMarginWithMin

          anchors.top: parent.top
          anchors.bottom: parent.bottom
          pointSize: root.pointSize

          // scale adjusted validator
          // Note: attempts to add scale functionality to ZLineEdit/ZSpinBox failed due
          // to QML validator specifics:
          // validator is a reference to object created above. Whatever we do
          // * create a copy validator
          // * adjust bottom/top/decimals by js
          // breaks property bindings
          validator: ZDoubleValidator {
            // Hmm - we need full reference for currentFactor here
            bottom: validatorEnergy.Data[0] / energyVal.currentFactor;
            top: validatorEnergy.Data[1] / energyVal.currentFactor;
            decimals: GC.ceilLog10Of1DividedByX(validCCMP.ZLineEditatorEnergy.Data[2] / energyVal.currentFactor)
          }
          // overrides for scale
          function doApplyInput(newText) {
            var flt = parseFloat(newText) * currentFactor
            entity[controlPropertyName] = flt
            // wait to be applied
            return false
          }
          // scale adjusted copies from TextHelper
          function discardInput() {
            var fltVal = parseFloat(text) / currentFactor
            // * we cannot use validator.decimals - it is updated too late
            // * multiple back and forth conversion to round value to digit (otherwise field remains red)
            var strVal = String(Number(fltVal.toFixed(GC.ceilLog10Of1DividedByX(validatorEnergy.Data[2] / currentFactor))))
            textField.text = strVal.replace(GC.locale.decimalPoint === "," ? "." : ",", GC.locale.decimalPoint)
          }
          function hasAlteredValue() {
            var expVal = Math.pow(10, GC.ceilLog10Of1DividedByX(validatorEnergy.Data[2] / currentFactor))
            var fieldVal = parseFloat(tHelper.strToCLocale(textField.text, isNumeric, isDouble)) * expVal
            var textVal = parseFloat(text) * expVal / currentFactor
            return Math.abs(fieldVal-textVal) > 0.1
          }
          // scale change signal handler
          onCurrentFactorChanged: {
            discardInput()
          }
        }
        ZUnitComboBox {
          id: unitCombo
          currentIndex: GC.energyScaleSelection
          // entity base unit is kWh (maybe we add some magic later - for now use harcoding)
          arrEntries: {
            switch(cbRefInput.currentText) {
            case "P":
              return [["Wh","kWh","MWh"],[1e-3,1e0,1e3]]
            case "Q":
              return [["VArh","kVArh","MVArh"],[1e-3,1e0,1e3]]
            case "S":
              return [["VAh","kVAh","MVAh"],[1e-3,1e0,1e3]]
            default:
              console.assert("Unhandled condition")
              return undefined;
            }
          }
          anchors.top: parent.top
          anchors.topMargin: GC.standardMargin
          anchors.bottom: parent.bottom
          anchors.bottomMargin: GC.standardMargin
          anchors.right: parent.right
          width: parent.width*col3Width-GC.standardMargin

          contentRowHeight: height*GC.standardComboContentScale
          contentFlow: GridView.FlowTopToBottom
          onCurrentFactorChanged: {
            // Hmm unitCombo does not fire onCurrentIndexChanged so use onCurrentFactorChanged...
            GC.setEnergyScaleSelection(targetIndex)
          }
        }
      }
    }
    Loader {
      active: validatorMrate !== undefined
      sourceComponent: Rectangle {
        enabled: logicalParent.canStartMeasurement
        color: "transparent"
        border.color: Material.dividerColor
        height: root.rowHeight
        width: root.width

        Label {
          textFormat: Text.PlainText
          anchors.left: parent.left
          anchors.leftMargin: GC.standardTextHorizMargin
          width: parent.width*col1Width
          anchors.verticalCenter: parent.verticalCenter
          text: Z.tr("MRate:")
          font.pointSize: root.pointSize
        }

        VFControls.VFLineEdit {
          entity: logicalParent.errCalEntity
          controlPropertyName: "PAR_MRate"

          x: parent.width*col1Width
          width: parent.width*col2Width-GC.standardMarginWithMin

          anchors.top: parent.top
          anchors.bottom: parent.bottom
          pointSize: root.pointSize

          validator: ZDoubleValidator {
            bottom: validatorMrate.Data[0];
            top: validatorMrate.Data[1];
            decimals: GC.ceilLog10Of1DividedByX(validatorMrate.Data[2]);
          }
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
        anchors.leftMargin: GC.standardTextHorizMargin
        width: parent.width*col1Width
        anchors.verticalCenter: parent.verticalCenter
        text: Z.tr("Upper error margin:")
        font.pointSize: root.pointSize
      }
      ZLineEdit {
        id: upperLimitInput
        x: parent.width*col1Width
        width: parent.width*col2Width-GC.standardMarginWithMin

        anchors.top: parent.top
        anchors.bottom: parent.bottom
        pointSize: root.pointSize

        text: GC.errorMarginUpperValue

        validator: ZDoubleValidator {bottom: -100; top: 100; decimals: 3;}
        function doApplyInput(newText) {
          GC.setErrorMarginUpperValue(newText)
          return false
        }
      }
      Label {
        textFormat: Text.PlainText
        anchors.right: parent.right
        width: parent.width*col3Width - GC.standardTextHorizMargin
        anchors.verticalCenter: parent.verticalCenter
        text: "%"
        font.pointSize: root.pointSize
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
        anchors.leftMargin: GC.standardTextHorizMargin
        width: parent.width*col1Width
        anchors.verticalCenter: parent.verticalCenter
        text: Z.tr("Lower error margin:")
        font.pointSize: root.pointSize
      }
      ZLineEdit {
        id: lowerLimitInput
        x: parent.width*col1Width
        width: parent.width*col2Width-GC.standardMarginWithMin

        anchors.top: parent.top
        anchors.bottom: parent.bottom
        pointSize: root.pointSize

        text: GC.errorMarginLowerValue

        validator: ZDoubleValidator {bottom: -100; top: 100; decimals: 3;}
        function doApplyInput(newText) {
          GC.setErrorMarginLowerValue(newText)
          return false
        }
      }
      Label {
        textFormat: Text.PlainText
        anchors.right: parent.right
        width: parent.width*col3Width - GC.standardTextHorizMargin
        anchors.verticalCenter: parent.verticalCenter
        text: "%"
        font.pointSize: root.pointSize
      }
    }
  }
}
