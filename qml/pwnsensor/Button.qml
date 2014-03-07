import QtQuick 2.0

Item {
    id: root
    property string text
    signal clicked

    Rectangle{
        width: 96
        height: 32
        color: "blue"
        gradient: Gradient {
            GradientStop { position: 0.0; color: "lightgray" }
            GradientStop { position: 1.0; color: "gray" }
        }
        radius: width/16.
        Text{text: root.text; anchors.centerIn: parent}
        MouseArea {
            anchors.fill: parent
            onClicked: root.clicked()
        }
    }
}
