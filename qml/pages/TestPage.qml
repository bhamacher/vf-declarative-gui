import QtQuick 2.5
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import VeinEntity 1.0
import ZeraTranslation  1.0
import GlobalConfig 1.0
import ModuleIntrospection 1.0
import "qrc:/qml/controls" as CCMP
import "qrc:/qml/vf-controls" as VFControls
import "qrc:/data/staticdata/FontAwesome.js" as FA

CCMP.ModulePage {
  id: root
  clip: true

  Label {
      anchors.horizontalCenter: parent.horizontalCenter
      text: VeinEntity.getEntity("Burden1Module1")["ACT_Burden2"]
  }

  VFControls.VFComboBox {
      width: parent.width / 4
      height: parent.height / 10
      anchors.centerIn: parent
      entity: VeinEntity.getEntity("SEC1Module1")
      controlPropertyName: "PAR_RefInput"
      model: ModuleIntrospection.sec1Introspection.ComponentInfo.PAR_RefInput.Validation.Data
      arrayMode: true
  }
}
