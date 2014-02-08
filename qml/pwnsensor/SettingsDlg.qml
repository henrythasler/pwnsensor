import QtQuick 2.0
import QtQuick.Controls 1.1

Rectangle {
    property var sensors: NULL
    property var chart: NULL
    property var storageDB: NULL
    property var sample_rate: sample_slider.value
    property var refresh_rate: refresh_slider.value

    width: 160;
    height: 480;
    color: "#ffc2cd"

    Text {
        id: width_label
        x: 8
        y: 8
        color: "#eeeeee"
        font.bold: true
        text: "Line Width:"
    }
    Text{color: "#eeeeee"; text: linewidth_slider.value + "px"; id:linewidth; x: 94; y: width_label.y; width: 32;height: 19}
    Slider {
        id: linewidth_slider
        x: 8
        y: 25
        width: 144
        height: width_label.y+16
        tickmarksEnabled: false
        stepSize: 1
        maximumValue: 10
        minimumValue: 1
        onValueChanged: {
            // item[0] is connected automatically, change the others as well
            for(var x=0;x<sensors.items.length;x++)
                 {
                 sensors.items[x].width = value;
                 }
            chart.update();
        }
        Component.onCompleted: value = sensors.items[0].width;

    }


    Text {
        id:refresh_label
        x: 8
        y: 68
        color: "#eeeeee"
        font.bold: true
        text: "Refreshrate:"
    }
    Text{color: "#eeeeee"; text: refresh_slider.value.toFixed(0) + "ms"; x: 94; y: refresh_label.y; width: 32;height: 19}
    Slider {
        id: refresh_slider
        x: refresh_label.x
        y: refresh_label.y+16
        width: linewidth_slider.width
        height: linewidth_slider.height
        tickmarksEnabled: false
        stepSize: 100
        maximumValue: 5000
        minimumValue: 100
        onValueChanged: {
            chart.refreshrate = value
        }
        Component.onCompleted: value = chart.refreshrate;
    }


    Text {
        id:sample_label
        x: 8
        y: 128
        color: "#eeeeee"
        font.bold: true
        text: "Samplerate:"
    }
    Text{color: "#eeeeee"; text: sample_slider.value.toFixed(0) + "ms"; x: 94; y: sample_label.y; width: 32;height: 19}
    Slider {
        id: sample_slider
        x: sample_label.x
        y: sample_label.y+16
        width: linewidth_slider.width
        height: linewidth_slider.height
        tickmarksEnabled: false
        stepSize: 100
        maximumValue: 5000
        minimumValue: 100
        onValueChanged: {
            chart.samplerate = value
        }
        Component.onCompleted: value = chart.samplerate;
    }

    Rectangle{x:parent.width-2; width:2;height:parent.height;color:"#aaffa500"}

    Timer{
        interval: 1000;
        running: true;
        repeat: true
        onTriggered:
            {
            var count=0;
            var buffer=0;
            for(var x=0;x<sensors.items.length;x++)
                 {
                 count += sensors.items[x].samples.length;
                  buffer += sensors.items[x].max_samples;
                 }
            numsamples.text = "Buffer: "+(count/buffer*100).toFixed(2)+"%";
            }
    }

    Item{
        width: parent.width
        height: 100
        anchors.bottom: parent.bottom
        Text{x:8;y:0;color:"#eeeeee";text:"Debug Info";font.bold: true}
        Text{x:8;y:16;id:numsamples; color:"#eeeeee";text:"Buffer: 0%"}
        Text{
            id:reset_link; x:8;y:32;linkColor: "#eeeeee";text:"<a href=\"#\">reset settings</a>"
            onLinkActivated: {
                storageDB.clear();
                }
            }
    }
}
