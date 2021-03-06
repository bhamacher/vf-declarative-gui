import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import QtQuick.Layouts 1.0
import VeinEntity 1.0
import GlobalConfig 1.0
import ZeraGlueLogic 1.0
import ZeraTranslation  1.0
import ModuleIntrospection 1.0
import ZeraComponents 1.0
import "qrc:/qml/controls" as CCMP
import ZeraVeinComponents 1.0 as VFControls
import "qrc:/qml/controls/settings" as SettingsControls

CCMP.ModulePage {
  id: root

  readonly property QtObject transformerModule: VeinEntity.getEntity("Transformer1Module1")
  readonly property var transformerIntrospection: ModuleIntrospection.transformer1Introspection
  readonly property int rowHeight: Math.floor(height/12)

  //could be replaced by a VisualItemModel
  Column {
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top
    height: root.height*9/12
    width: root.width

    //Header
    Row {
      CCMP.GridItem {
        width: root.width*0.2
        height: root.rowHeight
        color: GC.tableShadeColor
        text: ""
        font.bold: true
      }
      CCMP.GridItem {
        width: root.width*0.6
        height: root.rowHeight
        color: GC.tableShadeColor
        text: Z.tr("TR1")
        font.bold: true
      }
      CCMP.GridItem {
        width: root.width*0.2
        height: root.rowHeight
        color: GC.tableShadeColor
        text: "[ ]"
        font.bold: true
      }
    }

    //transformer primary
    Row {
      CCMP.GridItem {
        width: root.width*0.2
        height: root.rowHeight
        color: GC.tableShadeColor
        text: Z.tr("X-Prim");
        font.bold: true
      }
      CCMP.GridItem {
        width: root.width*0.6
        height: root.rowHeight
        text: GC.formatNumber(transformerModule.ACT_IXPrimary1)
      }
      CCMP.GridItem {
        width: root.width*0.2
        height: root.rowHeight
        text: transformerIntrospection.ComponentInfo.ACT_IXPrimary1.Unit;
      }
    }

    //n secondary
    Row {
      CCMP.GridItem {
        width: root.width*0.2
        height: root.rowHeight
        color: GC.tableShadeColor
        text: Z.tr("N-Sec");
        font.bold: true
      }
      CCMP.GridItem {
        width: root.width*0.6
        height: root.rowHeight
        text: GC.formatNumber(transformerModule.ACT_INSecondary1)
      }
      CCMP.GridItem {
        width: root.width*0.2
        height: root.rowHeight
        text: transformerIntrospection.ComponentInfo.ACT_INSecondary1.Unit;
      }
    }

    //transformer secondary
    Row {
      CCMP.GridItem {
        width: root.width*0.2
        height: root.rowHeight
        color: GC.tableShadeColor
        text: Z.tr("X-Sec");
        font.bold: true
      }
      CCMP.GridItem {
        width: root.width*0.6
        height: root.rowHeight
        text: GC.formatNumber(transformerModule.ACT_IXSecondary1)
      }
      CCMP.GridItem {
        width: root.width*0.2
        height: root.rowHeight
        text: transformerIntrospection.ComponentInfo.ACT_IXSecondary1.Unit;
      }
    }

    //Transformer Ratio
    Row {
      CCMP.GridItem {
        width: root.width*0.2
        height: root.rowHeight
        color: GC.tableShadeColor
        text: Z.tr("X-Ratio")
        font.bold: true
      }
      CCMP.GridItem {
        width: root.width*0.6
        height: root.rowHeight
        text: GC.formatNumber(transformerModule.ACT_Ratio1)
      }
      CCMP.GridRect {
        width: root.width*0.2
        height: root.rowHeight
      }
    }

    //Transformer Error
    Row {
      CCMP.GridItem {
        width: root.width*0.2
        height: root.rowHeight
        color: GC.tableShadeColor
        text: "X-ε"
        font.bold: true
      }
      CCMP.GridItem {
        width: root.width*0.6
        height: root.rowHeight
        text: GC.formatNumber(transformerModule.ACT_Error1)
      }
      CCMP.GridItem {
        width: root.width*0.2
        height: root.rowHeight
        text: root.transformerIntrospection.ComponentInfo.ACT_Error1.Unit;
      }
    }

    //Transformer angle in degree
    Row {
      CCMP.GridItem {
        width: root.width*0.2
        height: root.rowHeight
        color: GC.tableShadeColor
        text: "X-δ"
        font.bold: true
      }
      CCMP.GridItem {
        width: root.width*0.6
        height: root.rowHeight
        text: GC.formatNumber(transformerModule.ACT_Angle1)
      }
      CCMP.GridItem {
        width: root.width*0.2
        height: root.rowHeight
        text: transformerIntrospection.ComponentInfo.ACT_Angle1.Unit;
      }
    }

    //Transformer angle in centirad
    Row {
      CCMP.GridItem {
        width: root.width*0.2
        height: root.rowHeight
        color: GC.tableShadeColor
        text: "X-δ"
        font.bold: true
      }
      CCMP.GridItem {
        width: root.width*0.6
        height: root.rowHeight
        text: GC.formatNumber(100 * transformerModule.ACT_Angle1 * Math.PI/180)
      }
      CCMP.GridItem {
        width: root.width*0.2
        height: root.rowHeight
        text: Z.tr("crad");
      }
    }

    //Transformer angle in arcminutes
    Row {
      CCMP.GridItem {
        width: root.width*0.2
        height: root.rowHeight
        color: GC.tableShadeColor
        text: "X-δ"
        font.bold: true
      }
      CCMP.GridItem {
        width: root.width*0.6
        height: root.rowHeight
        text: GC.formatNumber(transformerModule.ACT_Angle1*60)
      }
      CCMP.GridItem {
        width: root.width*0.2
        height: root.rowHeight
        text: Z.tr("arcmin");
      }
    }
  }

  SettingsControls.SettingsView {
    anchors.left: parent.left
    anchors.right: parent.right
    height: root.rowHeight * model.count
    anchors.bottom: parent.bottom

    model: VisualItemModel {
      Item {
        width: root.width
        height: root.rowHeight

        VFControls.VFLineEdit {
          id: parPrimClampPrim
          description.text: Z.tr("Mp-Prim:")
          description.width: root.width/10;
          height: root.rowHeight;
          width: root.width/2 - 8;

          entity: root.transformerModule
          controlPropertyName: "PAR_PrimClampPrim"
          unit.text: transformerIntrospection.ComponentInfo[controlPropertyName].Unit

          validator: ZDoubleValidator {
            bottom: transformerIntrospection.ComponentInfo[parPrimClampPrim.controlPropertyName].Validation.Data[0];
            top: transformerIntrospection.ComponentInfo[parPrimClampPrim.controlPropertyName].Validation.Data[1];
            decimals: GC.ceilLog10Of1DividedByX(transformerIntrospection.ComponentInfo[parPrimClampPrim.controlPropertyName].Validation.Data[2]);
          }
        }
        VFControls.VFLineEdit {
          id: parPrimClampSec
          anchors.right: parent.right
          description.text: Z.tr("Mp-Sec:")
          description.width: root.width/10;
          height: root.rowHeight;
          width: root.width/2 - 8;

          entity: root.transformerModule
          controlPropertyName: "PAR_PrimClampSec"
          unit.text: transformerIntrospection.ComponentInfo[controlPropertyName].Unit

          validator: ZDoubleValidator {
            bottom: transformerIntrospection.ComponentInfo[parPrimClampSec.controlPropertyName].Validation.Data[0];
            top: transformerIntrospection.ComponentInfo[parPrimClampSec.controlPropertyName].Validation.Data[1];
            decimals:  GC.ceilLog10Of1DividedByX(transformerIntrospection.ComponentInfo[parPrimClampSec.controlPropertyName].Validation.Data[2]);
          }
        }
      }
      Item {
        width: root.width
        height: root.rowHeight

        VFControls.VFLineEdit {
          id: parDutPrimary
          description.text: Z.tr("X-Prim:")
          description.width: root.width/10;
          height: root.rowHeight;
          width: root.width/2 - 8;

          entity: root.transformerModule
          controlPropertyName: "PAR_DutPrimary"
          unit.text: transformerIntrospection.ComponentInfo[controlPropertyName].Unit

          validator: ZDoubleValidator {
            bottom: transformerIntrospection.ComponentInfo[parDutPrimary.controlPropertyName].Validation.Data[0];
            top: transformerIntrospection.ComponentInfo[parDutPrimary.controlPropertyName].Validation.Data[1];
            decimals: GC.ceilLog10Of1DividedByX(transformerIntrospection.ComponentInfo[parDutPrimary.controlPropertyName].Validation.Data[2]);
          }
        }
        VFControls.VFLineEdit {
          id: parDutSecondary
          anchors.right: parent.right
          description.text: Z.tr("X-Sec:")
          description.width: root.width/10;
          height: root.rowHeight;
          width: root.width/2 - 8;

          entity: root.transformerModule
          controlPropertyName: "PAR_DutSecondary"
          unit.text: transformerIntrospection.ComponentInfo[controlPropertyName].Unit

          validator: ZDoubleValidator {
            bottom: transformerIntrospection.ComponentInfo[parDutSecondary.controlPropertyName].Validation.Data[0];
            top: transformerIntrospection.ComponentInfo[parDutSecondary.controlPropertyName].Validation.Data[1];
            decimals: GC.ceilLog10Of1DividedByX(transformerIntrospection.ComponentInfo[parDutSecondary.controlPropertyName].Validation.Data[2]);
          }
        }
      }
      Item {
        width: root.width
        height: root.rowHeight

        VFControls.VFLineEdit {
          id: parSecClampPrim
          description.text: Z.tr("Ms-Prim:")
          description.width: root.width/10;
          height: root.rowHeight;
          width: root.width/2 - 8;

          entity: root.transformerModule
          controlPropertyName: "PAR_SecClampPrim"
          unit.text: transformerIntrospection.ComponentInfo[controlPropertyName].Unit

          validator: ZDoubleValidator {
            bottom: transformerIntrospection.ComponentInfo[parSecClampPrim.controlPropertyName].Validation.Data[0];
            top: transformerIntrospection.ComponentInfo[parSecClampPrim.controlPropertyName].Validation.Data[1];
            decimals:  GC.ceilLog10Of1DividedByX(transformerIntrospection.ComponentInfo[parSecClampPrim.controlPropertyName].Validation.Data[2]);
          }
        }
        VFControls.VFLineEdit {
          id: parSecClampSec
          description.text: Z.tr("Ms-Sec:")
          description.width: root.width/10;
          height: root.rowHeight;
          width: root.width/2 - 8;
          anchors.right: parent.right

          entity: root.transformerModule
          controlPropertyName: "PAR_SecClampSec"
          unit.text: transformerIntrospection.ComponentInfo[controlPropertyName].Unit

          validator: ZDoubleValidator {
            bottom: transformerIntrospection.ComponentInfo[parSecClampSec.controlPropertyName].Validation.Data[0];
            top: transformerIntrospection.ComponentInfo[parSecClampSec.controlPropertyName].Validation.Data[1];
            decimals: GC.ceilLog10Of1DividedByX(transformerIntrospection.ComponentInfo[parSecClampSec.controlPropertyName].Validation.Data[2]);
          }
        }
      }
    }
  }
}
