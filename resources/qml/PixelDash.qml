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

    Header {
        id: header
    }

    Row {
        spacing: 20

        id: lorem

        anchors.top: header.bottom
        anchors.topMargin: 50

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
            onTextChanged: function(text) {
                graph.addValue(parseFloat(text))
            }
        }

        PB.SparkLine {
            id: graph
        }

        Item {
            width: childrenRect.width
            height: parent.height
            PB.Label {
                text: graph.max.toFixed(2)
                color: "green"
                font.pointSize: 20
                anchors.top: parent.top
            }
            PB.Label {
                text: graph.min.toFixed(2)
                color: "green"
                font.pointSize: 20
                anchors.bottom: parent.bottom
            }
        }
    }

    SensorBlock {
        id: ipsum

        anchors.top: lorem.bottom
        anchors.topMargin: 50

        sensor: (app != null) ? app.sensors.Weather : null
        name: "Weather"

        Layout.alignment: Qt.AlignTop
    }

}
