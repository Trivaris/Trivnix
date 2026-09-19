import QtQuick
import Quickshell
import Quickshell.Hyprland

Item {
    id: wsRoot
    property var scheme
    property var wsIconOverrides
    property var monitorsMap: ({})
    property string monitorName: ""
    property string isActiveMonitor

    property int workspaceIndex: (monitorsMap && monitorName && monitorsMap[monitorName]) 
        ? (monitorsMap[monitorName].workspaceIndex || 0) : 0

    property var persistentIds: [
        1 + (workspaceIndex * 10),
        2 + (workspaceIndex * 10),
        3 + (workspaceIndex * 10),
        4 + (workspaceIndex * 10),
        5 + (workspaceIndex * 10)
    ]

    implicitWidth: wsRow.implicitWidth
    implicitHeight: wsRow.implicitHeight

    function getWsData(wsId: int): var {
        var workspace = Hyprland.workspaces.values.find(it => it.id === wsId)
        if (typeof workspace === "undefined") {
            return { text: "", color: scheme.base03 }
        }

        var windows = Hyprland.toplevels.values.filter(it => it.workspace?.id === wsId)
        if (windows.length < 1) {
            return { text: "", color: scheme.base05 }
        }

        const override = wsIconOverrides.find(override => {
            var window = windows.find(window => {
                var className = window.lastIpcObject.class || window.title.toLowerCase()
                var cleanRegex = new RegExp(override.regex.replace(/^\/|\/$/g, ''))
                var found = className.match(cleanRegex)
                return found != null
            })
            return typeof window !== "undefined"
        })

        if (typeof override !== "undefined") return { text: override.text, color: override.color }
        else return { text: "", color: scheme.base05 }
    }

    function getMonitorActiveId() {
        if (!Hyprland || !Hyprland.monitors) return -1;
        const m = Hyprland.monitors.values.find(m => m.name === monitorName);
        return m && m.activeWorkspace ? m.activeWorkspace.id : -1;
    }

    Row {
        id: wsRow
        spacing: 6

        Repeater {
            model: wsRoot.persistentIds

            Rectangle {
                id: wsButton
                width: 35
                height: 35
                radius: 4

                property int    wsId: modelData
                property var    wsData: wsRoot.getWsData(wsId)
                property bool   isActive: wsRoot.getMonitorActiveId() === wsId
                property string displayedText: wsData.text
                property string displayedColorStr: wsData.color 
                property color  displayedColor: displayedColorStr

                onWsDataChanged: if (wsData.text !== displayedText || wsData.color !== displayedColorStr) iconAnim.restart()
                color: {
                    if (mouseArea.containsMouse && isActive) return "rgba(255, 255, 255, 0.12)"
                    if (mouseArea.containsMouse) return "rgba(255, 255, 255, 0.08)"
                    return "transparent"
                }
                Behavior on color { ColorAnimation { duration: 250; easing.type: Easing.OutCubic } }

                Text {
                    id: iconText
                    anchors.centerIn: parent
                    text: wsButton.displayedText
                    color: wsButton.displayedColor
                    font.pixelSize: 25
                    font.family: "JetBrains Mono Nerd Font"
                    
                    Behavior on color { ColorAnimation { duration: 250; easing.type: Easing.OutCubic } }
                }

                SequentialAnimation {
                    id: iconAnim
                    NumberAnimation { target: iconText; property: "scale"; to: 0.2; duration: 120; easing.type: Easing.InCubic }
                    ScriptAction {
                        script: {
                            wsButton.displayedText = wsButton.wsData.text
                            wsButton.displayedColorStr = wsButton.wsData.color
                        }
                    }
                    NumberAnimation { target: iconText; property: "scale"; to: 1.0; duration: 180; easing.type: Easing.OutBack }
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor

                    onClicked: Hyprland.dispatch(`hl.dsp.focus({ workspace = "${wsButton.wsId}" })`)
                    onWheel: wheel => {
                        if (wheel.angleDelta.y > 0) Hyprland.dispatch("hl.dsp.focus({ workspace = 'm+1' })")
                        else Hyprland.dispatch("hl.dsp.focus({ workspace = 'm-1' })")
                    }
                }
            }
        }
    }

    Rectangle {
        id: activeSlider

        property int activeId:    wsRoot.getMonitorActiveId()
        property int activeIndex: wsRoot.persistentIds.indexOf(activeId)
        property var activeWsData: activeIndex >= 0 ? wsRoot.getWsData(wsRoot.persistentIds[activeIndex]) : null

        visible: activeIndex >= 0
        color: activeWsData ? activeWsData.color : "transparent"
        x: activeIndex >= 0 ? activeIndex * (35 + wsRow.spacing) : 0
        width: 35
        height: 3
        radius: 2
        anchors.bottom: wsRow.bottom
        anchors.bottomMargin: -2

        Behavior on x     { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }
        Behavior on color { ColorAnimation { duration: 300; easing.type: Easing.OutCubic } }
    }
}