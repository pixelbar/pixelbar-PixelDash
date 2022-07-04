import QtQuick 2.15
import QtQuick.Controls 2.15

import "PixelBar" as PB

Grid {
    id: presetsController
    columns: 3
    spacing: 20

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
                    if(unicornAnimation.running) {
                        unicornAnimation.stop()
                    } else {
                        unicornAnimation.restart()
                    }
                } else if (name=="Random") {
                    unicornAnimation.stop()
                    if(randomAnimation.running) {
                        randomAnimation.stop()
                    } else {
                        presetsController.setRandomColor()
                        randomAnimation.restart()
                    }
                } else {
                    unicornAnimation.stop()
                    randomAnimation.stop()
                    lightsController.setValues(model.values)
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
        lightsController.setValues(newValues)
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
        lightsController.setValues(newValues)
    }
}