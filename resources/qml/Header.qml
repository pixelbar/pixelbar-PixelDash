import QtQuick 2.15
import QtQuick.Controls 2.15

import "PixelBar" as PB

Item {
    height: childrenRect.height

    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    anchors.margins: 25

    PB.Label {
        property var spaceOpen: {
            if (app == null || app.sensors.SpaceState.state != 200)
                return undefined
            return app.sensors.SpaceState.values.open
        }
        text: {
            switch(spaceOpen) {
                case true:
                    if (app != null)
                        app.controllers.GPIO.emit({"docklight": true})
                    return "PixelBar is open"
                case false:
                    if (app != null)
                        app.controllers.GPIO.emit({"docklight": false})
                    return "PixelBar is closed"
                case undefined:
                    if (app != null)
                        app.controllers.GPIO.emit({"docklight": false})
                    return "SpaceState is undetermined"
            }
        }
        color: (!spaceOpen) ? "red" : "lime"
    }

    PB.Label {
        id: clockLabel
        color: "darkgreen"
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: clockLabel.text = Qt.formatTime(new Date(), "hh:mm:ss")
    }

    PB.Button {
        id: closeButton
        text: "Close"
        onClicked: Qt.quit()
        anchors.right: parent.right
    }

    Rectangle {
        color: "darkgreen"
        height: 1
        width: parent.width + 2 * 25

        anchors.left: parent.left
        anchors.leftMargin: -25
        anchors.top: closeButton.bottom
        anchors.topMargin: 25
    }
}