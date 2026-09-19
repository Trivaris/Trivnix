import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtCore
import "Modules"

PanelWindow {
    id: root
    
    function loadJson(filename: string): string {
        var xhr = new XMLHttpRequest();
        var configDir = StandardPaths.standardLocations(StandardPaths.ConfigLocation)[0];
        xhr.open("GET", `${configDir}/quickshell/${filename}`, false);
        xhr.send();
        return xhr.responseText;
    }

    property bool isActiveMonitor
    property var scheme: JSON.parse(loadJson("scheme.json"))
    property var monitors: JSON.parse(loadJson("monitors.json"))
    property var wsIconOverrides: JSON.parse(loadJson("wsIconOverrides.json"))

    anchors { left: true; right: true; bottom: true }
    implicitHeight: 50
    color: "transparent"

    // Base background styling
    Rectangle {
        anchors { fill: parent; leftMargin: 10; rightMargin: 10; bottomMargin: -2*border.width }
        border { width: 2; color: scheme.base03 }
        color: scheme.base01
        radius: 8

        // --- LEFT SECTION ---
        Row {
            id: modulesLeft
            anchors { left: parent.left; top: parent.top; bottom: parent.bottom; leftMargin: 20; topMargin: 8; bottomMargin: 12 }
            spacing: 35

            opacity: root.isActiveMonitor ? 1 : 0
            visible: opacity > 0
            Behavior on opacity { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }

            Launcher     { scheme: root.scheme; anchors.verticalCenter: parent.verticalCenter }
            PowerMenu    { scheme: root.scheme; anchors.verticalCenter: parent.verticalCenter }
            Bluetooth    { scheme: root.scheme; anchors.verticalCenter: parent.verticalCenter }
            Weather      { scheme: root.scheme; anchors.verticalCenter: parent.verticalCenter }
            ActiveWindow { scheme: root.scheme; anchors.verticalCenter: parent.verticalCenter }
        }

        // --- CENTER SECTION ---
        Row {
            id: modulesCenter
            anchors.centerIn: parent
            spacing: 5

            Workspaces { 
                scheme: root.scheme
                wsIconOverrides: root.wsIconOverrides
                monitorName: root.screen.name 
                monitorsMap: root.monitors
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        // --- RIGHT SECTION ---
        Row {
            id: modulesRight
            anchors { right: parent.right; top: parent.top; bottom: parent.bottom; rightMargin: 20; topMargin: 8; bottomMargin: 12 }
            spacing: 35

            opacity: root.isActiveMonitor ? 1 : 0
            visible: opacity > 0
            Behavior on opacity { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }

            Media       { scheme: root.scheme; anchors.verticalCenter: parent.verticalCenter }
            Volume      { scheme: root.scheme; anchors.verticalCenter: parent.verticalCenter }
            Resources   { scheme: root.scheme; anchors.verticalCenter: parent.verticalCenter }
            Network     { scheme: root.scheme; anchors.verticalCenter: parent.verticalCenter }
            Clock       { scheme: root.scheme; anchors.verticalCenter: parent.verticalCenter }
        }
    }
}