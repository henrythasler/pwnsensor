import QtQuick 2.0

Item {
    id: root
    width: 100
    height: 62
    property alias text: textContainer.text
    property alias hideDelay: hideTimer.interval //this makes it easy to have custom hide delays
                                                 //for different tools
    property alias showDelay: showTimer.interval

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true

        Timer {
            id:showTimer
            interval: 1000
//            repeat: true
            running: (mouseArea.containsMouse && !tooltip.visible)
            onTriggered: {
                tooltip.visible = true;
                tooltip.x = mouseArea.mouseX
                tooltip.y = mouseArea.mouseY-tooltip.height
            }
        }

        Timer {
            id:hideTimer
            interval: 100 //ms before the tip is hidden
            running: !mouseArea.containsMouse && tooltip.visible
            onTriggered: tooltip.visible = false;
        }

        Rectangle {
            id:tooltip
            property int verticalPadding: 2
            property int horizontalPadding: 5
            width: textContainer.width + horizontalPadding * 2
            height: textContainer.height + verticalPadding * 2
            radius: 8
            color: "#cc444444"
            Text {
                color: "#eeeeee"
                anchors.centerIn: parent
                id:textContainer
                text: "Tooltip"
            }
            visible:false
        }
    }
}

