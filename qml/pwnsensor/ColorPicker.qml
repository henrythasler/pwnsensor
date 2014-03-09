import QtQuick 2.0
import "Assets"

/* based on:  http://blog.ruslans.com/2010/12/cute-quick-colorpicker.html


*/

Rectangle {
    id: root
    width: 100
    height: 100
    property real hue: 0.5
    property real sat: 1.0
    property real bri: 1.0
    property var col: "blue"
    property color startcol: "white"
    border.color: "#eeeeee"


    signal accepted(color newcol)
    signal cancel


    function hsba(h, s, b, a) {
        var lightness = (2 - s)*b;
        var satHSL = s*b/((lightness <= 1) ? lightness : 2 - lightness);
        lightness /= 2;
        return Qt.hsla(h, satHSL, lightness, a);
    }

//    from https://github.com/bgrins/TinyColor
    function rgbToHsl(r, g, b) {
        var max = Math.max(r, g, b), min = Math.min(r, g, b);
        var h, s, l = (max + min) / 2;

        if(max == min) {
            h = s = 0; // achromatic
        }
        else {
            var d = max - min;
            s = l > 0.5 ? d / (2 - max - min) : d / (max + min);
            switch(max) {
                case r: h = (g - b) / d + (g < b ? 6 : 0); break;
                case g: h = (b - r) / d + 2; break;
                case b: h = (r - g) / d + 4; break;
            }
            h /= 6;
        }
        return { h: h, s: s, l: l };
    }

    Component.onCompleted: {
        var hsl = rgbToHsl(startcol.r, startcol.g, startcol.b);
//        console.log(hsl.h + " " + hsl.s + " " + hsl.l)
        root.hue = hsl.h;
        root.sat = hsl.s;
        root.bri = hsl.l*2/(2-hsl.s);
//        console.log(hue + " " + sat + " " + bri)
        root.col=hsba(root.hue, root.sat, root.bri,1.)
    }



    SatBrightPicker{
        id: sbPicker
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.margins: 10
        width: height

        radius: 7
        border_width: 2
        col: hsba(root.hue, 1., 1., 1.)

        onChanged: {root.sat=newsat; root.bri=newbri; root.col=hsba(root.hue, root.sat, root.bri,1.)}
        Binding { target: sbPicker; property: "sat"; value: root.sat; when: !sbPicker.dragActive;}
        Binding { target: sbPicker; property: "bri"; value: root.bri; when: !sbPicker.dragActive;}

    }

    HuePicker{
        id: huePicker
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: sbPicker.right
        anchors.margins: 10
        width: 24
        onChanged: {root.hue=newhue;col=hsba(root.hue, root.sat, root.bri,1.)}
        Binding { target: huePicker; property: "currentHue"; value: root.hue; when: !huePicker.dragActive;}
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
