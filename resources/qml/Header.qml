import QtQuick
import QtQuick.Controls

import "PixelBar" as PB

Item {
    width: parent.width
    height: childrenRect.height

    PB.Label {
        property var spaceOpen: {
            if (app == null || app.sensors.SpaceState.state != 200)
                return undefined
            return app.sensors.SpaceState.values.open
        }
        text: {
            switch(spaceOpen) {
                case true:
                    return "PixelBar is open"
                case false:
                    return "PixelBar is closed"
                case undefined:
                    return "SpaceState is undetermined"
            }
        }
        color: (!spaceOpen) ? "red" : "lime"
    }

    PB.Button {
        text: "Exit"
        onClicked: Qt.quit()
        anchors.right: parent.right
    }
}