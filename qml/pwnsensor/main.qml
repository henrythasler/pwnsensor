import QtQuick 2.0
//import QtGraphicalEffects 1.0
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
//    property var settings

//    Image{anchors.centerIn: parent; source: "qrc:/svg/pwnsensor80.png"}
//    Image{anchors.centerIn: parent; source: "qrc:/svg/crosshair.svg"}

    Component.onCompleted: {
        mainwindow.x = settings.value("WindowPos/x",0)
        mainwindow.y = settings.value("WindowPos/y",0)
        mainwindow.width = settings.value("WindowPos/width",0)
        mainwindow.height = settings.value("WindowPos/height",0)

        if(!settings.value("General/tutorial",0))
            {
            tutorial.visible=true;
            settings.setValue("General/tutorial",1)
            }

    }
    Component.onDestruction: {
//        console.log(left_drag.x)

        settings.beginGroup("General");
            settings.setValue("state",state)
            settings.setValue("left_drawer_width", left_drag.x);
            settings.setValue("refresh_rate", chart.refreshrate);
            settings.setValue("sample_rate", chart.samplerate);
            settings.setValue("tmin", chart.tmin);
        settings.endGroup();

        settings.beginGroup("WindowPos");
            settings.setValue("x", mainwindow.x);
            settings.setValue("y", mainwindow.y);
            settings.setValue("width", mainwindow.width);
            settings.setValue("height", mainwindow.height);
        settings.endGroup();


        settings.beginGroup("SensorItems");
        for(var x=0;x<chart.sensors.items.length;x++)
            {
            settings.beginGroup(chart.sensors.items[x].adapter+"_"+chart.sensors.items[x].label);
                settings.setValue("checked", chart.sensors.items[x].checked);
                settings.setValue("color", chart.sensors.items[x].color);
                settings.setValue("width", chart.sensors.items[x].width);
                settings.setValue("max_samples", chart.sensors.items[x].max_samples);
                settings.setValue("ymin", chart.sensors.items[x].ymin);
                settings.setValue("ymax", chart.sensors.items[x].ymax);
            settings.endGroup();
            }
        settings.endGroup();

    }

    state: settings.value("General/state","LEFT_DRAWER_OPEN")
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
//            glow.visible = 1-glow.visible;
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
           var ctime = (cursor.x-chart_container.x)/-chart_container.width * chart.sensors.items[signals.selected_item].tmin - chart.sensors.timestamp + chart.sensors.items[signals.selected_item].tmin;
//            console.log(chart.sensors.items[signals.selected_item].samples[chart.sensors.items[signals.selected_item].samples.length-1].time/1000 + "  " + -ctime/1000);

           var val = chart.sensors.items[signals.selected_item].valueAt(-ctime);
           cursorvalue.text = val.toFixed(2) + " " + chart.sensors.items[signals.selected_item].unit;
           var pos = chart.sensors.items[signals.selected_item].map2canvas(Qt.rect(chart_container.x, chart_container.y, chart_container.width, chart_container.height), -ctime, val);
//           console.log(pos)
           cursor_crosshair.y=pos.y-cursor_crosshair.height/2
//           cursor_crosshair.x=pos.x

           }
       }

    Item{
        id: chart_container
        x:10
        y:10
        width: parent.width-4*x
        height: parent.height-4*y
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
            tmin: settings.value("General/tmin", 60);
            refreshrate: settings.value("General/refresh_rate",1000);
            samplerate: settings.value("General/sample_rate",1000);

            function init(){

                settings.beginGroup("SensorItems");
                var keys = settings.childGroups();
//                console.log(keys)

                for(var x=0;x<chart.sensors.items.length;x++)
                    {
                    if(keys.indexOf(chart.sensors.items[x].adapter+"_"+chart.sensors.items[x].label)>=0)
                        {
                        settings.beginGroup(chart.sensors.items[x].adapter+"_"+chart.sensors.items[x].label);
                            chart.sensors.items[x].checked = (settings.value("checked","false") == "true")?true:false;
                            chart.sensors.items[x].color = settings.value("color","white");
                            chart.sensors.items[x].width = settings.value("width",2);
                            chart.sensors.items[x].max_samples = settings.value("max_samples",10000);
                            chart.sensors.items[x].ymin = settings.value("ymin",0);
                            chart.sensors.items[x].ymax = settings.value("ymax",100);
                        settings.endGroup();
                        }


                    signals.model.append({"name": "<b>"+chart.sensors.items[x].label+"</b>",
                                          "value": chart.sensors.items[x].value,
                                          "itemcolor": chart.sensors.items[x].color,
                                          "minval": chart.sensors.items[x].minval,
                                          "maxval": chart.sensors.items[x].maxval,
                                          "unit": chart.sensors.items[x].unit
                                         }
                                         );
                    }
                settings.endGroup();
            }
            Component.onCompleted: init();

            Rectangle{
                id: dummydrag
//                width: 100
//                height: 100
                property var y_old: 0
                onYChanged: {
                    if (zoomarea.drag.active && chart.sensors.items[signals.selected_item].checked)
                        {
                        var dy = y-y_old;
                        var sig_dy = chart.sensors.items[signals.selected_item].ymax - chart.sensors.items[signals.selected_item].ymin;
                        chart.sensors.items[signals.selected_item].ymax += dy * sig_dy / chart.height;
                        chart.sensors.items[signals.selected_item].ymin += dy * sig_dy / chart.height;
                        chart.update();
                        y_old = y;
                        }
                }
            }

            MouseArea{
                id: zoomarea
                anchors.fill:parent
                hoverEnabled: true
                drag.target: dummydrag
                drag.axis: Drag.YAxis
//                drag.minimumY: 0
//                drag.maximumY: 100
                onWheel:{

                        if( wheel.modifiers & Qt.ControlModifier)    // zoom signal
                            {
                            if(chart.sensors.items[signals.selected_item].checked)
                                {
                                var dy = (chart.sensors.items[signals.selected_item].ymax-chart.sensors.items[signals.selected_item].ymin);
                                var f = (1-mouseY/height)
                                var c = chart.sensors.items[signals.selected_item].ymin+f*dy;

                                if (wheel.angleDelta.y > 0) // zoom in
                                    {
                                    chart.sensors.items[signals.selected_item].ymax = c+dy*(1-f)*0.7
                                    chart.sensors.items[signals.selected_item].ymin = c-dy*f*0.7
    //                                console.log(chart.sensors.items[signals.selected_item].ymin + " " + chart.sensors.items[signals.selected_item].ymax)
                                    }
                                else    // zoom out
                                    {
                                    chart.sensors.items[signals.selected_item].ymax = c+dy*(1-f)/0.7
                                    chart.sensors.items[signals.selected_item].ymin = c-dy*f/0.7
                                    }
    //                            console.log("dy=" + dy + " f=" + f + " c=" + c + " ymin=" + chart.sensors.items[signals.selected_item].ymin + " ymax="+chart.sensors.items[signals.selected_item].ymax)
                                chart.update();
                                }
                            }
                        else{                                       // zoom time
                            if (wheel.angleDelta.y > 0)
                                chart.tmin = Math.max(chart.tmin*0.75,5);
                            else
                                chart.tmin = Math.min(chart.tmin/0.75,86400);
                            chart.update();
                            }

                }
            }
        }
    }

//    Rectangle{
//        color: "#252b31"
//        width: 10
//        height: parent.height
//    }

    Text{
        id: scale_ymax
        x:root.width
        y:chart.y
        color: "#eeeeee"
        anchors.right: parent.right
//        verticalAlignment: Text.AlignVCenter
        font.pointSize: 8
        text: chart.sensors.items[signals.selected_item].ymax.toFixed(0)
    }

    Text{
        id: scale_ymin
        x:root.width
        y:chart.height
        color: "#eeeeee"
        anchors.right: parent.right
//        verticalAlignment: Text.AlignVCenter
        font.pointSize: 8
        text: chart.sensors.items[signals.selected_item].ymin.toFixed(0)
    }


    Text{
        id: scale_tmax
        x:chart.width
        y:chart.height+10
        color: "#eeeeee"
        anchors.bottom: parent.bottom
//        verticalAlignment: Text.AlignVCenter
        font.pointSize: 8
        text: "now"
    }

    Text{
        id: scale_tmin
        x:chart_container.x
        y:chart.height+10
        color: "#eeeeee"
        anchors.bottom: parent.bottom
//        verticalAlignment: Text.AlignVCenter
        font.pointSize: 8
        text: "-"+(chart.tmin).toFixed(0) + "s"
    }


    Item{
        id: cursor_crosshair
//        x:cursor.x;
        anchors.horizontalCenter: cursor.horizontalCenter;
        width:12; height: 12;
        Rectangle{color:"#00000000"; border.color: "white"; border.width: 2; radius: 0; anchors.fill: parent}
        Rectangle{x:12;y:12;color:"#bb252b31"; width:cursorvalue.contentWidth; height: cursorvalue.contentHeight;}
        Text{
            id: cursorvalue
            x:12
            y:12
            color: "#eeeeee"
        }
    }



    Rectangle {
        id: cursor
        x: chart_container.x+chart_container.width-1
        y:chart_container.y
        width: 2; height: chart_container.height
//        color: "white"
        color: "#aaa5a5a5"
//        visible: false

        onXChanged: {
            var ctime = -((cursor.x-chart_container.x)/-chart_container.width * chart.sensors.items[signals.selected_item].tmin - chart.sensors.timestamp + chart.sensors.items[signals.selected_item].tmin);
 //            console.log(chart.sensors.items[signals.selected_item].samples[chart.sensors.items[signals.selected_item].samples.length-1].time/1000 + "  " + -ctime/1000);

            var val = chart.sensors.items[signals.selected_item].valueAt(ctime);
            cursorvalue.text = val.toFixed(2) + " " + chart.sensors.items[signals.selected_item].unit;
            var pos = chart.sensors.items[signals.selected_item].map2canvas(Qt.rect(chart_container.x, chart_container.y, chart_container.width, chart_container.height), ctime, val);
 //           console.log(pos)
            cursor_crosshair.y=pos.y-cursor_crosshair.height/2
//            cursor_crosshair.x=pos.x
        }

        Image{y: chart_container.y-21; source: "qrc:/svg/dropDownTriangle.svg"; anchors.horizontalCenter: cursor.horizontalCenter; transform: Rotation {origin.x: 8; origin.y: 6; angle: 180}}
        Image{y: chart_container.height-2; source: "qrc:/svg/dropDownTriangle.svg"; anchors.horizontalCenter: cursor.horizontalCenter}

//        Image{id: cursor_crosshair; x:cursor.x; source: "qrc:/svg/crosshair2.svg"; anchors.horizontalCenter: cursor.horizontalCenter;}


        MouseArea {
            cursorShape: Qt.SizeHorCursor;
            width:12; height: parent.height;
            anchors.centerIn: parent
            drag.target: cursor
            drag.axis: Drag.XAxis
            drag.minimumX: chart_container.x
            drag.maximumX: chart_container.x+chart_container.width-1
        }
    }



    Rectangle {
        id: left_drag
        x: settings.value("General/left_drawer_width",250);
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
        width:200
        height: root.height
        color:"#bb252b31"
    }

    Tutorial{
        id: tutorial
        visible: false
    }

}
