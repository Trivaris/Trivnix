import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root
    property var scheme

    implicitWidth: btText.implicitWidth
    implicitHeight: btText.implicitHeight

    property bool isPowered: false
    property bool isConnected: false

    Timer {
        interval: 3000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: btStatusProc.running = true
    }

    Process {
        id: btStatusProc
        command: ["sh", "-c", "bluetoothctl show | grep -q 'Powered: yes' && (bluetoothctl devices Connected | grep -q 'Device' && echo 'connected' || echo 'on') || echo 'off'"]

        stdout: StdioCollector {
            onStreamFinished: {
                const state = this.text.trim()
                root.isPowered = (state === "on" || state === "connected")
                root.isConnected = (state === "connected")
            }
        }
    }

    Text {
        id: btText
        anchors.centerIn: parent

        // Context glyphs: Off (󰂲), Idle (), Connected (󰂱)
        text: !root.isPowered ? "󰂲" : (root.isConnected ? "󰂱" : "")
        color: !root.isPowered ? scheme.base03 : (root.isConnected ? scheme.base0B : scheme.base0D)
        font.pixelSize: 20
        font.family: "JetBrains Mono Nerd Font"
        font.weight: Font.Bold
        verticalAlignment: Text.AlignVCenter

        Behavior on color {
            ColorAnimation { duration: 150 }
        }
    }

    MouseArea {
        anchors {
            fill: parent
            topMargin: -5
            bottomMargin: -5
            leftMargin: -10
            rightMargin: -10
        }
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked: mouse => {
            if (mouse.button === Qt.LeftButton) {
                Quickshell.execDetached(["overskride"])
            } else if (mouse.button === Qt.RightButton) {
                const nextState = root.isPowered ? "off" : "on"
                Quickshell.execDetached(["bluetoothctl", "power", nextState])
                root.isPowered = !root.isPowered
                if (!root.isPowered) root.isConnected = false
            }
        }
    }
}