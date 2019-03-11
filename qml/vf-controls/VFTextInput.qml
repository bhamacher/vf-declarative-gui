import QtQuick 2.0
import QtQuick.Controls.Material 2.0
import QtQuick.Controls 2.0
import GlobalConfig 1.0

Item {
  id: root

  property alias fontSize: tInput.font.pixelSize
  property alias placeholderText: tInput.placeholderText
  readonly property alias contentWidth: tInput.contentWidth
  property alias horizontalAlignment: tInput.horizontalAlignment
  property alias mouseSelectionMode: tInput.mouseSelectionMode
  readonly property bool m_alteredValue: tInput.text !== transformIncoming(entity[controlPropertyName])
  readonly property alias acceptableInput: tInput.acceptableInput
  property QtObject entity
  property string controlPropertyName
  property string text: ""
  property alias inputMethodHints: tInput.inputMethodHints;
  property var validator

  //allows to convert the output in other formats before setting the component value
  function transformOutgoing (t_output) {
    return t_output;
  }

  //allows to convert the incoming data to other formats that fit the validator
  function transformIncoming(t_incoming) {
    return t_incoming;
  }

  function confirmInput() {
    if(tInput.text !== root.text && root.acceptableInput)
    {
      root.entity[root.controlPropertyName] = transformOutgoing(tInput.text);
    }
  }

  onTextChanged: tInput.text = text;
  onValidatorChanged: tInput.validator = validator;

  Item {
    property var intermediateValue: transformIncoming(root.entity[root.controlPropertyName])
    onIntermediateValueChanged: {
      tInput.text = intermediateValue
      root.text = intermediateValue
    }
  }

  Item {
    anchors.left: parent.left
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    anchors.right: acceptButton.left
    anchors.rightMargin: 8

    //radius: height/4
    //border.color: Material.frameColor
    //border.width: 1.5
    //color: root.m_alteredValue ? (root.acceptableInput ? Material.primaryColor : Material.backgroundDimColor) : "transparent"

    TextField {
      id: tInput
      anchors.fill: parent
      anchors.bottomMargin: -8
      anchors.leftMargin: height/4
      anchors.rightMargin: height/4
      implicitHeight: Math.max(contentHeight + topPadding + bottomPadding,
                               background ? background.implicitHeight : 0)

      font.pixelSize: Math.max(height/2, 16)
      mouseSelectionMode: TextInput.SelectWords
      selectByMouse: true
      onAccepted: {
        focus = false
        confirmInput()
      }

      //color: Material.primaryTextColor
    }
  }

  Button {
    id: acceptButton
    text: "\u2713" //unicode checkmark
    font.pixelSize: Math.max(height/2, 20)

    implicitHeight: 0
    width: height*1.2
    //only show the button if the value is different from the remote
    highlighted: true

    anchors.right: resetButton.left
    anchors.rightMargin: 8
    anchors.bottom: parent.bottom
    anchors.top: parent.top

    onClicked: {
      focus = true
      confirmInput()
    }
    enabled: root.acceptableInput && root.m_alteredValue
  }
  Button {
    id: resetButton
    text: "\u00D7" //unicode x mark
    font.pixelSize: Math.max(height/2, 20)

    implicitHeight: 0
    width: height*1.2
    //only show the button if the value is different from the remote
    enabled: root.m_alteredValue
    anchors.right: parent.right
    anchors.rightMargin: 8
    anchors.bottom: parent.bottom
    anchors.top: parent.top
    onClicked: {
      focus = true
      tInput.text = transformIncoming(root.entity[root.controlPropertyName]);
    }
  }
}