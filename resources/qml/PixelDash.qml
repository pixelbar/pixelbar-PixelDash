import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "PixelBar" as PB

ApplicationWindow {
    id: window
    visible: true
    visibility: "FullScreen"
    width: 1920
    height: 1080

    background: Rectangle {
        color: "black"
    }


    Row {
        spacing: 20

        PB.Button {
            text: "Test"
            onClicked: checked = !checked
            autoResetInterval: 2000
        }

        PB.Label {
            text: (app != null) ? app.test : ""
        }

        PB.Slider {
            id: slider
            orientation: Qt.Horizontal
        }

        PB.Label {
            id: value
            text: slider.value.toFixed(2)
        }
    }
}
