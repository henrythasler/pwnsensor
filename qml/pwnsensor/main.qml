import QtQuick 2.0
import sensors 1.0

Rectangle {
    width: 640
    height: 480
    color: "black"

    Item{
        anchors.fill: parent
        focus: true
        Keys.onEscapePressed: {
            Qt.quit();
        }

    }

    QLmSensors {
        id: sensors

        function init(){
        }
        Component.onCompleted: init();
    }
}
