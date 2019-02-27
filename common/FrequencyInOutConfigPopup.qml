import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
import VeinEntity 1.0
import "qrc:/components/common" as CCMP
import "qrc:/vf-controls/common" as VFControls
import ModuleIntrospection 1.0
import ZeraTranslation 1.0

Popup {
  id: root
  ///@todo replace with proper model once the frequency routing module is implemented
  property var fInModel: [];
  property var fOutModel: ["FOut0"];
  readonly property int hF_IN_MODEL:  0x01;
  readonly property int hF_OUT_MODEL: 0x02;

  property int modelMode: hF_IN_MODEL | hF_OUT_MODEL;
  function getModel() {
    var retVal = [];
    if(root.modelMode & root.hF_IN_MODEL > 0
        && root.fInModel.length > 0)
    {
      retVal = retVal.concat(root.fInModel)
    }
    if(root.modelMode & root.hF_OUT_MODEL > 0
        && root.fOutModel.length > 0)
    {
      retVal = retVal.concat(root.fOutModel)
    }
    return retVal;
  }

  ListView {
    model: root.getModel();
    anchors.fill: parent;
    anchors.bottomMargin: closeButton.height
    delegate: Rectangle {
      width: parent.width
      height: 64
      color: "transparent"
      border.color: "#22ffffff"
      border.width: 2
      RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        Label {
          Layout.alignment: Qt.AlignVCenter
          text: modelData
          Layout.fillWidth:  true;
        }

        VFControls.VFComboBox {
          arrayMode: true
          controlPropertyName: "PAR_MeasuringMode"
          model: ModuleIntrospection.p1m4Introspection.ComponentInfo.PAR_MeasuringMode.Validation.Data;
          entity: VeinEntity.getEntity("POWER1Module4")

          contentRowHeight: height*0.8
          contentFlow: GridView.FlowTopToBottom
          centerVertical: true
          centerVerticalOffset: height/2
          Layout.alignment: Qt.AlignVCenter
          width: parent.width/6
          height: parent.height*0.8
        }
      }
    }
    boundsBehavior: Flickable.StopAtBounds
  }

  Button {
    id: closeButton
    text: ZTR["Close"]
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    onClicked: close()
  }
}
