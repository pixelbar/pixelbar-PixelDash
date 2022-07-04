import QtQuick
import QtQuick.Controls

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