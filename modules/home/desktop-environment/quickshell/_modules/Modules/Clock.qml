import QtQuick
import QtQuick.Layouts
import Quickshell

ColumnLayout {
    property var scheme
    spacing: -4

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    Text {
        Layout.alignment: Qt.AlignHCenter
        color: scheme.base0B
        font.pixelSize: 18
        font.weight: Font.Bold
        font.family: "JetBrains Mono Nerd Font"
        text: String(clock.hours).padStart(2, "0")
    }

    Text {
        Layout.alignment: Qt.AlignHCenter
        color: scheme.base05
        font.pixelSize: 16
        font.weight: Font.DemiBold
        font.family: "JetBrains Mono Nerd Font"
        text: String(clock.minutes).padStart(2, "0")
    }
}
