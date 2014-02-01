import QtQuick 2.0
import QtGraphicalEffects 1.0
import sensors 1.0
//import QtQuick.LocalStorage 2.0
//import "storage.js" as Storage

Rectangle{
    id: root
    width: 640
    height: 480
    color: "#252b31"
    border.width: 0
    property var timerinterval: 1000
    property var t_min: 60  // seconds
//    property var settings

    Component.onCompleted: {
        mainwindow.x = settings.value("WindowPos/x",0)
        mainwindow.y = settings.value("WindowPos/y",0)
        mainwindow.width = settings.value("WindowPos/width",0)
        mainwindow.height = settings.value("WindowPos/height",0)

        settings.beginGroup("SensorItems");
        var keys = settings.childKeys();
        console.log(keys);

    }
    Component.onDestruction: {
//        console.log(left_drag.x)
        settings.setValue("state",state)
        settings.setValue("left_drawer_width", left_drag.x);
        settings.setValue("refresh_rate", chart.refreshrate);
        settings.setValue("sample_rate", chart.samplerate);
        settings.setValue("WindowPos/x", mainwindow.x);
        settings.setValue("WindowPos/y", mainwindow.y);
        settings.setValue("WindowPos/width", mainwindow.width);
        settings.setValue("WindowPos/height", mainwindow.height);


        for(var x=0;x<chart.sensors.items.length;x++)
            settings.setValue("SensorItems/"+chart.sensors.items[x].label, chart.sensors.items[x].checked);

    }

    state: settings.value("state","LEFT_DRAWER_OPEN")
    states:[
        State {
            name: "LEFT_DRAWER_OPEN"
            PropertyChanges { target: signals; x:0}
            PropertyChanges { target: settings_drawer; x:2; opacity:0; enabled: false}
            PropertyChanges { target: left_drawer; x:signals.width + left_drag.width + 2}
            PropertyChanges { target: settings_dlg; x:-settings_dlg.width}
            PropertyChanges { target: left_drag; opacity:1; enabled: true}
//            PropertyChanges { target: chart; x:signals.width; width:root.width-signals.width}
              },
        State {
            name: "SETTINGS_DRAWER_OPEN"
            PropertyChanges { target: signals; x:-signals.width-left_drag.width}
            PropertyChanges { target: left_drawer; x:2; opacity:0; enabled: false}
            PropertyChanges { target: settings_drawer; x:settings_dlg.width+2}
            PropertyChanges { target: settings_dlg; x:0}
            PropertyChanges { target: left_drag; opacity:0; enabled: false}
//            PropertyChanges { target: chart; x:signals.width; width:root.width-signals.width}
              },
        State {
            name: "LEFT_DRAWER_CLOSED"
            PropertyChanges { target: signals; x:-signals.width-left_drag.width}
            PropertyChanges { target: left_drawer; x:2}
            PropertyChanges { target: settings_drawer; x:2}
            PropertyChanges { target: settings_dlg; x:-settings_dlg.width}
            PropertyChanges { target: left_drag; opacity:0; enabled: false}
//            PropertyChanges { target: chart; x:0; width:root.width}
              }
           ]

    transitions: [
        Transition {
            to: "*"
            NumberAnimation { target: left_drawer; properties: "x"; duration: 500; easing.type:Easing.OutExpo }
            NumberAnimation { target: left_drawer; properties: "opacity"; duration: 500; easing.type: Easing.Linear }
            NumberAnimation { target: settings_drawer; properties: "x"; duration: 500; easing.type:Easing.OutExpo }
            NumberAnimation { target: settings_drawer; properties: "opacity"; duration: 500; easing.type: Easing.Linear }
            NumberAnimation { target: signals; properties: "x"; duration: 500; easing.type: Easing.OutExpo }
            NumberAnimation { target: settings_dlg; properties: "x"; duration: 500; easing.type: Easing.OutExpo }
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
        interval: settings_dlg.refresh_rate;
        running: true;
        repeat: true
        triggeredOnStart: false
        property var counter:0;

        onTriggered:
           {
//           console.log(settings.rate);
           counter++;
           for(var x=0;x<chart.sensors.items.length;x++)
                {
                signals.model.setProperty(x,"value", chart.sensors.items[x].value);
                signals.model.setProperty(x,"minval", chart.sensors.items[x].minval);
                signals.model.setProperty(x,"maxval", chart.sensors.items[x].maxval);
                }

//           x = bounds.left()+(m_timestamp - m_sensor->samples().at(s)->time() - tmin) * scale_x
           var ctime = (cursor.x-chart_container.x)/-chart_container.width * chart.sensors.items[0].tmin - chart.sensors.timestamp + chart.sensors.items[0].tmin;
//            console.log(chart.sensors.timestamp/1000 + "  " + -ctime/1000);
           cursorvalue.text = chart.sensors.items[signals.selected_item].valueAt(-ctime).toFixed(2);

           }
       }


    Item{
        id: chart_container
        x:10
        y:10
        width: parent.width-2*x
        height: parent.height-2*y
        clip: true

//        GaussianBlur {
//            id: glow
//            anchors.fill: parent
//            source: chartTexture
//            radius: 6
//            samples: 16
//            visible: false
//        }

//        ShaderEffectSource {
//            id: chartTexture
//            anchors.fill: parent
//            sourceItem: chart
//            hideSource: true
//        }

        SignalCanvas{
            id: chart
            anchors.fill: parent
            tmin: t_min
            refreshrate: settings.value("refresh_rate",1000);
            samplerate: settings.value("sample_rate",1000);

            function init(){

                for(var x=0;x<chart.sensors.items.length;x++)
                    signals.model.append({"name": "<b>"+chart.sensors.items[x].label+"</b>",
                                          "value": chart.sensors.items[x].value,
                                          "itemcolor": chart.sensors.items[x].color,
                                          "minval": chart.sensors.items[x].minval,
                                          "maxval": chart.sensors.items[x].maxval,
                                          "unit": chart.sensors.items[x].unit
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
    }

//    Rectangle{
//        color: "#252b31"
//        width: 10
//        height: parent.height
//    }


    Rectangle {
        id: cursor
        x: root.width-chart_container.x-1
        width: 2; height: signals.height
//        color: "white"
        color: "#aaa5a5a5"
//        visible: false

        Text{
            id: cursorvalue
//            anchors.centerIn: parent
            anchors.horizontalCenter: cursor.horizontalCenter
            anchors.bottom: parent.bottom
            color: "white"
        }

        MouseArea {
            cursorShape: Qt.SizeHorCursor;
            width:12; height: parent.height;
            anchors.centerIn: parent
            drag.target: cursor
            drag.axis: Drag.XAxis
            drag.minimumX: chart_container.x
            drag.maximumX: root.width-chart_container.x-1
        }
    }



    Rectangle {
        id: left_drag
        x: settings.value("left_drawer_width",250);
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
        color: (leftdrawerMouseArea.containsMouse)?"#88ffffff":"#44ffffff"
        x:left_drag.width + 2
        y:2
        width: 24
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
            hoverEnabled: true
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

    Rectangle{
        id: settings_drawer
        color: (settingsdrawerMouseArea.containsMouse)?"#88ffffff":"#44ffffff"
        x:settings_dlg.width + 2
        y:25
        width: 24
        height: 21
        radius: 4

        Text{text:"settings"; color:"white"}

        MouseArea{
            id: settingsdrawerMouseArea
            hoverEnabled: true
            anchors.fill:parent
            onClicked:{
                if (root.state == "LEFT_DRAWER_CLOSED"){
                    root.state = "SETTINGS_DRAWER_OPEN"
                }
                else if (root.state == "SETTINGS_DRAWER_OPEN"){
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

    SettingsDlg{
        id:settings_dlg
        sensors: chart.sensors
        storageDB : settings
//        rate: root.timerinterval
        chart: chart
        width:160
        height: root.height
        color:"#bb252b31"
    }
}
