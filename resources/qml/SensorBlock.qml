import QtQuick 2.15
import QtQuick.Controls 2.15

import "PixelBar" as PB

Column {
    id: block
    spacing: 15

    property var sensor
    property var name: sensor != null ? sensor.name : ""

    property var items:  Array()
    property var itemValues

    Connections {
        target: sensor
        function onDataChanged() {
            if (sensor.state == 200) {
                if (block.items.length == 0) {
                    block.items = Object.keys(sensor.values)
                }
                block.itemValues = sensor.values
            }
        }
    }


    PB.Label
    {
        text: name
        visible: text != ""
    }

    Repeater {
        id: repeater
        model: block.items
        delegate: Row {
            spacing: 10

            Connections {
                target: block

                function onItemValuesChanged() {
                    var value = sensor.values[modelData]
                    graph.addValue(value)
                    valueLabel.text = value.toString()
                }
            }

            PB.Label {
                id: nameLabel
                text: modelData
                anchors.verticalCenter: graph.verticalCenter
                font.pointSize: 20
                width: 180
                elide: Text.ElideRight
                horizontalAlignment: Text.AlignLeft
            }

            PB.Label {
                id: valueLabel
                text: "0"
                anchors.verticalCenter: graph.verticalCenter
                font.pointSize: 20
                width: 100
            }

            PB.SparkLine {
                id: graph
                height: 50
            }

            Item {
                width: childrenRect.width
                height: parent.height
                PB.Label {
                    text: graph.max.toFixed(2)
                    color: "green"
                    font.pointSize: 10
                    anchors.top: parent.top
                    horizontalAlignment: Text.AlignLeft
                }
                PB.Label {
                    text: graph.min.toFixed(2)
                    color: "green"
                    font.pointSize: 10
                    anchors.bottom: parent.bottom
                    horizontalAlignment: Text.AlignLeft
                }
            }
        }
    }
}
