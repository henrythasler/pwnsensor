import QtQuick 2.0
import QtQuick.Window 2.1

Window{
    id:colordialog
    title: "My MainWindow"
    width: 320
    height: 200
    visible: true
//    modality: Qt.ApplicationModal
    property string currentcolor
    property var colors: {"red", "green"}

    signal accepted(string newColor)

    ListModel {
        id: model
    }

    Component.onCompleted: {
        var palette = ["red","greenyellow","limegreen","dodgerblue","cyan","magenta","pink","yellow","orange","white"];
        for (var i = 0; i < palette.length; i++)
            model.append({"itemcolor": palette[i]});
    }
    GridView {
        id: grid
        width: parent.width
        height: parent.height-ok_button.height
        model: model
        cellWidth: 32
        cellHeight: 32
        delegate: Column {
            Rectangle{
                width: grid.cellWidth*0.8; height: grid.cellHeight*0.8; color: itemcolor; border.width: 1; border.color: "black"
                MouseArea{anchors.fill: parent;onClicked: currentcolor=itemcolor;}
            }
        }
    }

    Row{
        x: 0
        y: 162
        spacing: 2
        Rectangle{
            id: current;
            width: 96
            height: 32
            color: currentcolor;
        }

        Button{
            id: cancel_button
            width: 96
            height: 32
            text:"Cancel";
            onClicked: {
                colordialog.destroy();
            }
        }
        Button{
            id: ok_button
            width: 96
            height: 32
            text:"Ok";
            onClicked: {
                colordialog.accepted(currentcolor);
                colordialog.destroy();
            }
        }
    }
}


