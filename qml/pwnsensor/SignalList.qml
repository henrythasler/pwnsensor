import QtQuick 2.0
import "Assets"

Rectangle {
    id: root
    property var sensors: null
    property var model: model
    property var selected_item: list.currentIndex
    property var chart: null
    property variant columnWidths: null
    width: 120;
    height: parent.height
    color: "yellow"
    property var colorpickeropen:false

    ListModel {
        id: model
    }

    Rectangle {
        id: properties
        x: 100;
        y: sid*20;
        width: 140;
        height: 100
        visible: false
        color: "#bb252b31"
        border.color: "orange"
        border.width: 2
        property var sid

        Column{
        Text { color:"#eeeeee"; text: '<b>Min</b>: <i>'+((model.get(sid)["minval"]==0)?0:(Math.abs(model.get(sid)["minval"])<10)?model.get(sid)["minval"].toFixed(2):((Math.abs(model.get(sid)["minval"])<24)?model.get(sid)["minval"].toFixed(1):model.get(sid)["minval"].toFixed()))+'</i>'}
        Text { color:"#eeeeee"; text: '<b>Max</b>: <i>'+((model.get(sid)["maxval"]==0)?0:(Math.abs(model.get(sid)["maxval"])<10)?model.get(sid)["maxval"].toFixed(2):((Math.abs(model.get(sid)["maxval"])<24)?model.get(sid)["maxval"].toFixed(1):model.get(sid)["maxval"].toFixed()))+'</i>'}
        }
    }

    Component {
        id: delegate
        Item{
            id: itemcontainer
            width: list.width; height: 20
            clip: true

            MouseArea{
                anchors.fill: parent
//                hoverEnabled: true
//                cursorShape: Qt.BusyCursor

//                onEntered: {
//                    console.log("triggered")
//                    properties.sid=index;
//                    properties.visible = true;
//                }
//                onExited: console.log("hidden")//properties.visible = false;

                onClicked: {
                    list.currentIndex=index;
                    properties.x = itemcontainer.x + itemcontainer.width-2;
                    properties.y = Math.min(list.currentItem.y,list.height-properties.height);
                }
            }
            Row {
                spacing: 5
                Item{width:2;height: 2}

                CheckBox {
                    id: checkBox1
                    height: 16
                    width: 16
                    anchors.verticalCenter: parent.verticalCenter
                    checked: sensors.items[index].checked

                    onCheckedChanged: {
                        sensors.items[index].checked = checked;
                        chart.update();
                    }
                }

                Rectangle{
                    id: colorIndicator
                    width: 12;
                    height: 12;
                    border.width: 1;
                    border.color:"black" ;
                    anchors.verticalCenter: parent.verticalCenter;
                    property var current_color: itemcolor
                    color: current_color;

                    MouseArea{
                        id: leftdrawerMouseArea
                        anchors.fill:parent
                        onClicked:{
                            var colorcomponent = Qt.createComponent("ColorPicker.qml");
                            if (colorcomponent.status == Component.Ready)
                                {
                                if(!colorpickeropen){
                                    colorpickeropen=true;
                                    var colordialog = colorcomponent.createObject(root, {startcol: colorIndicator.current_color, color: "#252b31", x: colorIndicator.x+colorIndicator.width, y: index*itemcontainer.height, width:320, height:200});
                                    colordialog.accepted.connect(function(newColor){
                                        colorIndicator.current_color = newColor;
                                        sensors.items[index].color = String(newColor)+"";
                                        chart.update()
                                        colorpickeropen=false;
                                        colordialog.destroy();
                                        })
                                    colordialog.cancel.connect(function(){
                                        colorpickeropen=false;
                                        colordialog.destroy();
                                        })
                                    }
                                }
                            else console.log("ColorDialog.qml could not be loaded.")
                        }
                    }
                }
                Text { color:"#eeeeee"; text: name; clip:true}
                Text { color:"#eeeeee"; text: '| '+((value ==0)?0:(Math.abs(value )<10)?value.toFixed(2):((Math.abs(value)<24)?value.toFixed(1):value.toFixed()))+' '+unit; clip:true}
            }
        }
    }

    Component {
        id: highlight
        Rectangle {
            width: list.width; height: 4
            color: "#44ff7700";
            y: list.currentItem.y

            Rectangle{
                x:parent.width;
                width: 2;
                height: parent.width;
                transformOrigin: Item.TopLeft
                rotation: 90
                gradient: Gradient {
//                    GradientStop { position: 0.0; color: "#00ffa500" }
                    GradientStop { position: 0.0; color: "orange" }
                    GradientStop { position: 1.0; color: "#00ffa500" }
                }
            }

            Rectangle{
                y:parent.height
                x:parent.width;
                width: 2;
                height: parent.width;
                transformOrigin: Item.TopLeft
                rotation: 90
                gradient: Gradient {
//                    GradientStop { position: 0.0; color: "#00ff7700" }
                    GradientStop { position: 0.0; color: "orange" }
                    GradientStop { position: 1.0; color: "#00ff7700" }
                }
            }

            Behavior on y {
                SpringAnimation {
                    spring: 3
                    damping: 0.2
                }
            }
        }
    }


    ListView {
        id: list
        anchors.fill: parent
        model: model
        delegate: delegate

        boundsBehavior: Flickable.StopAtBounds
        highlight: highlight
        highlightFollowsCurrentItem: true

//        header: Rectangle{
//                    width: parent.width
//                    height: 16
//                    color: "#00252b31"

//                    Row {
//                        CheckBox {
//                            onClicked:{
//                                for(var x=0; x<sensors.items.length;x++)
//                                    {
//                                    sensors.items[x].checked = checked;
//                                    checkBox1.checked = sensors.items[x].checked;
//                                    }
//                                chart.update();
//                            }
//                        }
//                        Rectangle { width:40; height: 5; opacity: 0}
//                        Text { text: 'Name'}
//                        Text { text: '| Val'}
//                    }

//                }

        Scrollbar {
            flickable: list
            vertical: true
            color: "white"
        }
    }
}
