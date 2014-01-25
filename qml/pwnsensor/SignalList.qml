import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Dialogs 1.0
import QtQuick.Window 2.1

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

    ListModel {
        id: model
    }

    Rectangle {
        id: properties
        x: 100;
        y: 100;
        width: 140;
        height: 100
        visible: false
        color: "#bb252b31"
        border.color: "orange"
        border.width: 2

        Column{
        Text { color:"#eeeeee"; text: '<b>Min</b>: <i>'+((model.get(list.currentIndex)["minval"]==0)?0:(Math.abs(model.get(list.currentIndex)["minval"])<10)?model.get(list.currentIndex)["minval"].toFixed(2):((Math.abs(model.get(list.currentIndex)["minval"])<24)?model.get(list.currentIndex)["minval"].toFixed(1):model.get(list.currentIndex)["minval"].toFixed()))+'</i>'}
        Text { color:"#eeeeee"; text: '<b>Max</b>: <i>'+((model.get(list.currentIndex)["maxval"]==0)?0:(Math.abs(model.get(list.currentIndex)["maxval"])<10)?model.get(list.currentIndex)["maxval"].toFixed(2):((Math.abs(model.get(list.currentIndex)["maxval"])<24)?model.get(list.currentIndex)["maxval"].toFixed(1):model.get(list.currentIndex)["maxval"].toFixed()))+'</i>'}
        }
        Behavior on y {
            SpringAnimation {
                spring: 3
                damping: 0.2
            }
        }
    }

    Component {
        id: delegate
        Item{
            id: itemcontainer
            width: list.width; height: 16
            clip: true

            ColorDialog {
                id: colorDialog
                title: "Choose a color"
                color: itemcolor
                onAccepted: {
                            sensors.items[index].color=currentColor;
                            colorIndicator.color = sensors.items[index].color;
                            chart.update();
//                            console.log(sensors.items[index].color + "" + colorDialog.color);
                            }
//                onRejected: { console.log("Rejected") }
            }

            MouseArea{
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: {
                    list.currentIndex=index;
                    properties.x = itemcontainer.x + itemcontainer.width-2;
                    properties.y = Math.min(list.currentItem.y,list.height-properties.height);
                    if (mouse.button == Qt.RightButton)
                    {
//                        properties.visible = true;
                    }
                    else
                    {

                    }
                }
            }
            Row {
                spacing: 5
                CheckBox {
                    id: checkBox1
                    anchors.verticalCenter: parent.verticalCenter
                    checked: sensors.items[index].checked

                    onClicked:{
                        sensors.items[index].checked = checked;
                        chart.update();
//                        if(checked)
//                            console.log("adding " + index);
//                        else
//                            console.log("removing " + index);
//                        list.currentIndex=index;

                    }

//                        text: name
                }
                Rectangle{
                    id: colorIndicator
                    width: 12;
                    height: 12;
                    border.width: 1;
                    border.color:"black" ;
                    anchors.verticalCenter: parent.verticalCenter;
                    color: itemcolor;
                    MouseArea{
                        id: leftdrawerMouseArea
                        anchors.fill:parent
                        onClicked:{
                            colorDialog.open()
                        }
                    }
                }
                Text { color:"#eeeeee"; text: name; clip:true}
                Text { color:"#eeeeee"; text: '| '+((value ==0)?0:(Math.abs(value )<10)?value.toFixed(2):((Math.abs(value)<24)?value.toFixed(1):value.toFixed()))+''; clip:true}
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
