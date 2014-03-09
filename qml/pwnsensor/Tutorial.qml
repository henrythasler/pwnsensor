import QtQuick 2.0
//import QtQuick.Controls 1.1

Item {
    id: root
    anchors.fill: parent

    state: "1"
    states:[
        State {
            name: "1"
            PropertyChanges { target: text_step1; visible:true}
            PropertyChanges { target: text_step2; visible:false}
              },
        State {
            name: "2"
            PropertyChanges { target: text_step1; visible:false}
            PropertyChanges { target: text_step2; visible:true}
              },
        State {
            name: "3"
            PropertyChanges { target: text_step2; visible:false}
            PropertyChanges { target: text_step3; visible:true}
              },
        State {
            name: "4"
            PropertyChanges { target: text_step3; visible:false}
            PropertyChanges { target: text_step4; visible:true}
            PropertyChanges { target: root.parent; state:"LEFT_DRAWER_OPEN"}
              }
           ]

    Rectangle{
        width: 396
        height: 240
        anchors.centerIn: parent
        radius: 10
//        color: "#ffffff"

        Text {
            id: text1
            x: 8
            y: 8
            text: qsTr("pwnsensor - Tutorial - Step ")+ root.state
            style: Text.Normal
            font.bold: true
            font.pixelSize: 14
        }

        Text {
            id: button2
            x: 8
            y: 205
            text: qsTr("Close")
            MouseArea{
                anchors.fill: parent
                onClicked: {root.visible=false;}
            }
        }

        Text {
            id: button3
            x: 212
            y: 205
            text: qsTr("Back")
            MouseArea{
                anchors.fill: parent
                onClicked: { if(root.state > 1) root.state--; }
            }
        }

        Text {
            id: button1
            x: 303
            y: 205
            text: qsTr("Continue")
            MouseArea{
                anchors.fill: parent
                onClicked: { if(root.state < root.states.length) root.state++; }
            }
        }

        Text{ id: text_step1; x: 9; y: 37; width: 378; height: 152; wrapMode: Text.WordWrap; visible: false;
            text: "Welcome to pwnsensor.<br>This app is used to display internal sensors (e.g. CPU temperature, fan speeds). This short tutorial will give you a short overview of the functionality and user interface.";
        }
        Text{ id: text_step2; x: 9; y: 37; width: 378; height: 152; wrapMode: Text.WordWrap; visible: false;
            text: "The main window shows the sensor graphs and scrolls from right to left. This means the latest value is shown on the right edge of the chart.<br>Use the mouse wheel to scale the timeline. The current scale is shown at the bottom of the chart.";
        }
        Text{ id: text_step3; x: 9; y: 37; width: 378; height: 152; wrapMode: Text.WordWrap; visible: false;
            text: "Cick the small icon on the top left side, to open the signal list.";
        }
        Text{ id: text_step4; x: 9; y: 37; width: 378; height: 152; wrapMode: Text.WordWrap; visible: false;
            text: "This list shows all available sensors and their current value and color. You can select an entry with you left mouse button. Use the checkbox in each line to show/hide the corresponding graph.";
        }
        Text{ id: text_step5; x: 9; y: 37; width: 378; height: 152; wrapMode: Text.WordWrap; visible: false;
            text: "Use your left mouse button to pan every signal graph up and down.";
        }
    }

}
