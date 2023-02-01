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

    Item {
        id: sideWidgets

        anchors.left: lightsController.right
        anchors.right: parent.right
        anchors.top: header.bottom
        anchors.bottom: parent.bottom
        anchors.margins: 25
        anchors.leftMargin: 75

        DoorController {
            id: doorController
            anchors.left: parent.left
            anchors.top: parent.top
        }

        ScrollView {
            width: parent.width
            contentWidth: -1

            anchors.top: doorController.bottom
            anchors.topMargin: 50
            anchors.bottom: parent.bottom

            ScrollBar.vertical.policy: ScrollBar.AlwaysOn
            clip: true

            Column {
                spacing: 50
                height: childrenRect.height

                ClimateBlock {
                    id: climateBlock
                }

                SensorBlock {
                    sensor: (app != null) ? app.sensors.Tasmota2 : null
                    width: climateBlock.width
                }

                SensorBlock {
                    sensor: (app != null) ? app.sensors.IKEA : null
                    width: climateBlock.width
                }
            }
        }
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
        id: wetaherBlock
        anchors.left: rpiBlock.right
        anchors.top: lightsController.bottom
        anchors.margins: 25
        width: Math.floor((lightsController.width + 75) / 2) - 25

        sensor: (app != null) ? app.sensors.Weather : null
    }

}
