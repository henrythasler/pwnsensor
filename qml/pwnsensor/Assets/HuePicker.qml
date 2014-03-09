import QtQuick 2.0

Item {
    id: root
    property bool dragActive: false
    property real currentHue: 1.0
    property real radius: 5
    property real border_width: 1

    signal changed(real newhue)

    onCurrentHueChanged: {
//        console.log(currentHue);
        picker.y=(1.-currentHue)*height-radius;
    }

    Rectangle{
        id: gradient
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0/6; color: "red" }
            GradientStop { position: 1/6; color: "magenta" }
            GradientStop { position: 2/6; color: "blue" }
            GradientStop { position: 3/6; color: "cyan" }
            GradientStop { position: 4/6; color: "lime" }
            GradientStop { position: 5/6; color: "yellow" }
            GradientStop { position: 6/6; color: "red" }
        }
    }

    MouseArea{
        anchors.fill: parent
        onClicked: {
            picker.y=mouseY-root.radius
            root.changed(1-(picker.y+root.radius)/root.height)
        }
    }

    Rectangle{
        id: picker
        width: root.width
//        x:root.width/2-root.radius
        height:root.radius*2
        radius: root.radius
        color: "#00000000"
        border.width: root.border_width
        border.color: "black"

        MouseArea{
            anchors.fill: parent
            drag.target: picker
            cursorShape: Qt.OpenHandCursor
            drag.axis: Drag.YAxis
            drag.minimumY: -root.radius
            drag.maximumY: root.height-root.radius
            onPositionChanged: {
                root.changed(1-(picker.y+root.radius)/root.height)
            }
            onPressed: dragActive=true;
            onReleased: dragActive=false;
        }

        Rectangle{
            x:root.border_width
            y:root.border_width
            width: root.width-2*root.border_width
            height:(root.radius-root.border_width)*2
            radius: (root.radius-root.border_width)
            color: "#00000000"
            border.width: root.border_width
            border.color: "white"
        }
    }
}
