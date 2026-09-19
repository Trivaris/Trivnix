import QtQuick
import Quickshell
import Quickshell.Io

Row {
    spacing: 5
    property var scheme

    Process { id: shutdownCmd; command: ["systemctl", "poweroff"] }
    Process { id: rebootCmd; command: ["systemctl", "reboot"] }

    Rectangle {
        width: 30
        height: 30
        radius: 4
        color: shutdownArea.containsMouse ? scheme.base02 : "transparent"

        Text {
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -1
            text: "󰐥"
            color: scheme.base08 
            font.pixelSize: 22
        }

        MouseArea {
            id: shutdownArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: shutdownCmd.running = true
        }
    }

    Rectangle {
        width: 30
        height: 30
        radius: 4
        color: rebootArea.containsMouse ? scheme.base02 : "transparent"

        Text {
            anchors.centerIn: parent
            text: ""
            color: scheme.base0A 
            font.pixelSize: 20
        }

        MouseArea {
            id: rebootArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: rebootCmd.running = true
        }
    }
}