import QtQuick 2.0
import VeinEntity 1.0
import GlobalConfig 1.0
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

Item {
  id: root

  Rectangle {
    anchors.fill: parent
    color: Material.background
    opacity: 0.2
  }
  property QtObject dftModule;
  property var rotaryField: []
  onDftModuleChanged: {
    rotaryField = String(dftModule.ACT_RFIELD).split("");
  }

  Repeater {
    model: rotaryField.length
    Text {
      text: rotaryField[index];
      color: GC.systemColorByIndex(parseInt(rotaryField[index]));
      font.pixelSize: root.height/1.8
      x: 2 + (root.width/3 * index)
      anchors.verticalCenter: parent.verticalCenter
    }
  }
}