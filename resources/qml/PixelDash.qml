import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts  1.15

import "PixelBar" as PB

ApplicationWindow {
    id: window
    visible: true
    visibility: app != null ? (app.debug ? "AutomaticVisibility" : "FullScreen") : "AutomaticVisibility"
    width: 1920
    height: 1080

    background: Rectangle {
        color: "black"
    }

    Header {
        id: header
    }

    LightsController {
        id: lightsController

        anchors.left: parent.left
        anchors.top: header.bottom
        anchors.margins: 25
    }

    Column {
        id: sideWidgets

        anchors.left: lightsController.right
        anchors.right: parent.right
        anchors.top: header.bottom
        anchors.margins: 25
        anchors.leftMargin: 75

        spacing: 75

        DoorController {}

        ClimateBlock {}
    }

    SensorBlock {
        id: rpiBlock
        anchors.left: parent.left
        anchors.top: lightsController.bottom
        anchors.margins: 25
        width: Math.floor((lightsController.width + 75) / 2) - 25

        sensor: (app != null) ? app.sensors.RPI : null
    }

    SensorBlock {
        id: ikeaBlock
        anchors.left: rpiBlock.right
        anchors.top: lightsController.bottom
        anchors.margins: 25
        width: Math.floor((lightsController.width + 75) / 2) - 25

        sensor: (app != null) ? app.sensors.IKEA : null
    }

    SensorBlock {
        anchors.left: ikeaBlock.right
        anchors.top: lightsController.bottom
        anchors.margins: 25

        sensor: (app != null) ? app.sensors.Weather : null
    }

}