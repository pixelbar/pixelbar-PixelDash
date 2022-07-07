import QtQuick 2.15
import QtQuick.Controls 2.15

import "PixelBar" as PB

Column {
    id: block
    spacing: 15
    width: 500

    property var temperatures: (app != undefined) ? [
        {"label":"Table",    "value":app.sensors.IKEA.values["Temperature"]},
        {"label":"Kitchen",  "value":app.sensors.Pim.values["Temperature"]},
        {"label":"Upstairs", "value":app.sensors.Jim.values["Temperature"]},
        {"label":"Outside",  "value":app.sensors.Weather.values["Temperature"]},
    ] : []

    PB.Label
    {
        text: "Climate"
    }

    Repeater
    {
        model: temperatures
        delegate: Item {
            height: childrenRect.height
            width: block.width
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
                text: (modelData.value != undefined) ? modelData.value : "??"
                font.pointSize: 20
                horizontalAlignment: Text.AlignLeft
            }
            PB.Label {
                id: unit
                anchors.right: parent.right
                text: "°C"
                font.pointSize: 20
                horizontalAlignment: Text.AlignLeft
                }
        }
    }
}