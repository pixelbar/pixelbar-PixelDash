import QtQuick 2.15
import QtQuick.Controls 2.15

Label
{
    font.family: "Arial"
    font.pointSize: 40
    opacity: enabled ? 1.0 : 0.3
    color: "lime"
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    elide: Text.ElideRight
}