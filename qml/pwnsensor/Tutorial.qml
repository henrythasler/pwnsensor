import QtQuick 2.0
import "Assets"

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
              },
        State {
            name: "5"
            PropertyChanges { target: text_step4; visible:false}
            PropertyChanges { target: text_step5; visible:true}
            PropertyChanges { target: root.parent; state:"LEFT_DRAWER_OPEN"}
              },
        State {
            name: "6"
            PropertyChanges { target: text_step5; visible:false}
            PropertyChanges { target: text_step6; visible:true}
            PropertyChanges { target: root.parent; state:"LEFT_DRAWER_OPEN"}
              },
        State {
            name: "7"
            PropertyChanges { target: text_step6; visible:false}
            PropertyChanges { target: text_step7; visible:true}
            PropertyChanges { target: root.parent; state:"LEFT_DRAWER_OPEN"}
              },
        State {
            name: "8"
            PropertyChanges { target: text_step7; visible:false}
            PropertyChanges { target: text_step8; visible:true}
            PropertyChanges { target: root.parent; state:"SETTINGS_DRAWER_OPEN"}
              },
        State {
            name: "9"
            PropertyChanges { target: text_step8; visible:false}
            PropertyChanges { target: text_step9; visible:true}
            PropertyChanges { target: root.parent; state:"LEFT_DRAWER_CLOSED"}
              }
           ]

    Rectangle{
        width: 396
        height: 240
        anchors.centerIn: parent
        radius: 10
        border.color: "orange"
        border.width: 2

        gradient: Gradient {
            GradientStop { position: 0.0; color: "#cc444444" }
            GradientStop { position: 1.0; color: "#252b31" }
        }
//        color: "#ffffff"

        Text {
            id: text1
            x: 8
            y: 8
            color:"white"
            text: qsTr("pwnsensor - Tutorial - Step ")+ root.state
            style: Text.Normal
            font.bold: true
            font.pixelSize: 14
        }

        Button {
            id: button2
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.margins: 10
            height: 24
            width: 64

            label: qsTr("Close")
            onClicked: root.visible=false;
        }

        Button {
            id: button3
            anchors.bottom: parent.bottom
            anchors.right: button1.left
            anchors.margins: 10
            height: 24
            width: 64
            label: qsTr("Back")
            onClicked: { if(root.state > 1) root.state--; }
        }

        Button {
            id: button1
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.margins: 10
            height: 24
            width: 64
            label: qsTr("Continue")
            onClicked: {
                if(root.state < root.states.length) root.state++;
                else root.visible=false;
            }
        }

        Text{ id: text_step1; x: 9; y: 37; width: 378; height: 152; wrapMode: Text.WordWrap; visible: false; color:"white";
            text: qsTr("Welcome to pwnsensor.<br>This app is used to display internal sensors (e.g. CPU temperature, fan speeds). This short tutorial will give you a short overview of the functionality and user interface.");
        }
        Text{ id: text_step2; x: 9; y: 37; width: 378; height: 152; wrapMode: Text.WordWrap; visible: false; color:"white";
            text: qsTr("The main window shows the sensor graphs and scrolls from right to left. This means the latest value is shown on the right edge of the chart.");
        }
        Text{ id: text_step3; x: 9; y: 37; width: 378; height: 152; wrapMode: Text.WordWrap; visible: false; color:"white";
            text: qsTr("Use the <b>mouse wheel</b> to scale the timeline. The current scale is shown at the bottom of the chart.");
        }
        Text{ id: text_step4; x: 9; y: 37; width: 378; height: 152; wrapMode: Text.WordWrap; visible: false; color:"white";
            text: qsTr("Click the small icon on the top left side, to open the <b>signal list</b>.");
        }
        Text{ id: text_step5; x: 9; y: 37; width: 378; height: 152; wrapMode: Text.WordWrap; visible: false; color:"white";
            text: qsTr("This list shows all available sensors, their current value and color. You can select an entry with you left mouse button. Use the checkbox in each line to show/hide the corresponding graph. Click the small <b>colored square</b> to change its color");
        }
        Text{ id: text_step6; x: 9; y: 37; width: 378; height: 152; wrapMode: Text.WordWrap; visible: false; color:"white";
            text: qsTr("Use your left mouse button to <b>pan</b> the currently selected signal up and down. The scale on the right side changes accordingly.");
        }
        Text{ id: text_step7; x: 9; y: 37; width: 378; height: 152; wrapMode: Text.WordWrap; visible: false; color:"white";
            text: qsTr("There is also a cursor on the right side (the little white triangles). You can drag it over the currently selected sensor item to examine the chart.");
        }
        Text{ id: text_step8; x: 9; y: 37; width: 378; height: 152; wrapMode: Text.WordWrap; visible: false; color:"white";
            text: qsTr("There is another drawer on the left, that contains various settings. The refreshrate means how often (in milliseconds) the charts are updated on the screen. This setting affects the CPU load generated by this app. Choose a higher (=less often) value on a slow machine.<br><br>The samplerate determines how often (also milliseconds) new sensor values are stored. The higher the value the longer you can record sensor values before the old ones are overwritten.");
        }
        Text{ id: text_step9; x: 9; y: 37; width: 378; height: 152; wrapMode: Text.WordWrap; visible: false; color:"white";
            text: qsTr("Thats it! Enjoy.");
        }
    }

}
