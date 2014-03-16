import QtQuick 2.0

Item {
    id: root
    property string text: "Label"
    signal clicked

    Rectangle{
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#eeeeee" }
            GradientStop { position: 1.0; color: "#aaaaaa" }
        }
        Rectangle{
            id: highlight
            anchors.fill: parent
            radius: 3
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#ffffff" }
                GradientStop { position: 1.0; color: "#00000000" }
            }
            visible: mouse.containsMouse
        }

        radius: 3
        border.color: "lightgrey"
        border.width: 1
        Text{text: root.text; anchors.centerIn: parent}
        MouseArea {
            id: mouse
            anchors.fill: parent
            hoverEnabled: true
            onClicked: root.clicked()
        }
    }
}
