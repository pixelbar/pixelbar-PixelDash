import QtQuick 2.15
import QtQuick.Controls 2.15

import "PixelBar" as PB

Column {
    id: block
    spacing: 15
    width: 500

    property var temperatures: (app != undefined) ? [
        {"label":"Table",    "sensor":app.sensors.IKEA},
        {"label":"Kitchen",  "sensor":app.sensors.Pim},
        {"label":"Upstairs", "sensor":app.sensors.Jim},
        {"label":"Couches",  "sensor":app.sensors.Tasmota2},
        {"label":"Outside",  "sensor":app.sensors.Weather},
    ] : []

    PB.Label
    {
        text: "Temperature"
    }

    Row {
        width: parent.width
        spacing: 40

        ListView {
            id: temperatureValues
            spacing: 15
            width: 250
            height: childrenRect.height
            interactive: false

            model: temperatures
            delegate: Item {
                height: childrenRect.height
                width: temperatureValues.width
                PB.Label {
                    id: label
                    anchors.left: parent.left
                    anchors.right: value.left
                    anchors.rightMargin: 10
                    text: modelData.label
                    elide: Text.ElideRight
                    font.pointSize: 20
                    horizontalAlignment: Text.AlignLeft
                }
                PB.Label {
                    id: value
                    anchors.right: unit.left
                    anchors.rightMargin: 10
                    font.pointSize: 20
                    horizontalAlignment: Text.AlignLeft

                    text: (modelData.sensor.values["Temperature"] != undefined) ? modelData.sensor.values["Temperature"] : "??"
                    onTextChanged: {
                        delaySortTimer.restart()
                    }
                }
                PB.Label {
                    id: unit
                    anchors.right: parent.right
                    text: "°C"
                    font.pointSize: 20
                    horizontalAlignment: Text.AlignLeft
                }
            }

            Timer {
                id: delaySortTimer
                running: false
                repeat: false

                interval: 500
                onTriggered: {
                    temperatures.sort(function(a, b) {
                        let a_value = parseFloat(a.sensor.values["Temperature"]);
                        if (isNaN(a_value)) a_value = -273;
                        let b_value = parseFloat(b.sensor.values["Temperature"]);
                        if (isNaN(b_value)) b_value = -273;

                        return b_value - a_value;
                    })
                    temperatureValues.model = temperatures
                }
            }
        }

        Item {
            id: temperatureGraphs
            width: 300
            height: temperatureValues.height

            property var min: undefined
            property var max: undefined

            Repeater
            {
                model: [...temperatures] // create a copy of the original array so were not bothered by the sorting
                delegate: PB.SparkLine {
                    width: temperatureGraphs.width
                    height: temperatureGraphs.height

                    min: temperatureGraphs.min
                    max: temperatureGraphs.max

                    property bool firstFlush: true

                    property var modelValue: modelData.sensor.values["Temperature"]
                    onModelValueChanged: {
                        if(firstFlush) {
                            // ignore the first value, which is always "undefined" because it gets emited
                            // before the first real value has been received
                            firstFlush = false
                            return
                        }

                        addValue(modelValue)

                        if(modelValue != undefined) {
                            if(temperatureGraphs.min == undefined || modelValue < temperatureGraphs.min)
                                temperatureGraphs.min = modelValue
                            if(temperatureGraphs.max == undefined || modelValue > temperatureGraphs.max)
                                temperatureGraphs.max = modelValue
                        }
                    }

                    maximumValues: 150 * Math.floor(60 / modelData.sensor.interval)
                }
            }

            Item {
                anchors.right: temperatureGraphs.right
                width: childrenRect.width
                height: parent.height
                PB.Label {
                    text: (temperatureGraphs.max != undefined) ? temperatureGraphs.max.toString() : ""
                    color: "green"
                    font.pointSize: 12
                    anchors.top: parent.top
                    horizontalAlignment: Text.AlignRight
                }
                PB.Label {
                    text: (temperatureGraphs.min != undefined) ? temperatureGraphs.min.toString() : ""
                    color: "green"
                    font.pointSize: 12
                    anchors.bottom: parent.bottom
                    horizontalAlignment: Text.AlignRight
                }
            }
        }
    }
}
