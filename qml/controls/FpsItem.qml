import QtQuick 2.4
import QtQuick.Window 2.2
import QtQuick.Controls 2.0

/**
  * @b Blatantly copied from qnanopainter example
  */
Item {
    id: root
    property int frameCounter: 0
    property int frameCounterAvg: 0
    property int counter: 0
    property int fps: 0
    property int fpsAvg: 0

    readonly property real dp: Screen.pixelDensity * 25.4/160

    Image {
        id: spinnerImage
        anchors.verticalCenter: parent.verticalCenter
        width: 36 * dp
        height: width
        source: "qrc:/data/staticdata/resources/spinner.png"
        mipmap: true
        NumberAnimation on rotation {
            from:0
            to: 360
            duration: 800
            loops: Animation.Infinite
        }
        onRotationChanged: frameCounter++;
    }

    Label {
        anchors.left: spinnerImage.right
        anchors.leftMargin: 8 * dp
        anchors.verticalCenter: spinnerImage.verticalCenter
        text: "Ø " + root.fpsAvg + " | " + root.fps + " fps"
    }

    Timer {
        interval: 2000
        repeat: true
        running: true
        onTriggered: {
            frameCounterAvg += frameCounter;
            root.fps = frameCounter/2;
            counter++;
            frameCounter = 0;
            if (counter >= 3) {
                root.fpsAvg = frameCounterAvg/(2*counter)
                frameCounterAvg = 0;
                counter = 0;
            }
        }
    }
}
