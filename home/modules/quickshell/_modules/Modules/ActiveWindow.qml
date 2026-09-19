import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

RowLayout {
    id: root
    property var scheme
    spacing: 6

    property string appName: "Desktop"

    Connections {
        target: Hyprland
        function onRawEvent(event) {
            const eventName = event.name 
            
            if (eventName === "activewindow" || eventName === "activewindowv2" || eventName === "closewindow" || eventName === "workspace" || eventName === "focusedmon") {
                activeWinProc.running = true
            }
        }
    }

    Process {
        id: activeWinProc
        running: true
        command: ["hyprctl", "activewindow", "-j"]
        stdout: StdioCollector {
            onStreamFinished: {
                const raw = this.text.trim()
                
                if (!raw || raw === "{}") {
                    root.appName = "Desktop"
                    return
                }

                try {
                    const win = JSON.parse(raw)
                    const appClass = win.class || win.initialClass || ""

                    if (appClass.length > 0) {
                        root.appName = appClass.charAt(0).toUpperCase() + appClass.slice(1)
                    } else {
                        root.appName = "Desktop"
                    }
                } catch (e) {
                    root.appName = "Desktop"
                }
            }
        }
    }

    Text {
        text: root.appName
        color: root.appName === "Desktop" ? scheme.base03 : scheme.base05
        opacity: root.appName === "Desktop" ? 0.45 : 0.85
        font.italic: root.appName === "Desktop"
        font.pixelSize: 14
        font.weight: Font.DemiBold
        font.family: "JetBrains Mono Nerd Font"
        elide: Text.ElideRight
        Layout.maximumWidth: 180
        Layout.alignment: Qt.AlignVCenter

        Behavior on opacity { NumberAnimation { duration: 150 } }
        Behavior on color { ColorAnimation { duration: 150 } }
    }
}