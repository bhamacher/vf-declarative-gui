import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import VeinEntity 1.0
import ZeraTranslation  1.0
import GlobalConfig 1.0
import ModuleIntrospection 1.0
import "qrc:/qml/controls" as CCMP
import ZeraVeinComponents 1.0 as VFControls

CCMP.ModulePage {
  id: root

  readonly property int row1stHeight: Math.floor(height/8)
  readonly property int rowHeight: Math.floor((height-2*row1stHeight)/3)

  readonly property int firstColumnWidth: width*0.05
  readonly property int valueColumnWidth: width*0.22
  readonly property int lastColumnWidth: width-firstColumnWidth-4*valueColumnWidth


  readonly property QtObject power1Module1: VeinEntity.getEntity("POWER1Module1")
  readonly property QtObject power1Module2: VeinEntity.getEntity("POWER1Module2")
  readonly property QtObject power1Module3: VeinEntity.getEntity("POWER1Module3")

  //the function exists because it is impossible to use scripted value in ListModel
  function getModule(index) {
    var retVal;
    switch(index) {
    case 0:
      retVal = power1Module1;
      break;
    case 1:
      retVal = power1Module2;
      break;
    case 2:
      retVal = power1Module3;
      break;
    }
    return retVal;
  }

  //the function exists because it is impossible to use scripted value in ListModel
  function getMetadata(index) {
    var retVal;
    switch(index) {
    case 0:
      retVal = ModuleIntrospection.p1m1Introspection;
      break;
    case 1:
      retVal = ModuleIntrospection.p1m2Introspection;
      break;
    case 2:
      retVal = ModuleIntrospection.p1m3Introspection;
      break;
    }
    return retVal
  }

  Row {
    id: heardersRow
    height: root.row1stHeight
    CCMP.GridRect {
      width: firstColumnWidth
      height: parent.height
      color: GC.tableShadeColor
      //spacer
    }
    CCMP.GridItem {
      width: valueColumnWidth
      height: parent.height
      color: GC.tableShadeColor
      text: Z.tr("L1")
      textColor: GC.colorUL1
      font.pixelSize: rowHeight*0.4
    }
    CCMP.GridItem {
      width: valueColumnWidth
      height: parent.height
      color: GC.tableShadeColor
      text: Z.tr("L2")
      textColor: GC.colorUL2
      font.pixelSize: rowHeight*0.4
    }
    CCMP.GridItem {
      width: valueColumnWidth
      height: parent.height
      color: GC.tableShadeColor
      text: Z.tr("L3")
      textColor: GC.colorUL3
      font.pixelSize: rowHeight*0.4
    }
    CCMP.GridItem {
      width: valueColumnWidth
      height: parent.height
      color: GC.tableShadeColor
      text: "Σ"
      font.pixelSize: rowHeight*0.4
    }
    CCMP.GridItem {
      width: lastColumnWidth
      height: parent.height
      color: GC.tableShadeColor
      text: "[ ]"
      font.pixelSize: rowHeight*0.3
    }
  }

  ListView {
    id: listView
    anchors.top: heardersRow.bottom
    height: root.rowHeight*count
    width: parent.width
    //used number as model since the ListModel cannot use scripted values
    model: 3
    boundsBehavior: ListView.StopAtBounds
    interactive: false

    delegate: Component {
      Row {
        height: root.rowHeight
        CCMP.GridItem {
          width: firstColumnWidth
          height: parent.height
          color: GC.tableShadeColor
          text: (root.getMetadata(index).ComponentInfo.ACT_PQS1.ChannelName).slice(0,1); //(P/Q/S)1 -> (P/Q/S)
          font.pixelSize: height*0.4

        }
        CCMP.GridItem {
          width: valueColumnWidth
          height: parent.height
          clip: true
          text: GC.formatNumber(root.getModule(index).ACT_PQS1);
          textColor: GC.colorUL1
          font.pixelSize: height*0.4
        }
        CCMP.GridItem {
          width: valueColumnWidth
          height: parent.height
          clip: true
          text: GC.formatNumber(root.getModule(index).ACT_PQS2);
          textColor: GC.colorUL2
          font.pixelSize: height*0.4
        }
        CCMP.GridItem {
          width: valueColumnWidth
          height: parent.height
          clip: true
          text: GC.formatNumber(root.getModule(index).ACT_PQS3);
          textColor: GC.colorUL3
          font.pixelSize: height*0.4
        }
        CCMP.GridItem {
          width: valueColumnWidth
          height: parent.height
          clip: true
          text: GC.formatNumber(root.getModule(index).ACT_PQS4);
          font.pixelSize: height*0.4
        }
        CCMP.GridItem {
          width: lastColumnWidth
          height: parent.height
          clip: true
          text: root.getMetadata(index).ComponentInfo.ACT_PQS1.Unit
          font.pixelSize: height*0.25
        }
      }
    }
  }
  Row {
    id: footerRow
    height: root.row1stHeight
    width: parent.width
    anchors.top: listView.bottom
    CCMP.GridRect {
      id: measModeGrid
      width: parent.width
      height: parent.height
      Label {
        id: labelMMode
        text: Z.tr("Measuring modes:")
        width: root.firstColumnWidth+root.valueColumnWidth-GC.standardTextHorizMargin
        anchors.left: parent.left
        anchors.leftMargin: GC.standardTextHorizMargin
        anchors.verticalCenter: parent.verticalCenter
        font.pixelSize: parent.height*0.4
      }

      Repeater {
        model: 3
        Item {
          anchors.top: parent.top
          anchors.bottom: parent.bottom
          x: root.firstColumnWidth+root.valueColumnWidth*(index+1)
          width: root.valueColumnWidth
          Label {
            text: (root.getMetadata(modelData).ComponentInfo.ACT_PQS1.ChannelName).slice(0,1); //(P/Q/S)1 -> (P/Q/S)
            height: parent.height
            anchors.right: measModeCombo.left
            anchors.rightMargin: GC.standardTextHorizMargin
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: measModeGrid.height*0.4
          }
          VFControls.VFComboBox {
            id: measModeCombo
            width: parent.width * 2 / 3
            height: parent.height
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            centerVerticalOffset: -parent.height*(modelLength-1)
            arrayMode: true
            entity: root.getModule(index)
            controlPropertyName: "PAR_MeasuringMode"
            model: root.getMetadata(index).ComponentInfo.PAR_MeasuringMode.Validation.Data
            fontSize: height*0.4
          }
        }
      }
    }
  }
}
