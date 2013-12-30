import QtQuick 2.0
import sensors 1.0


Rectangle {
    id: root
    width: 640
    height: 480
    color: "black"
    border.width: 0

    state:"LEFT_DRAWER_OPEN"
    states:[
        State {
            name: "LEFT_DRAWER_OPEN"
            PropertyChanges { target: signals; x:0}
            PropertyChanges { target: left_drawer; x:signals.width-left_drawer.width/2}
            PropertyChanges { target: chart; x:signals.width; width:root.width-signals.width}
              },
        State {
            name: "LEFT_DRAWER_CLOSED"
            PropertyChanges { target: signals; x:-signals.width}
            PropertyChanges { target: left_drawer; x:-left_drawer.width/2}
            PropertyChanges { target: chart; x:0; width:root.width}
              }
           ]

    transitions: [
        Transition {
            to: "*"
            NumberAnimation { target: left_drawer; properties: "x"; duration: 500; easing.type:Easing.OutExpo }
            NumberAnimation { target: signals; properties: "x"; duration: 500; easing.type: Easing.OutExpo }
            NumberAnimation { target: chart; properties: "x, width"; duration: 500; easing.type: Easing.OutExpo }
        }
    ]

    Item{
        anchors.fill: parent
        focus: true
        Keys.onEscapePressed: {
            Qt.quit();
        }

    }

    QLmSensors {
        id: sensors

        function init(){

            for(var x=0;x<sensors.items.length;x++)
                signals.model.append({"name": sensors.items[x].label, "value":sensors.items[x].value});

            // nothing right now
        }
        Component.onCompleted: init();
    }

    Timer {
        id:maintimer
        interval: 100; running: true; repeat: true
        onTriggered:
           {
           sensors.do_sampleValues();
            for(var x=0;x<sensors.items.length;x++)
                signals.model.setProperty(x,"value", sensors.items[x].value);
           chart.chart_canvas.requestPaint();
           }
       }




    Chart {
        id: chart
        width: root.width
        height: root.height
        sensors: sensors
        }


    Rectangle{
        id: left_drawer
        color:"white"
        opacity: 0.3
        x:-10
        width:20
//        height: parent.height
        y: parent.height/2-50
        height: 100
        radius: 10

        MouseArea{
            id: leftdrawerMouseArea
            anchors.fill:parent
            onClicked:{
                if (root.state == "LEFT_DRAWER_CLOSED"){
                    root.state = "LEFT_DRAWER_OPEN"
                }
                else if (root.state == "LEFT_DRAWER_OPEN"){
                    root.state = "LEFT_DRAWER_CLOSED"
                }
            }
        }
    }

    SignalList{
        id:signals
        sensors: sensors
        height: root.height
        width: 190
        color:"white"
        }
}
