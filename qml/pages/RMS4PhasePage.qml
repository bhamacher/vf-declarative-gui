import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import VeinEntity 1.0
import GlobalConfig 1.0
import ZeraGlueLogic 1.0
import SortFilterProxyModel 0.2
import ModuleIntrospection 1.0
import ZeraTranslation  1.0
import "qrc:/qml/controls" as CCMP

CCMP.ModulePage {
  id: root

  readonly property int channelCount: ModuleIntrospection.rmsIntrospection.ModuleInfo.RMSPNCount;
  readonly property int row1stHeight: Math.floor(height/8)
  readonly property int rowHeight: Math.floor((height-row1stHeight)/4)
  readonly property int columnWidth1st: pixelSize * 2.3
  readonly property int columnWidthLast: pixelSize * 1.3
  readonly property int columnWidth: (width-(columnWidth1st+columnWidthLast))/(channelCount/2)
  readonly property int pixelSize: (channelCount>6 ? rowHeight*0.36 : rowHeight*0.45)

  SortFilterProxyModel {
    id: filteredActualValueModel
    sourceModel: ZGL.ActualValueModel

    filters: [
      RegExpFilter {
        roleName: "Name"
        // specify by Name-role (1st column) what to see (leading empty string for header row
        pattern: "^$|^"+ZTR["UPN"]+"$|^"+ZTR["I"]+"$|^"+ZTR["∠U"]+"$|^"+ZTR["∠I"]+"$"
        caseSensitivity: Qt.CaseInsensitive
      }
    ]
  }

  Item {
    anchors.fill: parent
    ListView {
      anchors.fill: parent
      model: filteredActualValueModel //ZGL.ActualValueModel
      boundsBehavior: Flickable.StopAtBounds

      delegate: Component {
        Row {
          height: index === 0 ? root.row1stHeight : root.rowHeight
          CCMP.GridItem {
            width: root.columnWidth1st
            height: parent.height
            color: GC.tableShadeColor
            text: Name!==undefined ? Name : ""
            font.pixelSize: root.pixelSize
          }
          CCMP.GridItem {
            width: root.columnWidth
            height: parent.height
            color: index === 0 ? GC.tableShadeColor : Material.backgroundColor
            text: L1!==undefined ? GC.formatNumber(L1) : ""
            textColor: GC.colorUL1
            font.pixelSize: root.pixelSize
          }
          CCMP.GridItem {
            width: root.columnWidth
            height: parent.height
            color: index === 0 ? GC.tableShadeColor : Material.backgroundColor
            text: L2!==undefined ? GC.formatNumber(L2) : ""
            textColor: GC.colorUL2
            font.pixelSize: root.pixelSize
          }
          CCMP.GridItem {
            width: root.columnWidth
            height: parent.height
            color: index === 0 ? GC.tableShadeColor : Material.backgroundColor
            text: L3!==undefined ? GC.formatNumber(L3) : ""
            textColor: GC.colorUL3
            font.pixelSize: root.pixelSize
          }
          CCMP.GridItem {
            width: root.columnWidth
            height: parent.height
            color: index === 0 ? GC.tableShadeColor : Material.backgroundColor
            text: AUX!==undefined ? GC.formatNumber(AUX) : ""
            textColor: GC.colorUAux1
            font.pixelSize: root.pixelSize
            visible: channelCount > 6
          }
          CCMP.GridItem {
            width: root.columnWidthLast
            height: parent.height
            color: index === 0 ? GC.tableShadeColor : Material.backgroundColor
            text: Unit ? Unit : ""
            font.pixelSize: root.pixelSize
          }
        }
      }
    }
  }
}
