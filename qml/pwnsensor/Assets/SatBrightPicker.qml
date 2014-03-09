import QtQuick 2.0

Item{
    id: root
    property bool dragActive: false
    property real radius: 5
    property real border_width: 1
    property var col: "blue"
    property real sat:1
    property real bri:1

    signal changed(real newsat, real newbri)

    onSatChanged: {
//        console.log("sat="+sat);
        picker.x = sat*width-radius;
    }

    onBriChanged: {
//        console.log("bri="+bri);
        picker.y = (1.-bri)*root.height-root.radius;
    }

    Component.onCompleted: {
        picker.x = sat*width-radius;
        picker.y = (1.-bri)*height-radius;
    }


    Rectangle{
        anchors.fill: parent
        rotation: -90
        gradient: Gradient {
            GradientStop { position: 0.0; color: "white" }
            GradientStop { position: 1.0; color: root.col }
        }
    }
    Rectangle{
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 1.0; color: "#FF000000" }
            GradientStop { position: 0.0; color: "#00000000" }
        }
    }
    MouseArea{
        anchors.fill: parent
        cursorShape: Qt.CrossCursor
        onClicked: {
            picker.x=mouseX-root.radius;
            picker.y=mouseY-root.radius;
            root.changed((picker.x+root.radius)/root.width, 1-(picker.y+root.radius)/root.height);
        }
    }
    Rectangle{
        id: picker
        width: root.radius*2
        height:width
        radius: root.radius
        color: "#00000000"
        border.width: root.border_width
        border.color: "black"

        MouseArea{
            anchors.fill: parent
            drag.target: picker
            cursorShape: Qt.OpenHandCursor
            drag.minimumY: -root.radius
            drag.maximumY: root.height-root.radius
            drag.minimumX: -root.radius
            drag.maximumX: root.width-root.radius
            onPositionChanged: {
                root.changed((picker.x+root.radius)/root.width, 1-(picker.y+root.radius)/root.height)
            }
            onPressed: dragActive=true;
            onReleased: dragActive=false;
        }

        Rectangle{
            x:root.border_width
            y:root.border_width
            width: (root.radius-root.border_width)*2
            height:width
            radius: (root.radius-root.border_width)
            color: "#00000000"
            border.width: root.border_width
            border.color: "white"
        }
    }
}
