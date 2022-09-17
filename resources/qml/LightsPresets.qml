import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1

import "PixelBar" as PB

GridLayout {
    id: presetsController
    columns: 4
    columnSpacing: 40
    rowSpacing: 10

    property var groupNames: Object.keys(lightsController.values)

    ListModel {
        id: ledPresets
        Component.onCompleted: {
            append({"name": "Bright",     "values": {"Door":"ffffffff", "Stairs":"ffffffff", "Beamer":"ffffffff", "Kitchen":"ffffffff"}})
            append({"name": "Pim",        "values": {"Door":"ff3300ff", "Stairs":"ff3300ff", "Beamer":"ff3300ff", "Kitchen":"ff3300ff"}})
            append({"name": "Popcorn",    "values": {"Door":"ff3300ff", "Stairs":"7f19007f", "Beamer":"00000000", "Kitchen":"7f19007f"}})
            append({"name": "Sunset",     "values": {"Door":"89B3D900", "Stairs":"F2905700", "Beamer":"F2E52E00", "Kitchen":"F2B74900"}})

            append({"name": "Courtisane", "values": {"Door":"ff000000", "Stairs":"ff000000", "Beamer":"ff000000", "Kitchen":"ff000000"}})
            append({"name": "Hulk SMASH!","values": {"Door":"02732A00", "Stairs":"01401700", "Beamer":"038C2500", "Kitchen":"340E5900"}})
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
            enabled: name!=""
            opacity: enabled ? 1 : 0
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
                    transitionAnimation.stop()
                    randomAnimation.stop()
                    if(unicornAnimation.running) {
                        unicornAnimation.stop()
                    } else {
                        unicornAnimation.restart()
                    }
                } else if (name=="Random") {
                    transitionAnimation.stop()
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
                    transitionAnimation.startTransition(lightsController.values, model.values)
                }
            }
        }
    }

    /* Preset transition */
    NumberAnimation {
        id: transitionAnimation
        from: 0
        to: 1
        duration: 500

        target: transitionAnimation
        property: "progress"

        property real progress: 0
        property var fromDecimalValues
        property var toDecimalValues

        onProgressChanged: function() {
            var newValues = {}
            var groupNames = presetsController.groupNames
            for(var i in groupNames) {
                var fromDecimalColor = fromDecimalValues[i]
                var toDecimalColor = toDecimalValues[i]
                var newColor = ""
                for(var c = 0; c < 4; c++) {
                    newColor += Math.floor(
                        toDecimalColor[c] * progress +
                        fromDecimalColor[c] * (1 - progress)
                    ).toString(16).padStart(2, "0")
                }
                newValues[groupNames[i]] = newColor
            }
            lightsController.setValues(newValues)
        }

        function startTransition(fromValues, toValues) {
            var newFromDecimalValues = {}
            var newToDecimalValues = {}
            var groupNames = presetsController.groupNames
            for(var i in groupNames) {
                newFromDecimalValues[i] = []
                newToDecimalValues[i] = []
                for(var c = 0; c < 4; c++) {
                    newFromDecimalValues[i].push(parseInt(fromValues[groupNames[i]].substr(c*2, 2), 16))
                    newToDecimalValues[i].push(parseInt(toValues[groupNames[i]].substr(c*2, 2), 16))
                }
            }
            fromDecimalValues = newFromDecimalValues
            toDecimalValues = newToDecimalValues
            transitionAnimation.start()
        }
    }


    /* Random color animation */
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
        var groupNames = presetsController.groupNames
        for(var i in groupNames) {
            var groupColor = Qt.hsva(Math.random(), .5 + Math.random() / 2, 1, 0)
            // convert #AARRGGBB to RRGGBBAA
            newValues[groupNames[i]] = groupColor.toString().replace(/#(..)(......)/, '$2$1')
        }
        lightsController.setValues(newValues)
    }

    /* Unicorn color animation */
    property color unicornColor: "black"

    Component {
        id: unicornAnimationStep
        ColorAnimation {
            property int index: 0
            target: presetsController
            property: "unicornColor"
            duration: index == 0 ? 0 : unicornAnimation.duration
            to: Qt.hsva((index / 6) % 1, 1, 1, 0)
        }
    }

    SequentialAnimation {
        id: unicornAnimation
        running: false
        loops: Animation.Infinite
        property var duration: 1000

        Component.onCompleted: {
            var animations = []
            for(var i=0; i<7; i++)
                animations.push(unicornAnimationStep.createObject(unicornAnimation, {index: i}))
            unicornAnimation.animations = animations
        }
    }

    onUnicornColorChanged: function() {
        var hue = unicornColor.hsvHue
        var saturation = unicornColor.hsvSaturation
        var value = unicornColor.hsvValue

        var newValues = {}
        var groupNames = presetsController.groupNames
        for(var i in groupNames) {
            var groupColor = Qt.hsva((hue + i / 6) % 1, saturation, value, 0)
            // convert #AARRGGBB to RRGGBBAA
            newValues[groupNames[i]] = groupColor.toString().replace(/#(..)(......)/, '$2$1')
        }
        lightsController.setValues(newValues)
    }
}