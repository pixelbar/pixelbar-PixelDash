import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts  1.15

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

    GridLayout {
        columnSpacing: 100
        rowSpacing: 75
        columns: 3

        anchors.top: header.bottom
        anchors.topMargin: 50

        LedController {
            Layout.columnSpan: 2
            Layout.rowSpan: 2
        }

        DoorController {

        }

        SensorBlock {
            sensor: (app != null) ? app.sensors.Weather : null

            Layout.alignment: Qt.AlignTop
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
        }


        Row {
            spacing: 10

            PB.Slider {
                id: slider
                orientation: Qt.Horizontal
                anchors.verticalCenter: graph.verticalCenter
            }

            PB.Label {
                id: value
                text: slider.value.toFixed(2)
                anchors.verticalCenter: graph.verticalCenter
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
    }
}