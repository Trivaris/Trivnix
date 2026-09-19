import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Item {
    id: root
    property var scheme

    implicitWidth: layout.implicitWidth
    implicitHeight: layout.implicitHeight

    property real cpuLoad: 0.0 // 0.0 to 1.0
    property real memLoad: 0.0 // 0.0 to 1.0

    property var prevIdle: 0
    property var prevTotal: 0

    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            cpuProc.running = true
            memProc.running = true
        }
    }

    // Direct /proc/stat reader for CPU
    Process {
        id: cpuProc
        command: ["head", "-n1", "/proc/stat"]
        stdout: StdioCollector {
            onStreamFinished: {
                const parts = this.text.trim().split(/\s+/).slice(1).map(Number)
                if (parts.length < 4) return

                const idle = parts[3] + (parts[4] || 0)
                const total = parts.reduce((acc, v) => acc + v, 0)

                if (root.prevTotal > 0) {
                    const deltaTotal = total - root.prevTotal
                    const deltaIdle = idle - root.prevIdle
                    if (deltaTotal > 0) {
                        root.cpuLoad = Math.max(0.0, Math.min(1.0, (deltaTotal - deltaIdle) / deltaTotal))
                    }
                }
                root.prevIdle = idle
                root.prevTotal = total
            }
        }
    }

    // Direct /proc/meminfo reader for Memory
    Process {
        id: memProc
        command: ["head", "-n3", "/proc/meminfo"]
        stdout: StdioCollector {
            onStreamFinished: {
                const lines = this.text.trim().split("\n")
                let total = 0, available = 0
                for (let i = 0; i < lines.length; i++) {
                    const parts = lines[i].split(/\s+/)
                    if (parts[0] === "MemTotal:") total = parseInt(parts[1], 10)
                    else if (parts[0] === "MemAvailable:") available = parseInt(parts[1], 10)
                }
                if (total > 0 && available > 0) {
                    root.memLoad = Math.max(0.0, Math.min(1.0, (total - available) / total))
                }
            }
        }
    }

    RowLayout {
        id: layout
        spacing: 8
        anchors.centerIn: parent

        // Scaled Vertical Pill Indicators
        Row {
            spacing: 4
            Layout.alignment: Qt.AlignVCenter

            // CPU Bar Track
            Rectangle {
                width: 6
                height: 26
                radius: 3
                color: scheme.base02
                clip: true

                Rectangle {
                    anchors.bottom: parent.bottom
                    width: parent.width
                    height: parent.height * root.cpuLoad
                    radius: 3
                    color: root.cpuLoad > 0.85 ? scheme.base08 : scheme.base0D

                    Behavior on height {
                        NumberAnimation { duration: 350; easing.type: Easing.OutCubic }
                    }
                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }
                }
            }

            // RAM Bar Track
            Rectangle {
                width: 6
                height: 26
                radius: 3
                color: scheme.base02
                clip: true

                Rectangle {
                    anchors.bottom: parent.bottom
                    width: parent.width
                    height: parent.height * root.memLoad
                    radius: 3
                    color: root.memLoad > 0.85 ? scheme.base08 : scheme.base0E

                    Behavior on height {
                        NumberAnimation { duration: 350; easing.type: Easing.OutCubic }
                    }
                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }
                }
            }
        }

        // Scaled Stacked Readout
        ColumnLayout {
            spacing: -3
            Layout.alignment: Qt.AlignVCenter

            Text {
                text: `${Math.round(root.cpuLoad * 100)}`
                color: root.cpuLoad > 0.85 ? scheme.base08 : scheme.base0D
                font.pixelSize: 12
                font.weight: Font.Bold
                font.family: "JetBrains Mono Nerd Font"
            }

            Text {
                text: `${Math.round(root.memLoad * 100)}`
                color: root.memLoad > 0.85 ? scheme.base08 : scheme.base0E
                font.pixelSize: 12
                font.weight: Font.DemiBold
                font.family: "JetBrains Mono Nerd Font"
            }
        }
    }
}