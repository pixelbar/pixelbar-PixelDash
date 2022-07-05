import QtQuick 2.15
import QtQuick.Controls 2.15

import "PixelBar" as PB

Column {
    spacing: 20

    PB.Label
    {
        text: "Lights"
    }

    Row {
        id: lightsController

        spacing: 50
        property var values: {"Door":"ffffffff", "Stairs":"ffffffff", "Beamer":"ffffffff", "Kitchen":"ffffffff"}
        property bool inhibitPublish: false

        function publishValues() {
            if (inhibitPublish)
                return

            var newValues = Object.assign({}, lightsController.values);
            for(var groupIndex in groupRepeater.model) {
                if (groupRepeater.itemAt(groupIndex) == null)
                    return
                var groupHex = ""
                if (groupRepeater.itemAt(groupIndex).on) {
                    var channels = groupRepeater.itemAt(groupIndex).channels
                    for(var channelIndex in channels.model) {
                        if (channels.itemAt(channelIndex) == null)
                            return
                        var channelValue = Math.floor(channels.itemAt(channelIndex).value)
                        var valueHex = channelValue.toString(16).padStart(2, "0")
                        groupHex += valueHex
                    }
                } else {
                    groupHex = "00000000"
                }
                newValues[groupRepeater.model[groupIndex]] = groupHex
            }
            if(JSON.stringify(newValues) != JSON.stringify(lightsController.values))
             {
                lightsController.values = newValues
                print(JSON.stringify(lightsController.values))
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
                    channels.itemAt(channelIndex).value = parseInt(channelValues.substr(2*channelIndex, 2), 16)
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
                lightsController.publishValues()
            }

            model: Object.keys(lightsController.values)
            delegate: LightGroupController{}
        }

        Column {
            spacing: 20

            function switchGroups(on) {
                lightsController.inhibitPublish = true
                for(var index in groupRepeater.model) {
                    groupRepeater.itemAt(index).on = on
                }
                lightsController.inhibitPublish = false
                lightsController.publishValues()
            }

            function linkGroups(linked) {
                for(var index in groupRepeater.model) {
                    groupRepeater.itemAt(index).linked = linked
                }
            }

            PB.Button {
                text: "All on"
                onClicked: parent.switchGroups(true)
            }
            PB.Button {
                text: "All off"
                onClicked: parent.switchGroups(false)
            }
            PB.Button {
                text: "Link all"
                onClicked: parent.linkGroups(true)
            }
            PB.Button {
                text: "Link none"
                onClicked: parent.linkGroups(false)
            }
        }
    }

    LightsPresets {}
}