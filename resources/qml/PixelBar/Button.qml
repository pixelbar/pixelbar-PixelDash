import QtQuick 2.15
import QtQuick.Controls 2.15

Button {
	id: control

    property real autoResetInterval: 0
    property real fontSize: 20

    onCheckedChanged: {
        if (control.autoResetInterval > 0) {
            if (control.checked) {
                autoResetTimer.start()
            } else {
                autoResetTimer.stop()
            }
        }
    }

    contentItem: Text {
        text: control.text
        font.family: "Arial"
        font.pointSize: control.fontSize
        opacity: enabled ? 1.0 : 0.3
        color: {
        	if (control.checked)
        		return "black"
        	if (control.down)
        		return "limegreen"
        	return "lime"
        }
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        implicitWidth: 200
        implicitHeight: 60
        opacity: enabled ? 1 : 0.3
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
        	if (control.down)
        		return "limegreen"
        	return "lime"
        }
        border.width: 1
    }

    Timer {
        id: autoResetTimer
        repeat: false
        interval: control.autoResetInterval

        onTriggered: control.checked = false
    }
}