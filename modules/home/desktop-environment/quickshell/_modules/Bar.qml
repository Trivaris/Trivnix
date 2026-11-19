import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtCore
import "Modules"

PanelWindow {
    id: root

    property bool isActiveMonitor
    property var scheme: Config.scheme
    property var monitors: Config.monitors
    property var wsIconOverrides: Config.wsIconOverrides

    property bool autoHide: true
    property int collapsedHeight: 12
    readonly property bool expanded: !autoHide || hover.hovered || collapseDelay.running
    property real reveal: expanded ? 1 : 0
    Behavior on reveal { NumberAnimation { duration: 250; easing.type: Easing.OutCubic } }

    property real monitorFade: isActiveMonitor ? 1 : 0
    Behavior on monitorFade { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }

    anchors { left: true; right: true; bottom: true }
    implicitHeight: 50
    color: "transparent"

    exclusiveZone: autoHide ? collapsedHeight : implicitHeight
    mask: Region { item: background }

    Timer { id: collapseDelay; interval: 350 }

    HoverHandler {
        id: hover
        onHoveredChanged: if (!hovered) collapseDelay.restart()
    }

    Rectangle {
        id: background
        y: (1 - root.reveal) * (root.height - root.collapsedHeight)
        anchors {
            left: parent.left
            right: parent.right
            leftMargin: 10
            rightMargin: 10
        }
        height: parent.height + radius
        border { width: 2; color: scheme.base03 }
        color: Qt.alpha(scheme.base01, 0.5)
        radius: 8
    }

    // --- LEFT SECTION ---
    RowLayout {
        id: modulesLeft
        spacing: 35
        anchors {
            left: background.left
            top: background.top
            bottom: background.bottom
            leftMargin: 20
            topMargin: 4
            bottomMargin: background.radius
        }

        opacity: root.monitorFade * root.reveal
        visible: opacity > 0

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
            horizontalCenter: background.horizontalCenter
            top: background.top
            topMargin: 4
        }

        Workspaces {
            id: workspaces
            scheme: root.scheme
            wsIconOverrides: root.wsIconOverrides
            monitorName: root.screen.name
            monitorsMap: root.monitors
            expansionProgress: root.reveal
        }
    }

    // --- RIGHT SECTION ---
    RowLayout {
        id: modulesRight
        spacing: 35
        anchors {
            right: background.right
            top: background.top
            bottom: background.bottom
            rightMargin: 20
            topMargin: 4
            bottomMargin: background.radius
        }

        opacity: root.monitorFade * root.reveal
        visible: opacity > 0

        Media       { scheme: root.scheme; Layout.fillHeight: true }
        Volume      { scheme: root.scheme; Layout.fillHeight: true }
        Resources   { scheme: root.scheme; Layout.fillHeight: true }
        Network     { scheme: root.scheme; Layout.fillHeight: true }
        Clock       { scheme: root.scheme; Layout.fillHeight: true }
        Date        { scheme: root.scheme; Layout.fillHeight: true }
    }
}