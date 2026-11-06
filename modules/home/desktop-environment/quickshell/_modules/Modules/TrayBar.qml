import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray

RowLayout {
    id: trayBar
    property var scheme
    spacing: 5

    Repeater {
        model: SystemTray.items
        delegate: TrayIcon {
            scheme: trayBar.scheme
        }
    }
}
