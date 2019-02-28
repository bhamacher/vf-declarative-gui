import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import GlobalConfig 1.0
import VeinEntity 1.0
import ZeraTranslation 1.0
import "qrc:/qml/controls" as CCMP
import "qrc:/data/staticdata/FontAwesome.js" as FA

Item {
  id: root
  property var model;
  property alias sessionComponent: sessionSelector.intermediate
  property string pageLoaderSource;

  property bool gridViewEnabled: GC.pagesGridViewDisplay;
  onGridViewEnabledChanged: GC.setPagesGridViewDisplay(gridViewEnabled);

  signal closeView();
  signal sessionChanged();

  Rectangle {
    color: Material.backgroundColor
    opacity: 0.7
    anchors.fill: parent
  }

  Button {
    font.family: "FontAwesome"
    font.pointSize: 18
    text: FA.icon(FA.fa_image)
    anchors.right: gridViewButton.left
    anchors.rightMargin: 8
    flat: true
    enabled: root.gridViewEnabled === true
    onClicked: root.gridViewEnabled = false;
  }
  Button {
    id: gridViewButton
    font.family: "FontAwesome"
    font.pointSize: 18
    text: FA.icon(FA.fa_list_ul)
    anchors.right: parent.right
    anchors.rightMargin: 32
    flat: true
    enabled: root.gridViewEnabled === false
    onClicked: root.gridViewEnabled = true;
  }

  Component {
    id: pageGridViewCmp
    CCMP.PageGridView {
      model: root.model

      onModelChanged: {
        if(model && model.count>0)
        {
          root.pageLoaderSource = model.get(0).elementValue;
        }
      }

      onElementSelected: {
        if(elementValue !== "")
        {
          root.pageLoaderSource = elementValue.value
          root.closeView();
        }
      }
    }
  }

  Component {
    id: pagePathViewCmp
    CCMP.PagePathView {
      model: root.model

      onModelChanged: {
        if(model && model.count>0)
        {
          root.pageLoaderSource = model.get(0).elementValue;
        }
      }

      onElementSelected: {
        if(elementValue !== "")
        {
          root.pageLoaderSource = elementValue.value
          root.closeView();
        }
      }
    }
  }

  Loader {
    anchors.fill: parent
    sourceComponent: root.gridViewEnabled ? pageGridViewCmp : pagePathViewCmp;
    active: root.visible === true && root.model !== undefined;
  }

  Button {
    height: root.height/10
    width: height*3
    Material.accent: Material.color(Material.Red)
    highlighted: true
    font.family: "FontAwesome"
    font.pixelSize: 20
    text: FA.icon(FA.fa_times) + ZTR["Close"]
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.bottom
    onClicked: root.closeView()
  }

  Rectangle {
    anchors.top: root.top
    anchors.left: root.left
    height: root.height/10
    width: root.width/3
    color: Material.dropShadowColor
    visible: sessionSelector.model.length > 1

    CCMP.ZComboBox {
      id: sessionSelector

      property QtObject systemEntity;
      property string intermediate


      anchors.fill: parent
      arrayMode: true
      onIntermediateChanged: {
        var tmpIndex = model.indexOf(intermediate)

        if(tmpIndex !== undefined && sessionSelector.currentIndex !== tmpIndex)
        {
          sessionSelector.currentIndex = tmpIndex
        }
      }

      onSelectedTextChanged: {
        var tmpIndex = model.indexOf(selectedText)
        //console.assert(tmpIndex >= 0 && tmpIndex < model.length)
        if(systemEntity && systemEntity.SessionsAvailable)
        {
          systemEntity.Session = systemEntity.SessionsAvailable[tmpIndex];
        }

        root.sessionChanged()
        layoutStack.currentIndex=0;
        rangeIndicator.active = false;
        pageLoader.active = false;
        entitiesInitialized = false;
        loadingScreen.open();
      }

      model: {
        var retVal = [];
        if(systemEntity && systemEntity.SessionsAvailable) {
          for(var sessionIndex in systemEntity.SessionsAvailable)
          {
            retVal.push(systemEntity.SessionsAvailable[sessionIndex]);
          }
        }
        else {
          retVal = ["Default session", "Reference session", "CED session"]; //fallback
        }

        return retVal;
      }

      Connections {
        target: VeinEntity
        onSigEntityAvailable: {
          if(t_entityName === "_System")
          {
            sessionSelector.systemEntity = VeinEntity.getEntity("_System");
          }
        }
      }
    }
  }
}
