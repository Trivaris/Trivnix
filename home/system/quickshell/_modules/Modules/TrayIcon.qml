import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray

Rectangle {
    id: root

    property var scheme

    Layout.preferredWidth: 24
    Layout.preferredHeight: 24
    color: scheme ? scheme.base01 : "transparent"
    radius: 4

    Image {
        source: modelData.icon
        anchors.fill: parent
        anchors.margins: 2
        fillMode: Image.PreserveAspectFit
    }

    // Connects the opaque QsMenuHandle to your compositor's popup system
    QsMenuAnchor {
        id: menuAnchor
        menu: modelData.menu
        anchor.item: root
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked: mouse => {
            if (mouse.button === Qt.LeftButton) {
                modelData.activate();
            } else if (mouse.button === Qt.RightButton) {
                if (modelData.hasMenu && modelData.menu) {
                    menuAnchor.open();
                } else {
                    modelData.secondaryActivate();
                }
            }
        }
    }
}