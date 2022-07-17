import QtQuick 2.15
import QtQuick.Controls 2.15


Slider {
    id: control

    MouseArea {
        anchors.fill: parent
        propagateComposedEvents: true
        onPressed: function(mouseEvent) {
            // fix slider not responding to touchscreen until release or move
            if (control.vertical) {
                var position = 1.0 - (mouseEvent.y/control.availableHeight)
            } else {
                var position = mouseEvent.x/control.availableWidth
            }
            control.value = control.from + (control.to - control.from) * position

            // propagate event to control
            mouseEvent.accepted = false
        }
    }

    background: Rectangle {
        x: control.vertical ? control.leftPadding + control.availableWidth / 2 - width / 2 : control.leftPadding
        y: control.vertical ? control.topPadding : control.topPadding + control.availableHeight / 2 - height / 2
        implicitWidth: control.vertical ? 2 : 200
        implicitHeight: control.vertical ? 200 : 2
        width: control.vertical ? implicitWidth : control.availableWidth
        height: control.vertical ? control.availableHeight : implicitHeight
        color: "darkgreen"

        Rectangle {
            anchors.bottom: parent.bottom
            width: control.vertical ? parent.width : control.visualPosition * parent.width
            height: control.vertical ? (1 - control.visualPosition) * parent.height : parent.height
            color: "lime"
            visible: control.enabled
        }
    }

    handle: Rectangle {
        x: {
            if (control.vertical) {
                control.leftPadding + control.availableWidth / 2 - width / 2
            }
            return control.leftPadding + control.visualPosition * (control.availableWidth - width)
        }
        y: {
            if (control.vertical) {
                return control.availableHeight - (height - control.topPadding) - (1 - control.visualPosition) * (control.availableHeight - height)
            }
            return control.topPadding + control.availableHeight / 2 - height / 2
        }
        implicitWidth: control.vertical ? 40 : 20
        implicitHeight: control.vertical ? 20 : 40
        visible: control.enabled
        color: {
            if (control.checked) {
                if (control.down) {
                    return "limegreen"
                }
                return "lime"
            }
            return "black"
        }
        border.color: {
            if (control.pressed)
                return "limegreen"
            return "lime"
        }
        border.width: 1
    }
}