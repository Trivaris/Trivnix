import Quickshell
import QtQuick

PanelWindow {
    anchors {
        top: true
        right: true
        bottom: true
    }

    implicitHeight: 30

    Text {
        anchors.centerIn: parent
        text: "Hello!"
    }
}