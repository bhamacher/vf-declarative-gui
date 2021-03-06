import QtQuick 2.5
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.0
import VeinEntity 1.0
import ZeraTranslation  1.0
import GlobalConfig 1.0
import ZeraVeinComponents 1.0 as VFControls
import ZeraFa 1.0

Item {
  id: root

  readonly property int rowHeight: Math.floor(height/20)
  property var errorDataModel: [];

  TabBar {
    id: informationSelector
    width: parent.width
    height: root.rowHeight*1.5
    currentIndex: 0
    TabButton {
      id: deviceStatusButton
      text: FA.icon(FA.fa_info_circle)+Z.tr("Device info")
      font.family: FA.old
      height: parent.height
      font.pixelSize: height/2
      enabled: VeinEntity.hasEntity("StatusModule1")
      Material.foreground: GC.adjustmentStatusOk ? Material.White : Material.Red
      Timer {
          interval: 300
          repeat: true
          running: !GC.adjustmentStatusOk && !deviceStatusButton.checked
          onRunningChanged: {
              if(!running) {
                  deviceStatusButton.opacity = 1
              }
          }
          property bool show: true
          onTriggered: {
              show = !show
              deviceStatusButton.opacity = show ? 1 : 0
          }
      }
    }
    TabButton {
      text: FA.icon("<b>§</b>")+Z.tr("License information")
      font.family: FA.old
      height: parent.height
      font.pixelSize: height/2
    }
    TabButton {
      id: errorLogButton
      text: FA.icon(FA.fa_exclamation_triangle, GC.tmpStatusNewErrors ? Material.color(Material.Yellow) : "#44ffffff" )+Z.tr("Device log")
      font.family: FA.old
      height: parent.height
      font.pixelSize: height/2
    }
  }

  StackLayout {
    id: stackLayout
    anchors.fill: parent
    anchors.topMargin: informationSelector.height + root.rowHeight/2
    currentIndex: informationSelector.currentIndex

    Loader {
      active: stackLayout.currentIndex === 0 && VeinEntity.hasEntity("StatusModule1")
      sourceComponent: DeviceInformation {
      }
    }
    Loader {
      active: stackLayout.currentIndex === 1
      sourceComponent: LicenseInformation {
      }
    }
    Loader {
      active: stackLayout.currentIndex === 2
      sourceComponent: Notifications {
        errorDataModel: root.errorDataModel
      }
      onActiveChanged: {
        if(active === false)
        {
          GC.tmpStatusNewErrors = false;
        }
      }
      Component.onDestruction: GC.tmpStatusNewErrors = false;
    }
  }
}
