import QtQuick 2.0

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
}
