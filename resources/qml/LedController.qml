import QtQuick
import QtQuick.Controls

import "PixelBar" as PB

Column {
    spacing: 20

    PB.Label
    {
        text: "Lights"
    }

    Row {
        id: ledController

        spacing: 50
        property var values: {"Door":"ffffffff", "Stairs":"ffffffff", "Beamer":"ffffffff", "Kitchen":"ffffffff"}
        property bool inhibitPublish: false

        function publishValues() {
            if (inhibitPublish)
                return

            var newValues = Object.assign({}, ledController.values);
            for(var groupIndex in groupRepeater.model) {
                if (groupRepeater.itemAt(groupIndex) == null)
                    return
                var groupHex = ""
                if (groupRepeater.itemAt(groupIndex).on) {
                    var channels = groupRepeater.itemAt(groupIndex).channels
                    for(var channelIndex in channels.model) {
                        if (channels.itemAt(channelIndex) == null)
                            return
                        var channelValue = Math.floor(255 * channels.itemAt(channelIndex).value)
                        var valueHex = channelValue.toString(16).padStart(2, "0")
                        groupHex += valueHex
                    }
                } else {
                    groupHex = "00000000"
                }
                newValues[groupRepeater.model[groupIndex]] = groupHex
            }
            if(JSON.stringify(newValues) != JSON.stringify(ledController.values))
             {
                ledController.values = newValues
                print(JSON.stringify(ledController.values))
            }
        }

        function setValues(values) {
            inhibitPublish = true
            for(var groupIndex in groupRepeater.model) {
                if (groupRepeater.itemAt(groupIndex) == null)
                    return
                var groupName = groupRepeater.model[groupIndex]
                var channelValues = values[groupName]
                var channels = groupRepeater.itemAt(groupIndex).channels
                for(var channelIndex in channels.model) {
                    if (channels.itemAt(channelIndex) == null)
                        return
                    channels.itemAt(channelIndex).value = parseInt(channelValues.substr(2*channelIndex, 2), 16)/255
                }
            }
            inhibitPublish = false
            publishValues()
        }

        Component.onCompleted: {
            setValues(values)
        }

        Repeater {
            id: groupRepeater

            function colorChanged(group) {
                var groupIndex = model.indexOf(group)
                var changedGroup = groupRepeater.itemAt(groupIndex)
                var changedChannel = changedGroup.channels.changedChannel
                var changedChannelIndex = changedGroup.channels.model.indexOf(changedChannel)
                var changedChannelValue = changedGroup.channels.values[changedChannel]

                if(changedGroup.linked)
                {
                    for(var index in groupRepeater.model) {
                        var otherGroup = groupRepeater.itemAt(index)
                        if(index != groupIndex && otherGroup.linked) {
                            otherGroup.channels.itemAt(changedChannelIndex).value = changedChannelValue
                        }
                    }
                }
                ledController.publishValues()
            }

            model: Object.keys(ledController.values)
            delegate: Column {
                property alias on: power.checked
                property alias linked: link.checked
                property alias channels: channelRepeater

                onOnChanged: function() {
                    ledController.publishValues()
                }

                spacing: 10

                PB.Label
                {
                    text: modelData
                    font.pointSize: 30
                    horizontalAlignment:  Text.AlignHCenter
                    width: parent.width
                }

                Item {
                    width: parent.width
                    height: childrenRect.height
                    PB.Button {
                        id: power
                        anchors.left: parent.left
                        checked: true
                        text: checked ? "On" : "Off"
                        onClicked: checked = !checked
                        width: (parent.width - 10) / 2
                    }
                    PB.Button {
                        id: link
                        anchors.right: parent.right
                        text: "Link"
                        onClicked: checked = !checked
                        width: (parent.width - 10) / 2
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
        }

        Column {
            spacing: 20

            PB.Button {
                text: "All on"
                onClicked: {
                    ledController.inhibitPublish = true
                    for(var index in groupRepeater.model) {
                        groupRepeater.itemAt(index).on = true
                    }
                    ledController.inhibitPublish = false
                    ledController.publishValues()
                }
            }
            PB.Button {
                text: "All off"
                onClicked: {
                    ledController.inhibitPublish = true
                    for(var index in groupRepeater.model) {
                        groupRepeater.itemAt(index).on = false
                    }
                    ledController.inhibitPublish = false
                    ledController.publishValues()
                }
            }
            PB.Button {
                text: "Link all"
                onClicked: {
                    for(var index in groupRepeater.model) {
                        groupRepeater.itemAt(index).linked = true
                    }
                }
            }
            PB.Button {
                text: "Link none"
                onClicked: {
                    for(var index in groupRepeater.model) {
                        groupRepeater.itemAt(index).linked = false
                    }
                }
            }
        }
    }

    ListModel {
        id: ledPresets
        Component.onCompleted: {
            append({"name": "Bright",     "values": {"Door":"ffffffff", "Stairs":"ffffffff", "Beamer":"ffffffff", "Kitchen":"ffffffff"}})
            append({"name": "Pim",        "values": {"Door":"ff3300ff", "Stairs":"ff3300ff", "Beamer":"ff3300ff", "Kitchen":"ff3300ff"}})
            append({"name": "Popcorn",    "values": {"Door":"ff3300ff", "Stairs":"7f19007f", "Beamer":"00000000", "Kitchen":"7f19007f"}})

            append({"name": "Courtisane", "values": {"Door":"ff000000", "Stairs":"ff000000", "Beamer":"ff000000", "Kitchen":"ff000000"}})
            append({"name": "Unicorn",    "values": {"Door":"ff000000", "Stairs":"00ff0000", "Beamer":"0000ff00", "Kitchen":"00ffffff"}})
            append({"name": "Random",     "values": {"Door":"00000000", "Stairs":"00000000", "Beamer":"00000000", "Kitchen":"00000000"}})
        }
    }

    Grid {
        id: presetsController
        columns: 3
        spacing: 20

        Repeater {
            model: ledPresets
            delegate:
            PB.Button {
                text: model.name
                fontSize: 20
                width: 200
                checked: {
                    if (name=="Unicorn") {
                        return unicornAnimation.running
                    } else if (name=="Random") {
                        return randomAnimation.running
                    }
                    return false
                }
                onClicked: {
                    if (name=="Unicorn") {
                        randomAnimation.stop()
                        if(!checked) {
                            unicornAnimation.restart()
                        } else {
                            unicornAnimation.stop()
                        }
                    } else if (name=="Random") {
                        unicornAnimation.stop()
                        if(!checked) {
                            presetsController.setRandomColor()
                            randomAnimation.restart()
                        } else {
                            randomAnimation.stop()
                        }
                    } else {
                        unicornAnimation.stop()
                        randomAnimation.stop()
                        ledController.setValues(model.values)
                    }
                }
            }
        }

        Timer {
            id: randomAnimation
            interval: 1000
            repeat: true
            onTriggered: {
                presetsController.setRandomColor()
            }
        }
        function setRandomColor() {
            var newValues = {}
            var groupNames = ["Door", "Stairs", "Beamer", "Kitchen"]
            for(var i in groupNames) {
                var groupColor = Qt.hsva(Math.random(), Math.random(), 1, 1)
                newValues[groupNames[i]] = (groupColor.toString().substr(1, 6) + "00")
            }
            ledController.setValues(newValues)
        }

        property color unicornColor: "black"
        SequentialAnimation {
            id: unicornAnimation
            running: false
            loops: Animation.Infinite
            property var duration: 1000
            ColorAnimation {
                target:presetsController
                property: "unicornColor"
                duration: 0
                to: "red"
            }
            ColorAnimation {
                target:presetsController
                property: "unicornColor"
                duration: unicornAnimation.duration
                to: "yellow"
            }
            ColorAnimation {
                target:presetsController
                property: "unicornColor"
                duration: unicornAnimation.duration
                to: "green"
            }
            ColorAnimation {
                target:presetsController
                property: "unicornColor"
                duration: unicornAnimation.duration
                to: "blue"
            }
            ColorAnimation {
                target:presetsController
                property: "unicornColor"
                duration: unicornAnimation.duration
                to: "magenta"
            }
            ColorAnimation {
                target:presetsController
                property: "unicornColor"
                duration: unicornAnimation.duration
                to: "red"
            }
        }

        onUnicornColorChanged: function() {
            var hue = unicornColor.hsvHue
            var saturation = unicornColor.hsvSaturation
            var value = unicornColor.hsvValue

            var newValues = {}
            var groupNames = ["Door", "Stairs", "Beamer", "Kitchen"]
            for(var i in groupNames) {
                var groupColor = Qt.hsva((hue + i / 6) % 1, saturation, value, 1)
                newValues[groupNames[i]] = (groupColor.toString().substr(1, 6) + "00")
            }
            ledController.setValues(newValues)
        }
    }
}