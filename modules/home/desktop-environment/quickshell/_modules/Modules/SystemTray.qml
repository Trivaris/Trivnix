import QtQuick
import Quickshell
import Quickshell.Services.SystemTray

Row {
    spacing: 8

    Repeater {
        model: SystemTray.items

        delegate: Image {
            width: 18
            height: 18
            source: modelData.icon
            
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
            }
        }
    }
}