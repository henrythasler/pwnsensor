import QtQuick 2.0

Item {
    id: root
    property bool dragActive: false
    property real currentHue: 1.0

    signal changed(real newhue)

    onCurrentHueChanged: {
//        console.log(currentHue);
        picker.y=(1-currentHue)*root.height;
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
            picker.y=mouseY-picker.height
            root.changed(1-Math.min(root.height, Math.max(0,picker.y+Math.round(picker.height/2+0.5)))/root.height)
        }
    }

    Item{
        id:picker
        width:root.width
        height: 5
        Rectangle{
            anchors.fill: parent
            color:"#00000000"
            border.color: "#80000000"
            border.width: 2
        }
        MouseArea{
            anchors.fill: parent
            anchors.margins: 10
            cursorShape: Qt.SizeVerCursor
            drag.target: picker
            drag.axis: Drag.YAxis
            drag.minimumY: -Math.round(picker.height/2-0.5)
            drag.maximumY: root.height-Math.round(picker.height/2+0.5)
            onMouseYChanged: {
                root.changed(1-Math.min(root.height, Math.max(0,picker.y+Math.round(picker.height/2+0.5)))/root.height)
            }
            onPressed: dragActive=true;
            onReleased: dragActive=false;
        }
    }
}
