//@ pragma UseQApplication
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

ShellRoot {
    Instantiator {
        model: Quickshell.screens

        delegate: Bar {
            screen: modelData
            isActiveMonitor: Hyprland.focusedMonitor?.name === modelData.name
        }
    }

    Lock { id: screenLock }

    // qs ipc call lock lock
    IpcHandler {
        target: "lock"

        function lock(): void { screenLock.lock() }
    }
}