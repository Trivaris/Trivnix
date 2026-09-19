import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Item {
    id: root
    property var scheme

    implicitWidth: layout.implicitWidth
    implicitHeight: layout.implicitHeight

    property real volumeLevel: 0.0 // 0.0 to 1.0
    property bool isMuted: false

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: volProc.running = true
    }

    // Reads default sink volume and mute state via wpctl
    Process {
        id: volProc
        command: ["sh", "-c", "wpctl get-volume @DEFAULT_AUDIO_SINK@"]
        stdout: StdioCollector {
            onStreamFinished: {
                const raw = this.text.trim()
                if (!raw) return

                root.isMuted = raw.includes("[MUTED]")
                const match = raw.match(/Volume:\s+([0-9.]+)/)
                if (match && match[1]) {
                    root.volumeLevel = Math.max(0.0, Math.min(1.0, parseFloat(match[1])))
                }
            }
        }
    }

    RowLayout {
        id: layout
        spacing: 6
        anchors.centerIn: parent

        // Dynamic Volume Glyph
        Text {
            id: volIcon
            Layout.alignment: Qt.AlignVCenter
            font.pixelSize: 14
            font.family: "JetBrains Mono Nerd Font"
            color: root.isMuted ? scheme.base03 : scheme.base0A

            text: {
                if (root.isMuted) return "󰝟"
                if (root.volumeLevel === 0.0) return "󰕿"
                if (root.volumeLevel < 0.5) return "󰖀"
                return "󰕾"
            }

            Behavior on color {
                ColorAnimation { duration: 150 }
            }
        }

        // Vertical Meter Track (matches CPU/RAM gauge dimensions)
        Rectangle {
            width: 6
            height: 26
            radius: 3
            color: scheme.base02
            clip: true
            Layout.alignment: Qt.AlignVCenter

            Rectangle {
                anchors.bottom: parent.bottom
                width: parent.width
                height: parent.height * root.volumeLevel
                radius: 3
                color: root.isMuted ? scheme.base03 : scheme.base0A

                Behavior on height {
                    NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
                }
                Behavior on color {
                    ColorAnimation { duration: 150 }
                }
            }
        }

        // Percentage Readout
        Text {
            Layout.alignment: Qt.AlignVCenter
            text: root.isMuted ? "MUT" : root.volumeLevel == 1 ? "MAX" : `${Math.round(root.volumeLevel * 100)}`
            color: root.isMuted ? scheme.base03 : scheme.base05
            font.pixelSize: 12
            font.weight: Font.DemiBold
            font.family: "JetBrains Mono Nerd Font"

            Behavior on color {
                ColorAnimation { duration: 150 }
            }
        }
    }

    MouseArea {
        anchors {
            fill: parent
            topMargin: -6
            bottomMargin: -6
            leftMargin: -4
            rightMargin: -4
        }
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.MiddleButton

        onClicked: mouse => {
            if (mouse.button === Qt.MiddleButton) {
                Quickshell.execDetached(["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"])
                root.isMuted = !root.isMuted
            } else if (mouse.button === Qt.LeftButton) {
                Quickshell.execDetached(["pwvucontrol"])
            }
        }

        onWheel: wheel => {
            if (wheel.angleDelta.y > 0) {
                Quickshell.execDetached(["wpctl", "set-volume", "-l", "1.0", "@DEFAULT_AUDIO_SINK@", "5%+"])
                root.volumeLevel = Math.min(1.0, root.volumeLevel + 0.05)
                root.isMuted = false
            } else if (wheel.angleDelta.y < 0) {
                Quickshell.execDetached(["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "5%-"])
                root.volumeLevel = Math.max(0.0, root.volumeLevel - 0.05)
            }
        }
    }
}