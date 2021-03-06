import QtQuick 2.0
import QtQuick.Controls 2.0
import VeinEntity 1.0
import QtQuick.Controls.Material 2.0
import QtGraphicalEffects 1.0
import ModuleIntrospection 1.0
import GlobalConfig 1.0
import ZeraTranslation  1.0
import ZeraVeinComponents 1.0 as VFControls

Item {
  id: root

  readonly property QtObject rangeModule: VeinEntity.getEntity("RangeModule1")
  readonly property bool groupingActive: groupingMode.checked
  readonly property int channelCount: ModuleIntrospection.rangeIntrospection.ModuleInfo.ChannelCount
  //convention that channels are numbered by unit was broken, so do some $%!7 to get the right layout
  readonly property var upperChannels: {
    var retVal = [];
    for(var channelNum=0; channelNum<channelCount; ++channelNum)
    {
      var name = ModuleIntrospection.rangeIntrospection.ComponentInfo["PAR_Channel"+parseInt(channelNum+1)+"Range"].ChannelName;
      var unit = ModuleIntrospection.rangeIntrospection.ComponentInfo["PAR_Channel"+parseInt(channelNum+1)+"Range"].Unit;
      if(name.indexOf("REF") === 0) //equivalent of startsWith that is only available in Qt 5.9
      {
        if(channelNum<3)//REF1..REF3
        {
          retVal.push(channelNum);
        }
      }
      else if(unit === "V")//UL1..UL3 +UAUX
      {
        retVal.push(channelNum)
      }
    }
    return retVal;
  }
  readonly property var lowerChannels: {
    var retVal = [];
    for(var channelNum=0; channelNum<channelCount; ++channelNum)
    {
      var name = ModuleIntrospection.rangeIntrospection.ComponentInfo["PAR_Channel"+parseInt(channelNum+1)+"Range"].ChannelName;
      var unit = ModuleIntrospection.rangeIntrospection.ComponentInfo["PAR_Channel"+parseInt(channelNum+1)+"Range"].Unit;
      if(name.indexOf("REF") === 0) //equivalent of startsWith that is only available in Qt 5.9
      {
        if(channelNum>=3)//REF3..REF6
        {
          retVal.push(channelNum);
        }
      }
      else if(unit === "A")//IL1..IL3 +IAUX
      {
        retVal.push(channelNum)
      }
    }
    return retVal;
  }

  anchors.leftMargin: 300
  anchors.rightMargin: 300

  Item {
    id: grid

    property real cellHeight: height/15
    property real cellWidth: width/16

    function getColorByIndex(rangIndex) {
      var retVal;
      if(autoMode.checked)
      {
        retVal = "gray"
      }
      else if(groupingMode.checked)
      {
        var channelName = ModuleIntrospection.rangeIntrospection.ComponentInfo["PAR_Channel"+rangIndex+"Range"].ChannelName;
        if(ModuleIntrospection.rangeIntrospection.ModuleInfo.ChannelGroup1.indexOf(channelName)>-1)
        {
          retVal = GC.groupColorVoltage
        }
        else if(ModuleIntrospection.rangeIntrospection.ModuleInfo.ChannelGroup2.indexOf(channelName)>-1)
        {
          retVal = GC.groupColorCurrent
        }
        else if(ModuleIntrospection.rangeIntrospection.ModuleInfo.ChannelGroup3.indexOf(channelName)>-1)
        {
          retVal = GC.groupColorReference
        }
      }
      else
      {
        retVal = GC.systemColorByIndex(rangIndex)
      }
      return retVal;
    }

    anchors.fill: parent
    anchors.margins: parent.width*0.02

    Label {
      text: Z.tr("Range automatic:")
      y: grid.cellHeight*0.75
      height: grid.cellHeight*2
      width: grid.cellWidth*4
      font.pixelSize: Math.min(18, root.height/20, width/6.5)
      color: VeinEntity.getEntity("_System").Session !== "com5003-ref-session.json" ? Material.primaryTextColor : Material.hintTextColor
    }
    VFControls.VFSwitch {
      id: autoMode
      x: grid.cellWidth*5
      height: grid.cellHeight*2
      width: grid.cellWidth*4
      entity: root.rangeModule
      controlPropertyName: "PAR_RangeAutomatic"
      enabled: VeinEntity.getEntity("_System").Session !== "com5003-ref-session.json"
    }
    Button {
      id: overloadButton
      property int overload: root.rangeModule.PAR_Overload

      text: Z.tr("Overload")
      enabled: overload
      x: grid.cellWidth*16 - width
      height: grid.cellHeight * 2
      width: grid.cellWidth * 4
      font.pixelSize: Math.min(14, root.height/24, width/8)

      onClicked: {
        root.rangeModule.PAR_Overload = 0;
      }

      background: Rectangle {
        implicitWidth: 64
        implicitHeight: 48

        // external vertical padding is 6 (to increase touch area)
        y: 6
        width: parent.width
        height: parent.height - 12
        radius: 2

        color: overloadButton.overload ? "darkorange" : Material.switchDisabledHandleColor

        Behavior on color {
          ColorAnimation {
            duration: 400
          }
        }
      }
    }
    Label {
      text: Z.tr("Range grouping:")
      y: grid.cellHeight*2.75
      height: grid.cellHeight*2
      width: grid.cellWidth*4
      font.pixelSize: Math.min(18, root.height/20, width/6.5)
      color: VeinEntity.getEntity("_System").Session !== "com5003-ref-session.json" ? Material.primaryTextColor : Material.hintTextColor
    }
    VFControls.VFSwitch {
      id: groupingMode
      y: grid.cellHeight*2
      x: grid.cellWidth*5
      height: grid.cellHeight*2
      width: grid.cellWidth*4
      entity: root.rangeModule
      enabled: VeinEntity.getEntity("_System").Session !== "com5003-ref-session.json"
      controlPropertyName: "PAR_ChannelGrouping"
    }
    Label {
      text: Z.tr("Manual:")
      font.pixelSize: Math.min(18, root.height/20)
      enabled: !autoMode.checked
      color: enabled ? Material.primaryTextColor : Material.hintTextColor
      y: grid.cellHeight*5
      height: grid.cellHeight
      width: grid.cellWidth*16
    }

    ListView {
      model: root.upperChannels
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      anchors.bottomMargin: height*2
      height: grid.cellHeight*3
      boundsBehavior: Flickable.StopAtBounds

      orientation: ListView.Horizontal

      delegate: Item {
        height: grid.cellHeight*3
        width: grid.cellWidth*4
        Label {
          text: ModuleIntrospection.rangeIntrospection.ComponentInfo["PAR_Channel"+parseInt(modelData+1)+"Range"].ChannelName
          color: GC.getColorByIndex(modelData+1, root.groupingActive)
          anchors.bottom: parent.top
          anchors.bottomMargin: -(parent.height/3)
          anchors.horizontalCenter: parent.horizontalCenter
        }
        VFControls.VFComboBox {
          //UL1-UL3 +UAUX
          arrayMode: true
          entity: root.rangeModule
          controlPropertyName: "PAR_Channel"+parseInt(modelData+1)+"Range"
          model: ModuleIntrospection.rangeIntrospection.ComponentInfo["PAR_Channel"+parseInt(modelData+1)+"Range"].Validation.Data
          centerVertical: true
          centerVerticalOffset:  model.length>2 ? 0 : height
          anchors.bottom: parent.bottom
          anchors.horizontalCenter: parent.horizontalCenter
          anchors.top: parent.top
          anchors.topMargin: parent.height/3
          width: parent.width*0.95
          enabled: parent.enabled
          fontSize: Math.min(18, root.height/20, width/6)
        }
      }
    }
    ListView {
      model: root.lowerChannels
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      anchors.bottomMargin: height
      height: grid.cellHeight*3
      boundsBehavior: Flickable.StopAtBounds

      orientation: ListView.Horizontal

      delegate: Item {
        height: grid.cellHeight*3
        width: grid.cellWidth*4
        Label {
          text: ModuleIntrospection.rangeIntrospection.ComponentInfo["PAR_Channel"+parseInt(modelData+1)+"Range"].ChannelName
          color: GC.getColorByIndex(modelData+1, root.groupingActive)
          anchors.bottom: parent.top
          anchors.bottomMargin: -(parent.height/3)
          anchors.horizontalCenter: parent.horizontalCenter
        }
        VFControls.VFComboBox {
          //IL1-IL3 +IAUX
          arrayMode: true
          entity: root.rangeModule
          controlPropertyName: "PAR_Channel"+parseInt(modelData+1)+"Range"
          model: ModuleIntrospection.rangeIntrospection.ComponentInfo["PAR_Channel"+parseInt(modelData+1)+"Range"].Validation.Data

          contentMaxRows: model.length>4 ? (model.length>9 ? Math.min(model.length, 8) : Math.ceil(model.length/2)) : 0
          contentFlow: GridView.FlowTopToBottom
          contentRowHeight: height

          centerVertical: true
          centerVerticalOffset: model.length>2 ? (model.length>9 ? -height*1.25 : 0 ) : height
          anchors.bottom: parent.bottom
          anchors.horizontalCenter: parent.horizontalCenter
          anchors.top: parent.top
          anchors.topMargin: parent.height/3
          width: parent.width*0.95
          enabled: parent.enabled
          fontSize: Math.min(18, root.height/20, width/6)
        }
      }
    }
  }
}
