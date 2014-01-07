import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Dialogs 1.0

Rectangle {
    property var sensors: null
    property var model: model
    property var selected_item: list.currentIndex
    property var chart: null
    width: 120;
    height: parent.height
    color: "yellow"

    ListModel {
        id: model
    }

    Component {
        id: delegate
        Item{
            width: list.width; height: 16

            ColorDialog {
                id: colorDialog
                title: "Choose a color"
                color: itemcolor
                onAccepted: {
                            sensors.items[index].color=currentColor;
                            colorIndicator.color = sensors.items[index].color;
                            chart.chart_canvas.requestPaint();
//                            console.log(sensors.items[index].color + "" + colorDialog.color);
                            }
//                onRejected: { console.log("Rejected") }
            }

            MouseArea{
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: {
                    if (mouse.button == Qt.RightButton)
                    {
                        console.log("properties")
                    }
                    else
                    {
                        list.currentIndex=index;
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
                Text { width:100; text: '<b>'+name+'</b>'; clip:true}
                Text { width:40; text: '<i>'+((Math.abs(value)<10)?value.toFixed(2):((Math.abs(value)<24)?value.toFixed(1):value.toFixed()))+'</i>'; clip:true}
            }
        }
    }

    Component {
        id: highlight
        Rectangle {
            width: list.width; height: 4
            color: "lightsteelblue"; radius: 5
            y: list.currentItem.y
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

        header: Rectangle{
                    width: parent.width
                    height: 16
                    opacity: 0.3
                }

        Scrollbar {
            flickable: list
            vertical: true
        }
    }
}
