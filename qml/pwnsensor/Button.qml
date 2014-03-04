import QtQuick 2.0

Item {
    id: root
    property string text
    signal clicked

    Rectangle{
        width: 96
        height: 32
        color: "blue"
        radius: width/10
        Text{text: root.text; anchors.centerIn: parent}
        MouseArea {
            anchors.fill: parent
            onClicked: root.clicked()
        }
    }
}
