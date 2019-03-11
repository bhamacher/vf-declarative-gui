import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import VeinEntity 1.0
import GlobalConfig 1.0
import ZeraTranslation  1.0
import "qrc:/qml/controls" as CCMP

CCMP.ModulePage {
  id: root

  readonly property int rowHeight: Math.floor(height/8)
  readonly property int basicRowWidth: width/10
  readonly property int wideRowWidth: width/7

  readonly property QtObject dftModule: VeinEntity.getEntity("DFTModule1")

  Row {
    id: heardersRow
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: root.top
    anchors.topMargin: root.height/2-rowHeight
    CCMP.GridItem {
      width: wideRowWidth
      height: root.rowHeight
      color: GC.tableShadeColor
      text: ZTR["REF1"]
      font.bold: true
      font.pixelSize: height*0.3
    }
    CCMP.GridItem {
      width: wideRowWidth
      height: root.rowHeight
      color: GC.tableShadeColor
      text: ZTR["REF2"]
      font.bold: true
      font.pixelSize: height*0.3
    }
    CCMP.GridItem {
      width: wideRowWidth
      height: root.rowHeight
      color: GC.tableShadeColor
      text: ZTR["REF3"]
      font.bold: true
      font.pixelSize: height*0.3
    }
    CCMP.GridItem {
      width: wideRowWidth
      height: root.rowHeight
      color: GC.tableShadeColor
      text: ZTR["REF4"]
      font.bold: true
      font.pixelSize: height*0.3
    }
    CCMP.GridItem {
      width: wideRowWidth
      height: root.rowHeight
      color: GC.tableShadeColor
      text: ZTR["REF5"]
      font.bold: true
      font.pixelSize: height*0.3
    }
    CCMP.GridItem {
      width: wideRowWidth
      height: root.rowHeight
      color: GC.tableShadeColor
      text: ZTR["REF6"]
      font.bold: true
      font.pixelSize: height*0.3
    }
    CCMP.GridItem {
      width: basicRowWidth
      height: root.rowHeight
      color: GC.tableShadeColor
      text: "[ ]"
      font.bold: true
      font.pixelSize: height*0.3
    }
  }

  ListView {
    anchors.top: heardersRow.bottom
    anchors.left: heardersRow.left
    height: root.rowHeight*count
    width: parent.width
    //used number as model since the ListModel cannot use scripted values
    model: 1
    boundsBehavior: ListView.StopAtBounds
    interactive: false

    delegate: Component {
      Row {
        CCMP.GridItem {
          width: wideRowWidth
          height: root.rowHeight
          clip: true
          text: GC.formatNumber(dftModule.ACT_DFTPN1[0], 6); //these values are RE,IM vectors of a measured DC quantity, so only the RE part is relevant
          textColor: GC.groupColorReference
          font.pixelSize: height*0.3
        }
        CCMP.GridItem {
          width: wideRowWidth
          height: root.rowHeight
          clip: true
          text: GC.formatNumber(dftModule.ACT_DFTPN2[0], 6); //these values are RE,IM vectors of a measured DC quantity, so only the RE part is relevant
          textColor: GC.groupColorReference
          font.pixelSize: height*0.3
        }
        CCMP.GridItem {
          width: wideRowWidth
          height: root.rowHeight
          clip: true
          text: GC.formatNumber(dftModule.ACT_DFTPN3[0], 6); //these values are RE,IM vectors of a measured DC quantity, so only the RE part is relevant
          textColor: GC.groupColorReference
          font.pixelSize: height*0.3
        }
        CCMP.GridItem {
          width: wideRowWidth
          height: root.rowHeight
          clip: true
          text: GC.formatNumber(dftModule.ACT_DFTPN4[0], 6); //these values are RE,IM vectors of a measured DC quantity, so only the RE part is relevant
          textColor: GC.groupColorReference
          font.pixelSize: height*0.3
        }
        CCMP.GridItem {
          width: wideRowWidth
          height: root.rowHeight
          clip: true
          text: GC.formatNumber(dftModule.ACT_DFTPN5[0], 6); //these values are RE,IM vectors of a measured DC quantity, so only the RE part is relevant
          textColor: GC.groupColorReference
          font.pixelSize: height*0.3
        }
        CCMP.GridItem {
          width: wideRowWidth
          height: root.rowHeight
          clip: true
          text: GC.formatNumber(dftModule.ACT_DFTPN6[0], 6); //these values are RE,IM vectors of a measured DC quantity, so only the RE part is relevant
          textColor: GC.groupColorReference
          font.pixelSize: height*0.3
        }
        CCMP.GridItem {
          width: basicRowWidth
          height: root.rowHeight
          text: "V"
          font.bold: true
          font.pixelSize: height*0.3
        }
      }
    }
  }
}