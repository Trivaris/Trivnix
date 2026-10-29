import QtQuick
import QtQuick.Layouts
import Quickshell

PopupWindow {
    id: root

    property var scheme
    property var menuHandle

    visible: false

    Rectangle {
        id: menuCard
        implicitWidth: 180
        implicitHeight: menuColumn.implicitHeight + 12
        color: root.scheme ? root.scheme.base00 : "#1e1e2e"
        border.color: root.scheme ? root.scheme.base02 : "#313244"
        border.width: 1
        radius: 8

        ColumnLayout {
            id: menuColumn
            anchors.fill: parent
            anchors.margins: 6
            spacing: 2

            Repeater {
                model: root.menuHandle ? root.menuHandle.items : []

                delegate: Rectangle {
                    id: menuItem
                    Layout.fillWidth: true
                    Layout.preferredHeight: modelData.isSeparator ? 1 : 28
                    radius: 4

                    color: modelData.isSeparator
                        ? (root.scheme ? root.scheme.base02 : "#313244")
                        : (itemMouse.containsMouse ? (root.scheme ? root.scheme.base02 : "#45475a") : "transparent")

                    Text {
                        visible: !modelData.isSeparator
                        anchors.fill: parent
                        anchors.leftMargin: 8
                        anchors.rightMargin: 8
                        verticalAlignment: Text.AlignVCenter
                        text: modelData.text.replace(/&/g, "")
                        color: modelData.enabled
                            ? (root.scheme ? root.scheme.base05 : "#cdd6f4")
                            : (root.scheme ? root.scheme.base03 : "#6c7086")
                        font.family: "JetBrains Mono, monospace"
                        font.pixelSize: 12
                        elide: Text.ElideRight
                    }

                    MouseArea {
                        id: itemMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        enabled: !modelData.isSeparator && modelData.enabled
                        cursorShape: Qt.PointingHandCursor

                        onClicked: {
                            modelData.trigger();
                            root.visible = false;
                        }
                    }
                }
            }
        }
    }
}