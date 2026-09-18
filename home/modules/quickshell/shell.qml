import Quickshell
import QtQuick
import QtCore

FloatingWindow {
    property var scheme: loadConfig()
    visible: true
    width: 200
    height: 100

    function loadConfig() {
        var xhr = new XMLHttpRequest();
        var configDir = StandardPaths.standardLocations(StandardPaths.ConfigLocation)[0];
        xhr.open("GET", `${configDir}/quickshell/theme.json`, false);
        xhr.send();
        return JSON.parse(xhr.responseText);
    }

    Text {
        anchors.centerIn: parent
        color: scheme.base08
        text: `Config Path: ${StandardPaths.standardLocations(StandardPaths.ConfigLocation)[0]}/quickshell/theme.json`
        font.pixelSize: 18
    }
}