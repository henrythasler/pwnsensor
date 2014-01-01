import QtQuick 2.0
import QtQuick.Controls 1.1

Rectangle {
    property var sensors: null
    property var model: model
    property var selected_item: list.currentIndex
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
                    onClicked:{
                        if(checked)
                            console.log("adding " + index);
                        else
                            console.log("removing " + index);
                        list.currentIndex=index;
                    }
//                        text: name
                }
                Rectangle{width: 10; height: 10;  anchors.verticalCenter: parent.verticalCenter; color: itemcolor;}
                Text { width:100; text: '<b>'+name+'</b>'; clip:true}
                Text { width:40; text: '<i>'+value+'</i>'; clip:true}
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

        Scrollbar {
            flickable: list
            vertical: true
        }
    }
}
