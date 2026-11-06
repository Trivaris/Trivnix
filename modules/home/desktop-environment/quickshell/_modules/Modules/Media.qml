import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Mpris

MouseArea {
    property var scheme
    
    property var activePlayer: {
        const players = Mpris.players.values
        for (let i = 0; i < players.length; i++) {
            if (!players[i].dbusName.includes("firefox")) {
                return players[i]
            }
        }
        return null
    }
    
    property int playState: activePlayer ? activePlayer.playbackState : MprisPlaybackState.Stopped
    property bool hasMedia: activePlayer && playState !== MprisPlaybackState.Stopped

    implicitWidth: layout.implicitWidth
    implicitHeight: layout.implicitHeight
    cursorShape: Qt.PointingHandCursor
    
    onClicked: {
        if (activePlayer) activePlayer.togglePlaying()
    }

    RowLayout {
        id: layout
        anchors.fill: parent
        spacing: 8
        
        // Image {
        //     visible: hasMedia && activePlayer.trackArtUrl !== ""
        //     source: hasMedia ? (activePlayer.trackArtUrl || "") : ""
        //     Layout.preferredWidth: 32
        //     Layout.preferredHeight: 32
        //     fillMode: Image.PreserveAspectCrop
        //     
        //     Rectangle {
        //         anchors.fill: parent
        //         color: "transparent"
        //         border.color: scheme.base03
        //         border.width: 1
        //     }
        // }

        Text {
            color: scheme.base08
            Layout.alignment: Qt.AlignVCenter
            text: !hasMedia ? "" : (playState === MprisPlaybackState.Playing ? "" : "")
        }

        Text {
            visible: hasMedia
            color: scheme.base05 
            font.bold: true
            text: activePlayer ? (activePlayer.trackTitle || "Unknown") : ""
            elide: Text.ElideRight
            Layout.maximumWidth: 150 
            Layout.alignment: Qt.AlignVCenter
        }

        Text {
            visible: hasMedia
            color: scheme.base05
            opacity: 0.6 
            text: activePlayer ? (activePlayer.trackArtist || "Unknown") : ""
            elide: Text.ElideRight
            Layout.maximumWidth: 120
            Layout.alignment: Qt.AlignVCenter
        }

        Text {
            visible: !hasMedia
            color: scheme.base05
            opacity: 0.6
            text: "Nothing Playing"
            Layout.alignment: Qt.AlignVCenter
        }
    }
}