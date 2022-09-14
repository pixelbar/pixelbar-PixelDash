import QtQuick 2.15
import QtQuick.Controls 2.15

import "PixelBar" as PB

Column {
    property alias on: power.checked
    property alias linked: link.checked
    property alias channels: channelRepeater

    spacing: 10

    PB.Label
    {
        text: modelData
        font.pointSize: 30
        horizontalAlignment: Text.AlignHCenter
        width: parent.width
    }

    Item {
        width: parent.width
        height: childrenRect.height
        PB.Button {
            id: power
            anchors.left: parent.left
            width: (parent.width - 10) / 2
            height: 35
            checkable: true
            checked: true
            text: checked ? "On" : "Off"
            onClicked: lightsController.publishValues()
        }
        PB.Button {
            id: link
            anchors.right: parent.right
            width: (parent.width - 10) / 2
            height: 35
            text: "Link"
            checkable: true
        }
    }
    Row {
        spacing: 10

        Repeater
        {
            id: channelRepeater
            property var values: {"R": 0, "G": 0, "B": 0, "W": 0}
            property string changedChannel: ""

            function channelValueChanged(channel, value) {
                changedChannel = channel
                channelRepeater.values[channel] = value

                groupRepeater.colorChanged(modelData)
            }

            model: Object.keys(channelRepeater.values)
            delegate: Column {
                property alias value: slider.value
                spacing: 5
                PB.Slider {
                    id: slider
                    orientation: Qt.Vertical
                    from: 0
                    to: 255
                    enabled: power.checked
                    value: channelRepeater.values[modelData]
                    onValueChanged: function() {
                        channelRepeater.channelValueChanged(modelData, value)
                    }
                }
                PB.Label {
                    text: modelData
                    font.pointSize: 20
                    color: "green"
                    horizontalAlignment:  Text.AlignHCenter
                    width: parent.width
                }
            }
        }
    }
}
