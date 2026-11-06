import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import QtCore

RowLayout {
    id: root

    property string script: `${Quickshell.env("HOME")}/.config/quickshell/weather.sh`

    spacing: 10
    property var scheme
    property string weatherIcon: ""
    property string weatherTemp: "--°"

    Timer {
        interval: 900000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: weatherProc.running = true
    }

    Process {
        id: weatherProc
        command: ["sh", script || "echo '{\"icon\": \"󰖐\", \"temp\": \"18°C\"}'"]
        
        stdout: StdioCollector {
            onStreamFinished: {
                const raw = this.text.trim()
                if (!raw) return
                
                try {
                    const data = JSON.parse(raw)
                    if (data.icon) weatherIcon = data.icon
                    if (data.temp) weatherTemp = data.temp
                    else if (data.text) {
                        const parts = data.text.trim().split(/\s+/)
                        weatherIcon = parts[0] || ""
                        weatherTemp = parts.slice(1).join(" ") || "--°"
                    }
                } catch(e) {
                    console.warn("Weather parse error:", e)
                }
            }
        }
    }

    Text {
        color: scheme.base09
        Layout.alignment: Qt.AlignVCenter
        font.pixelSize: 18
        font.family: "JetBrains Mono Nerd Font"
        text: weatherIcon
    }

    Text {
        color: scheme.base05
        Layout.alignment: Qt.AlignVCenter
        opacity: 0.6
        font.pixelSize: 14
        font.weight: Font.DemiBold
        font.family: "JetBrains Mono Nerd Font"
        elide: Text.ElideRight
        text: weatherTemp
    }
}