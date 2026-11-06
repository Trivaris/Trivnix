import QtQuick
import Quickshell
import Quickshell.Hyprland 

Instantiator {
    model: Quickshell.screens

    delegate: Bar {
        screen: modelData
        isActiveMonitor: Hyprland.focusedMonitor?.name === modelData.name
    }
}