import QtQuick 2.15
import QtQuick.Controls 2.15

import "PixelBar" as PB

Column {
    id: block
    spacing: 15

    property var sensor
    property var name

    property var items:  Array()
    property var itemValues

    PB.Label
    {
        text: "Access"
    }

    Row {
        spacing: 20

        PB.Button {
            id: frontDoor
            text: "Front door"
            checkable: true
            autoResetInterval: 2000
            onCheckedChanged: {
                if (app != null)
                    app.controllers.GPIO.emit({"loadingdoor": checked})
            }
        }

        PB.Button {
            text: "Pixelbar door"
            checkable: true
            autoResetInterval: 2000
            onCheckedChanged: {
                if (app != null)
                    app.controllers.GPIO.emit({"pixeldoor": checked})
            }
        }
    }
}