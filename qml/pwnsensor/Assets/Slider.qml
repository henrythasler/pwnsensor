import QtQuick 2.0
import "utils.js" as Utils

// References
// [1] http://qt-project.org/doc/qt-5.0/qtquick/canvas-contents-slider-qml.html

Item {
    id: root;
    property real radius: 0
    property real border_width: 0
    property real handle_width: 5
    property bool dragActive: false

    property real value: 1
    property real maximum: 1
    property real minimum: 1
    property real stepSize: 1
    default property alias children: holdingpen.data

    signal changed(real newval)

    onValueChanged: {
        var hrange = root.width-2*root.border_width-handle.width;
        var steps = (root.maximum-root.minimum)/root.stepSize;
        var hstepsize = hrange/steps;
        handle.x = (value-root.minimum)/ root.stepSize * hstepsize+root.border_width;
    }

    Rectangle {
        anchors.fill: parent;
        border.color: "#eeeeeeee";
        border.width: root.border_width;
        radius: root.radius;
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#66666666" }
            GradientStop { position: 1.0; color: "#66000000" }
        }
    }

    Rectangle {
        id: handle;
        x: root.border_width;
        y: root.border_width;
        width: root.handle_width;
        height: root.height-2*root.border_width;
        radius: root.radius-root.border_width;
        border.color: "grey"
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#eeeeee" }
            GradientStop { position: 1.0; color: "#aaaaaa" }
        }
    }

    MouseArea{
        id: holdingpen;
        anchors.fill: parent;
        onPressed: dragActive=true;
        onReleased: dragActive=false;
        onPositionChanged: {
            if (mouse.buttons & Qt.LeftButton)
            {
                var hrange = root.width-2*root.border_width-handle.width;
                var steps = (root.maximum-root.minimum)/root.stepSize;
                var hstepsize = hrange/steps;
                var new_val = Math.round(Utils.clamp(mouse.x-handle.width/2,root.border_width,root.width-root.border_width-handle.width)/hrange * steps);
                root.changed(root.minimum+new_val*root.stepSize);
                handle.x = new_val * hstepsize+root.border_width;
//                console.log(new_val)
            }
        }
    }
}
