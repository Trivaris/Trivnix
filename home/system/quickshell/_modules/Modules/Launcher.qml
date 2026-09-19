import QtQuick
import Quickshell

Item {
    id: root
    property var scheme

    implicitWidth: launcherText.implicitWidth
    implicitHeight: launcherText.implicitHeight

    Text {
        id: launcherText
        anchors.centerIn: parent
        text: ""
        font.pixelSize: 30
        font.family: "JetBrains Mono Nerd Font"
        color: mouseArea.containsMouse ? scheme.base0D : scheme.base0C
        scale: mouseArea.pressed ? 0.92 : 1.0
        verticalAlignment: Text.AlignVCenter

        Behavior on color {
            ColorAnimation { duration: 120 }
        }

        Behavior on scale {
            NumberAnimation { duration: 80; easing.type: Easing.OutQuad }
        }
    }

    MouseArea {
        id: mouseArea
        anchors {
            fill: parent
            topMargin: -8
            bottomMargin: -8
            leftMargin: -6
            rightMargin: -6
        }
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked: mouse => {
            if (mouse.button === Qt.LeftButton) {
                Quickshell.execDetached(["rofi", "-show", "drun"])
            } else if (mouse.button === Qt.RightButton) {
                Quickshell.execDetached(["killall", "-9", "rofi"])
            }
        }
    }
}