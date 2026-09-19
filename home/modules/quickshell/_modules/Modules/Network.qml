import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Item {
    id: root
    property var scheme

    implicitWidth: layout.implicitWidth
    implicitHeight: layout.implicitHeight

    // Connection state: "disconnected", "ethernet", "wifi"
    property string netType: "disconnected"
    property string netLabel: "Offline"
    property real signalStrength: 0.0 // 0.0 to 1.0 (for Wi-Fi)

    Timer {
        interval: 4000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: netProc.running = true
    }

    // Direct interface check via ip route and /proc/net/wireless
    Process {
        id: netProc
        command: ["sh", "-c", "ip route get 1.1.1.1 2>/dev/null | awk '{print $5; exit}'"]
        stdout: StdioCollector {
            onStreamFinished: {
                const iface = this.text.trim()
                if (!iface) {
                    root.netType = "disconnected"
                    root.netLabel = "Offline"
                    root.signalStrength = 0.0
                    return
                }

                if (iface.startsWith("wl")) {
                    root.netType = "wifi"
                    wifiDetailProc.command = ["sh", "-c", `awk -v dev="${iface}:" '$1 == dev {print int($3)}' /proc/net/wireless`]
                    wifiDetailProc.running = true
                } else {
                    root.netType = "ethernet"
                    root.netLabel = "ETH"
                    root.signalStrength = 1.0
                }
            }
        }
    }

    Process {
        id: wifiDetailProc
        stdout: StdioCollector {
            onStreamFinished: {
                const rawQuality = parseInt(this.text.trim(), 10)
                if (!isNaN(rawQuality) && rawQuality > 0) {
                    // /proc/net/wireless link quality is typically scaled out of 70
                    root.signalStrength = Math.max(0.0, Math.min(1.0, rawQuality / 70.0))
                    root.netLabel = `${Math.round(root.signalStrength * 100)}%`
                } else {
                    root.signalStrength = 0.5
                    root.netLabel = "WLAN"
                }
            }
        }
    }

    RowLayout {
        id: layout
        spacing: 6
        anchors.centerIn: parent

        // Dynamic Network Glyph
        Text {
            Layout.alignment: Qt.AlignVCenter
            font.pixelSize: 15
            font.family: "JetBrains Mono Nerd Font"
            color: root.netType === "disconnected" ? scheme.base03 : scheme.base0B

            text: {
                if (root.netType === "disconnected") return "󰤭"
                if (root.netType === "ethernet") return "󰈀"
                
                // Wi-Fi signal glyph levels
                if (root.signalStrength > 0.75) return "󰤨"
                if (root.signalStrength > 0.50) return "󰤥"
                if (root.signalStrength > 0.25) return "󰤢"
                return "󰤟"
            }

            Behavior on color {
                ColorAnimation { duration: 150 }
            }
        }

        // Vertical Signal / Link Meter (matches 6x26px pill gauge profile)
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
                height: parent.height * (root.netType === "disconnected" ? 0.0 : root.signalStrength)
                radius: 3
                color: root.netType === "disconnected" ? scheme.base03 : scheme.base0B

                Behavior on height {
                    NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
                }
                Behavior on color {
                    ColorAnimation { duration: 150 }
                }
            }
        }

        // Label Readout
        Text {
            Layout.alignment: Qt.AlignVCenter
            text: root.netLabel
            color: root.netType === "disconnected" ? scheme.base03 : scheme.base05
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
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked: mouse => {
            if (mouse.button === Qt.LeftButton) {
                Quickshell.execDetached(["nm-connection-editor"])
            } else if (mouse.button === Qt.RightButton) {
                Quickshell.execDetached(["nmgui"])
            }
        }
    }
}