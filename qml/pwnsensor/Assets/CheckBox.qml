import QtQuick 2.0

// References
// [1] http://qt-project.org/doc/qt-5.0/qtquick/accessibility-content-checkbox-qml.html

Item {
    id: checkbox
    property bool checked // required variable
    property string text
    width: 12
    height: 12
    property int mark: 6

    Rectangle {
            width: checkbox.width
            height: checkbox.height
            border.width: checkbox.focus ? 2 : 1
            border.color: "black"
            radius: 3

            Rectangle {
                width: checkbox.width-mark; height: checkbox.height-mark;
                radius: 3
                color: "#424a51";
                anchors.centerIn: parent
                visible: checkbox.checked;
            }
    }
    Text{text: checkbox.text}

    MouseArea {
        anchors.fill: parent
        onClicked: checkbox.checked = !checkbox.checked
    }
}
