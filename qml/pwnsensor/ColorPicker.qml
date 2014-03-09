import QtQuick 2.0
import "Assets"

// based on
// [1] http://blog.ruslans.com/2010/12/cute-quick-colorpicker.html

Rectangle {
    id: root
    width: 400
    height: 400
    property var hsb
    property var col: "blue"    // current color
    property color startcol: "white"    // initial color
    border.color: "#eeeeee"
    radius: 8

    signal accepted(color newcol)
    signal cancel

    function hsbToColor(hsb) {
        var lightness = (2 - hsb.s)*hsb.b;
        var satHSL = hsb.s*hsb.b/((lightness <= 1) ? lightness : 2 - lightness);
        lightness /= 2;
        return Qt.hsla(hsb.h, satHSL, lightness, 1.0);
    }

//    from https://github.com/bgrins/TinyColor
/*
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
*/

// based on
//  [2] https://github.com/bgrins/TinyColor
//  [3] http://en.wikipedia.org/wiki/HSL_and_HSV
    function rgbToHsb(rgb){
        var max = Math.max(rgb.r, rgb.g, rgb.b), min = Math.min(rgb.r, rgb.g, rgb.b);
        var C = max-min;
        var l = (max+min)/2.
        var h;

        if(C==0){
            h=0
        }
        else{
            var s = l > 0.5 ? C / (2 - max - min) : C / (max + min);
            switch(max) {
                case rgb.r: h = (rgb.g - rgb.b) / C + (rgb.g < rgb.b ? 6 : 0); break;
                case rgb.g: h = (rgb.b - rgb.r) / C + 2; break;
                case rgb.b: h = (rgb.r - rgb.g) / C + 4; break;
            }
            h /= 6;
        }
        return { h: h, s: (C==0)?0.:C/max, b: max };
    }

    Component.onCompleted: {
        root.hsb = rgbToHsb(root.startcol);
        root.col = hsbToColor(root.hsb);
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
        col: hsbToColor(root.hsb)

        onChanged: {root.hsb.s=newsat; root.hsb.b=newbri; root.col=hsbToColor(root.hsb)}
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

        onChanged: {root.hsb.h=newhue;col=hsbToColor(root.hsb)}
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
