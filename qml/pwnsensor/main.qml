import QtQuick 2.0
import QtGraphicalEffects 1.0
import sensors 1.0

Rectangle {
    id: root
    width: 640
    height: 480
    color: "#252b31"
    border.width: 0
    property var timerinterval: 100
    property var t_min: 60  // seconds
    property var left_drawer_width: 250

    state:"LEFT_DRAWER_OPEN"
    states:[
        State {
            name: "LEFT_DRAWER_OPEN"
            PropertyChanges { target: signals; x:0}
            PropertyChanges { target: left_drawer; x:signals.width + left_drag.width + 2}
            PropertyChanges { target: left_drag; opacity:1; enabled: true}
//            PropertyChanges { target: chart; x:signals.width; width:root.width-signals.width}
              },
        State {
            name: "LEFT_DRAWER_CLOSED"
            PropertyChanges { target: signals; x:-signals.width-left_drag.width}
            PropertyChanges { target: left_drawer; x:2}
            PropertyChanges { target: left_drag; opacity:0; enabled: false}
//            PropertyChanges { target: chart; x:0; width:root.width}
              }
           ]

    transitions: [
        Transition {
            to: "*"
            NumberAnimation { target: left_drawer; properties: "x"; duration: 500; easing.type:Easing.OutExpo }
            NumberAnimation { target: signals; properties: "x"; duration: 500; easing.type: Easing.OutExpo }
            NumberAnimation { target: left_drag; properties: "opacity"; duration: 500; easing.type: Easing.Linear }
//            NumberAnimation { target: chart; properties: "x, width"; duration: 500; easing.type: Easing.OutExpo }
        }
    ]

    Item{
        anchors.fill: parent
        focus: true
        Keys.onEscapePressed: {
            Qt.quit();
        }
        Keys.onSpacePressed: {
            glow.visible = 1-glow.visible;
//            tex.visible = 1-tex.visible;
        }

    }

    Timer {
        id:maintimer
        interval: root.timerinterval;
        running: true;
        repeat: true
        triggeredOnStart: true
        property var counter:0;

        onTriggered:
           {
           counter++;
           for(var x=0;x<chart.sensors.items.length;x++)
                {
                signals.model.setProperty(x,"value", chart.sensors.items[x].value);
                signals.model.setProperty(x,"minval", chart.sensors.items[x].minval);
                signals.model.setProperty(x,"maxval", chart.sensors.items[x].maxval);

                }
           }
       }

    GaussianBlur {
        id: glow
        anchors.fill: parent
        source: chartTexture
        radius: 6
        samples: 16
        visible: false
    }

    ShaderEffectSource {
        id: chartTexture
        anchors.fill: parent
        sourceItem: chart
        hideSource: true
    }

    SignalCanvas{
        id: chart
        anchors.fill: parent
        interval: timerinterval
        tmin: t_min
        function init(){

            for(var x=0;x<chart.sensors.items.length;x++)
                signals.model.append({"name": "<b>"+chart.sensors.items[x].label+"</b>",
                                      "value": chart.sensors.items[x].value,
                                      "itemcolor": chart.sensors.items[x].color,
                                      "minval": chart.sensors.items[x].minval,
                                      "maxval": chart.sensors.items[x].maxval
                                     }
                                     );
        }
        Component.onCompleted: init();

        MouseArea{
            id: zoomarea
            anchors.fill:parent
            onWheel:{
                    if (wheel.angleDelta.y > 0)
                        t_min = Math.max(t_min/2,5);
                    else
                        t_min = Math.min(t_min*2,7200);
                    chart.update();
            }
        }
    }

    Rectangle{
        color: "#252b31"
        width: 10
        height: parent.height
    }


    Rectangle {
        id: cursor
        x: root.width-10
        width: 2; height: signals.height
        color: "#aaa5a5a5"

        Text{
            anchors.centerIn: parent
            text: chart.sensors.items[signals.selected_item].samples[1].value
            color: "white"
        }

        MouseArea {
            cursorShape: Qt.SizeHorCursor;
            width:12; height: parent.height;
            anchors.centerIn: parent
            drag.target: cursor
            drag.axis: Drag.XAxis
            drag.minimumX: 10
            drag.maximumX: root.width-10
        }
    }



    Rectangle {
        id: left_drag
        x: left_drawer_width;
        width: 2; height: signals.height
        color: "#aaffa500"

        MouseArea {
            cursorShape: Qt.SizeHorCursor;
            width:6; height: parent.height;
            drag.target: left_drag
            drag.axis: Drag.XAxis
            drag.minimumX: 100
            drag.maximumX: root.width-left_drawer.width-left_drag.width-2
        }
    }

    Rectangle{
        id: left_drawer
        color: "#44ffffff"
        x:left_drag.width + 2
        y:2
        width: 24
//        height: parent.height
//        y: parent.height/2-50
        height: 21
        radius: 4

        Rectangle{x:3; y: 3; width:3; height:3; color:"white"; radius: 1}
        Rectangle{x:3; y: 9; width:3; height:3; color:"white"; radius: 1}
        Rectangle{x:3; y: 15; width:3; height:3; color:"white"; radius: 1}

        Rectangle{x:8; y: 3; width:parent.width-11; height:3; color:"white"; radius: 2}
        Rectangle{x:8; y: 9; width:parent.width-11; height:3; color:"white"; radius: 2}
        Rectangle{x:8; y: 15; width:parent.width-11; height:3; color:"white"; radius: 2}


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
        sensors: chart.sensors
        height: root.height
        chart: chart
        width: left_drag.x
        color:"#bb252b31"
    } 
}
