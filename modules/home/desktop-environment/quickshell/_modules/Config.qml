pragma Singleton

import Quickshell
import QtQuick
import QtCore

Singleton {
    function loadJson(filename: string): string {
        var xhr = new XMLHttpRequest();
        var configDir = StandardPaths.standardLocations(StandardPaths.ConfigLocation)[0];
        xhr.open("GET", `${configDir}/quickshell/${filename}`, false);
        xhr.send();
        return xhr.responseText;
    }

    readonly property var scheme: JSON.parse(loadJson("scheme.json"))
    readonly property var monitors: JSON.parse(loadJson("monitors.json"))
    readonly property var wsIconOverrides: JSON.parse(loadJson("wsIconOverrides.json"))
}
