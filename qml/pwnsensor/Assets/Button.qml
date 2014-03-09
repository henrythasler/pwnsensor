import QtQuick 2.0

Item {
    id: root
    property string label: "Label"
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
            color:"#55ffffff"
            visible: mouse.containsMouse
        }

        radius: 3
        border.color: "lightgrey"
        Text{text: root.label; anchors.centerIn: parent}
        MouseArea {
            id: mouse
            anchors.fill: parent
            hoverEnabled: true
            onClicked: root.clicked()
        }
    }
}
