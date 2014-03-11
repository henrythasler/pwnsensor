import QtQuick 2.0
import "Assets"
import "Assets/utils.js" as Utils

// References
// [1] http://blog.ruslans.com/2010/12/cute-quick-colorpicker.html
// [2] http://www.workwithcolor.com/color-converter-01.htm

Rectangle {
    id: root
    width: 400
    height: 400
    property var hsb
    property color col: "blue"    // current color
    property color sbColor: "white" // color based on huePicker
    property color startcol: "white"    // initial color
    border.color: "#eeeeee"
    radius: 8

    signal accepted(color newcol)
    signal cancel

    Component.onCompleted: {
        root.hsb = Utils.rgbToHsb(root.startcol);
        root.col = Utils.hsbToColor(root.hsb);
        root.sbColor = Utils.hsbToColor({h:root.hsb.h,s:1,b:1})
    }

    SatBrightPicker{
        id: sbPicker
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.margins: 10
        width: height

        radius: 8
        border_width: 2
        col: root.sbColor

        onChanged: {root.hsb.s=newsat; root.hsb.b=newbri; root.col=Utils.hsbToColor(root.hsb)}
        Binding { target: sbPicker; property: "sat"; value: root.hsb.s; when: !sbPicker.dragActive;}
        Binding { target: sbPicker; property: "bri"; value: root.hsb.b; when: !sbPicker.dragActive;}
    }

    HuePicker{
        id: huePicker
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: sbPicker.right
        anchors.margins: 10
        width: 24

        radius: 8
        border_width: 2

        onChanged: {root.hsb.h=newhue;col=Utils.hsbToColor(root.hsb); root.sbColor=Utils.hsbToColor({h:root.hsb.h,s:1,b:1})}
        Binding { target: huePicker; property: "currentHue"; value: root.hsb.h; when: !huePicker.dragActive;}
    }

    Rectangle{
        id: current
        anchors.top: parent.top
        anchors.left: huePicker.right
        anchors.right: parent.right
        anchors.margins: 10
        height: 32
        color: root.col;
    }

    Text{
        id: rgb
        anchors.top: current.bottom
        anchors.left: huePicker.right
        anchors.right: parent.right
        anchors.margins: 10
        color: "#eeeeee"
        text: root.col
    }

    Button{
        id: ok
        anchors.bottom: cancel.top
        anchors.left: huePicker.right
        anchors.right: parent.right
        anchors.margins: 10
        height: 24
        label: "Ok"
        onClicked: root.accepted(root.col)
    }

    Button{
        id: cancel
        anchors.bottom: parent.bottom
        anchors.left: huePicker.right
        anchors.right: parent.right
        anchors.margins: 10
        height: 24
        label: "Cancel"
        onClicked: root.cancel()
    }
}
