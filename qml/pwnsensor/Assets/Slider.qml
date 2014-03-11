/****************************************************************************
**
** Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the QtDeclarative module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and Digia.  For licensing terms and
** conditions see http://qt.digia.com/licensing.  For further information
** use the contact form at http://qt.digia.com/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 2.1 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU Lesser General Public License version 2.1 requirements
** will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** In addition, as a special exception, Digia gives you certain additional
** rights.  These rights are described in the Digia Qt LGPL Exception
** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3.0 as published by the Free Software
** Foundation and appearing in the file LICENSE.GPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU General Public License version 3.0 requirements will be
** met: http://www.gnu.org/copyleft/gpl.html.
**
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.0
import "utils.js" as Utils

Item {
    id: root;

    property real radius: 0
    property real border_width: 0
    property real handle_width: 5
    property bool dragActive: false

    property real value: 1
    property real maximum: 1
    property real minimum: 1
    property real stepSize: 1

    signal changed(real newval)

    onValueChanged: {
        var hrange = root.width-2*root.border_width-handle.width;
        var steps = (root.maximum-root.minimum)/root.stepSize;
        var hstepsize = hrange/steps;
        handle.x = (value-root.minimum)/ root.stepSize * hstepsize+root.border_width;
    }

    Rectangle {
        anchors.fill: parent
        border.color: "#eeeeeeee";
        border.width: root.border_width;
        radius: root.radius;
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#66666666" }
            GradientStop { position: 1.0; color: "#66000000" }
        }
    }

    Rectangle {
        id: handle; smooth: true
        x: root.border_width;
        y: root.border_width;
        width: root.handle_width;
        height: root.height-2*root.border_width;
        radius: root.radius-root.border_width;
        border.color: "grey"
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#eeeeee" }
            GradientStop { position: 1.0; color: "#aaaaaa" }
        }
    }

    MouseArea{
        anchors.fill: parent
        onPressed: dragActive=true;
        onReleased: dragActive=false;
        onPositionChanged: {
            if (mouse.buttons & Qt.LeftButton)
            {
                var hrange = root.width-2*root.border_width-handle.width;
                var steps = (root.maximum-root.minimum)/root.stepSize;
                var hstepsize = hrange/steps;
                var new_val = Math.round(Utils.clamp(mouse.x-handle.width/2,root.border_width,root.width-root.border_width-handle.width)/hrange * steps);
                root.changed(root.minimum+new_val*root.stepSize);
                handle.x = new_val * hstepsize+root.border_width;
//                console.log(new_val)
            }
        }
    }
}
