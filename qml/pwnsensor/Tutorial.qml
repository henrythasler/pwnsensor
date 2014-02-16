import QtQuick 2.0
import QtQuick.Controls 1.1

Item {
    anchors.fill: parent
    Rectangle{
        x: -121
        y: -135
        width: 396
        height: 240

        Button {
            id: button1
            x: 303
            y: 205
            text: qsTr("Continue")
        }
    }

    Text{text: "Tutorial"}
}
