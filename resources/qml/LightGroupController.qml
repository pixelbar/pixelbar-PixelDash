import QtQuick 2.15
import QtQuick.Controls 2.15

import "PixelBar" as PB

Column {
    property alias on: power.checked
    property alias linked: link.checked
    property alias channels: channelRepeater

    spacing: 10

    Item {
        width: parent.width
        height: groupName.height
        PB.Label
        {
            id: groupName
            text: modelData
            font.pointSize: 30
            horizontalAlignment: Text.AlignLeft
            anchors.right: swatch.left
            anchors.left: parent.left
        }

        Rectangle
        {
            id: swatch
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            height: 0.5 * parent.height
            width: height
            color: "transparent"
            border.width: 1
            border.color: "green"
            visible: power.checked

            Rectangle {
                id: swatchRGB
                width: (parent.width / 2) - 1
                height: parent.height - 2
                x: 1
                y: 1
            }

            Rectangle {
                id: swatchW
                width: (parent.width / 2) - 1
                height: parent.height - 2
                anchors.right: parent.right
                anchors.rightMargin: 1
                y: 1
            }

            Connections {
                target: channels
                function onChannelValuesChanged() {
                    swatchRGB.color = Qt.rgba(channels.values["R"] / 255, channels.values["G"] / 255, channels.values["B"] / 255, 1)
                    swatchW.opacity = channels.values["W"] / 255
                }
            }
        }
    }

    Item {
        width: parent.width
        height: childrenRect.height
        PB.Button {
            id: power
            anchors.left: parent.left
            width: (parent.width - 10) / 2
            height: 40
            checkable: true
            checked: true
            text: checked ? "On" : "Off"
            onClicked: lightsController.publishValues()
        }
        PB.Button {
            id: link
            anchors.right: parent.right
            width: (parent.width - 10) / 2
            height: 40
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
            signal channelValuesChanged

            function channelValueChanged(channel, value) {
                changedChannel = channel
                channelRepeater.values[channel] = value
                channelRepeater.channelValuesChanged()

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
