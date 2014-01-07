import QtQuick 2.0
import QtGraphicalEffects 1.0
import sensors 1.0

Rectangle {
    id: root
    width: 640
    height: 480
    color: "#252b31"
    border.width: 0
    property var timerinterval: 500

    state:"LEFT_DRAWER_OPEN"
    states:[
        State {
            name: "LEFT_DRAWER_OPEN"
            PropertyChanges { target: signals; x:0}
            PropertyChanges { target: left_drawer; x:signals.width-left_drawer.width/2}
//            PropertyChanges { target: chart; x:signals.width; width:root.width-signals.width}
              },
        State {
            name: "LEFT_DRAWER_CLOSED"
            PropertyChanges { target: signals; x:-signals.width}
            PropertyChanges { target: left_drawer; x:-left_drawer.width/2}
//            PropertyChanges { target: chart; x:0; width:root.width}
              }
           ]

    transitions: [
        Transition {
            to: "*"
            NumberAnimation { target: left_drawer; properties: "x"; duration: 500; easing.type:Easing.OutExpo }
            NumberAnimation { target: signals; properties: "x"; duration: 500; easing.type: Easing.OutExpo }
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
        property var counter:0;

        onTriggered:
           {
           counter++;
           for(var x=0;x<chart.sensors.items.length;x++)
                {
                signals.model.setProperty(x,"value", chart.sensors.items[x].value);
                }
           }
       }

    GaussianBlur {
        id: glow
        anchors.fill: parent
        source: chartTexture
        radius: 8
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
        interval: 25
        function init(){

            for(var x=0;x<chart.sensors.items.length;x++)
                signals.model.append({"name": chart.sensors.items[x].label,
                                      "value": chart.sensors.items[x].value,
                                      "itemcolor": chart.sensors.items[x].color
//                                      "min":
                                     }
                                     );

        }
        Component.onCompleted: init();
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
        sensors: chart.sensors
        height: root.height
        chart: chart
        width: 190
        color:"#66ffffff"
        }
}
