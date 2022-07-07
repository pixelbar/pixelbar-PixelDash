import QtQuick 2.15
import QtQuick.Controls 2.15

import "PixelBar" as PB

Row {
    spacing: 10

    PB.Slider {
        id: slider
        orientation: Qt.Horizontal
        anchors.verticalCenter: graph.verticalCenter
    }

    PB.Button {
        id: graphNull
        anchors.verticalCenter: graph.verticalCenter
        checkable: true
        checked: true
        text: "⌁"
        width: height
    }

    PB.Label {
        id: value
        text: (slider.value != undefined) ? slider.value.toFixed(2) : ""
        anchors.verticalCenter: graph.verticalCenter
        color: graphNull.checked ? "limegreen" : "darkgreen"
        onTextChanged: function(text) {
            if(graphNull.checked)
                graph.addValue(parseFloat(text))
            else
                graph.addValue(undefined)
        }
    }

    PB.SparkLine {
        id: graph
    }

    Item {
        width: childrenRect.width
        height: parent.height
        PB.Label {
            text: (graph.max != undefined) ? graph.max.toFixed(2) : ""
            color: "green"
            font.pointSize: 20
            anchors.top: parent.top
        }
        PB.Label {
            text: (graph.min != undefined) ? graph.min.toFixed(2) : ""
            color: "green"
            font.pointSize: 20
            anchors.bottom: parent.bottom
        }
    }
}