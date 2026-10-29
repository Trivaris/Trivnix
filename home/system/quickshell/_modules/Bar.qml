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
        anchors { fill: parent; leftMargin: 10; rightMargin: 10; bottomMargin: -radius; }
        border { width: 2; color: scheme.base03 }
        color: scheme.base01
        radius: 8

        // --- LEFT SECTION ---
        RowLayout {
            id: modulesLeft
            spacing: 35
            anchors {
                left: parent.left
                top: parent.top
                bottom: parent.bottom
                leftMargin: 20
                topMargin: 4
                bottomMargin: parent.radius
            }

            opacity: root.isActiveMonitor ? 1 : 0
            visible: opacity > 0
            Behavior on opacity { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }

            Launcher     { scheme: root.scheme; Layout.fillHeight: true }
            PowerMenu    { scheme: root.scheme; Layout.fillHeight: true }
            Bluetooth    { scheme: root.scheme; Layout.fillHeight: true }
            Weather      { scheme: root.scheme; Layout.fillHeight: true }
            ActiveWindow { scheme: root.scheme; Layout.fillHeight: true }
            TrayBar      { scheme: root.scheme; Layout.fillHeight: true }
        }


        // --- CENTER SECTION ---
        RowLayout {
            id: modulesCenter
            spacing: 5
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: parent.top
                bottom: parent.bottom
                topMargin: 8
                bottomMargin: parent.radius
            }

            Workspaces { 
                scheme: root.scheme
                wsIconOverrides: root.wsIconOverrides
                monitorName: root.screen.name 
                monitorsMap: root.monitors
                Layout.fillHeight: true
            }
        }


        // --- RIGHT SECTION ---
        RowLayout {
            id: modulesRight
            spacing: 35
            anchors {
                right: parent.right
                top: parent.top
                bottom: parent.bottom
                rightMargin: 20
                topMargin: 4
                bottomMargin: parent.radius
            }

            opacity: root.isActiveMonitor ? 1 : 0
            visible: opacity > 0
            Behavior on opacity { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }

            Media       { scheme: root.scheme; Layout.fillHeight: true }
            Volume      { scheme: root.scheme; Layout.fillHeight: true }
            Resources   { scheme: root.scheme; Layout.fillHeight: true }
            Network     { scheme: root.scheme; Layout.fillHeight: true }
            Clock       { scheme: root.scheme; Layout.fillHeight: true }
            Date        { scheme: root.scheme; Layout.fillHeight: true }
        }
    }
}
