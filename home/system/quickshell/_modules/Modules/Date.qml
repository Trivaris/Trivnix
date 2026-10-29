import QtQuick
import QtQuick.Layouts
import Quickshell

ColumnLayout {
    id: root

    property var scheme
    spacing: -2

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    // Short Day of the Week (e.g. THU)
    Text {
        Layout.alignment: Qt.AlignHCenter
        color: root.scheme.base0C
        font.pixelSize: 14
        font.weight: Font.Bold
        font.family: "JetBrains Mono Nerd Font"
        text: Qt.formatDateTime(clock.date, "ddd").toUpperCase()
    }

    // Day & Month (e.g. 29/10)
    Text {
        Layout.alignment: Qt.AlignHCenter
        color: root.scheme.base05
        font.pixelSize: 12
        font.weight: Font.Medium
        font.family: "JetBrains Mono Nerd Font"
        text: Qt.formatDateTime(clock.date, "dd/MM")
    }
}