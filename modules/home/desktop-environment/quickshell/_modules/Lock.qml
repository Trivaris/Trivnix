import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Pam
import QtQuick.Effects

// Lock screen: the bar rises from the bottom edge and pushes the desktop
// out of the top of the screen, then becomes the lock screen itself.
Scope {
    id: root

    property var scheme: Config.scheme

    // 0 = desktop fully visible, 1 = lock panel covers the screen
    property real progress: 0
    property string password: ""
    property string message: ""
    property bool unlocking: false
    property string fingerprintState: "idle"
    property bool passwordAuthRequested: false
    readonly property bool busy: pam.active || fingerprintPam.active
    readonly property bool fingerprintBusy: fingerprintPam.active

    function lock(): void {
        if (sessionLock.locked) return;
        password = "";
        message = "";
        unlocking = false;
        fingerprintState = "idle";
        passwordAuthRequested = false;
        progress = 0;
        sessionLock.locked = true;
        startFingerprint();
        revealFallback.restart();
    }

    // Start pushing the desktop out, once there is a picture of it to push.
    function reveal(): void {
        if (!sessionLock.locked || unlocking || slideIn.running || progress > 0) return;
        revealFallback.stop();
        slideIn.start();
    }

    function submit(): void {
        if (password === "" || pam.active || unlocking) return;
        passwordAuthRequested = true;
        fingerprintRetry.stop();
        fingerprintState = "idle";
        if (fingerprintPam.active) fingerprintPam.abort();
        message = "";
        if (!pam.start()) {
            passwordAuthRequested = false;
            message = "Could not start authentication";
        }
    }

    function startFingerprint(): void {
        if (pam.active || fingerprintPam.active || unlocking) return;
        message = "";
        fingerprintState = "reading";
        if (!fingerprintPam.start()) {
            fingerprintState = "rejected";
            message = "Fingerprint authentication unavailable";
            fingerprintReset.restart();
            fingerprintRetry.restart();
        }
    }

    function completeAuthentication(result, fingerprint): void {
        if (fingerprint && passwordAuthRequested) return;
        if (!fingerprint) passwordAuthRequested = false;
        if (result === PamResult.Success) {
            password = "";
            if (fingerprint) {
                fingerprintState = "accepted";
                fingerprintRetry.stop();
            }
            unlocking = true;
            slideIn.stop();
            slideOut.start();
        } else {
            if (fingerprint) {
                fingerprintState = "rejected";
                password = "";
                fingerprintShake.restart();
                fingerprintReset.restart();
                fingerprintRetry.restart();
            } else {
                message = result === PamResult.MaxTries ? "Too many attempts" : "Authentication failed";
            }
        }
    }

    // Don't wait forever for the screen capture.
    Timer { id: revealFallback; interval: 250; onTriggered: root.reveal() }
    Timer {
        id: fingerprintReset
        interval: 1200
        onTriggered: root.fingerprintState = "idle"
    }
    Timer {
        id: fingerprintRetry
        interval: 1300
        onTriggered: root.startFingerprint()
    }

    SequentialAnimation {
        id: fingerprintShake
        NumberAnimation { target: fingerprintReader; property: "shakeOffset"; to: -8; duration: 55; easing.type: Easing.OutQuad }
        NumberAnimation { target: fingerprintReader; property: "shakeOffset"; to: 8; duration: 55; easing.type: Easing.InOutQuad }
        NumberAnimation { target: fingerprintReader; property: "shakeOffset"; to: -5; duration: 55; easing.type: Easing.InOutQuad }
        NumberAnimation { target: fingerprintReader; property: "shakeOffset"; to: 0; duration: 55; easing.type: Easing.OutQuad }
    }

    NumberAnimation {
        id: slideIn
        target: root; property: "progress"
        to: 1; duration: 450; easing.type: Easing.InOutCubic
    }

    SequentialAnimation {
        id: slideOut
        NumberAnimation {
            target: root; property: "progress"
            to: 0; duration: 400; easing.type: Easing.InOutCubic
        }
        ScriptAction {
            script: {
                sessionLock.locked = false;
                root.unlocking = false;
            }
        }
    }

    PamContext {
        id: pam
        config: "quickshell"

        onPamMessage: {
            if (!responseRequired) return;
            respond(responseVisible ? root.password : "");
        }
        onError: {
            root.passwordAuthRequested = false;
            root.message = "Authentication error";
        }
        onCompleted: result => root.completeAuthentication(result, false)
    }

    PamContext {
        id: fingerprintPam
        config: "quickshell-fingerprint"

        onActiveChanged: {
            if (!active && root.fingerprintState === "reading" && !root.unlocking) {
                root.fingerprintState = "rejected";
                fingerprintShake.restart();
                fingerprintReset.restart();
                fingerprintRetry.restart();
            }
        }
        onPamMessage: {
            if (messageIsError) {
                root.fingerprintState = "rejected";
                fingerprintShake.restart();
                fingerprintReset.restart();
            }
        }
        onError: {
            root.fingerprintState = "rejected";
            root.message = "Fingerprint authentication error";
            fingerprintShake.restart();
            fingerprintReset.restart();
            fingerprintRetry.restart();
        }
        onCompleted: result => root.completeAuthentication(result, true)
    }

    WlSessionLock {
        id: sessionLock

        WlSessionLockSurface {
            id: surface
            color: root.scheme.base00

            SystemClock { id: clock; precision: SystemClock.Minutes }

            // Picture of the desktop as it was when the lock started.
            Item {
                id: desktopLayer
                width: parent.width
                height: parent.height
                y: -root.progress * height
                visible: root.progress < 1

                ScreencopyView {
                    id: desktopCapture
                    anchors.fill: parent
                    captureSource: surface.screen
                    live: false
                    onHasContentChanged: if (hasContent) root.reveal()
                }

                MultiEffect {
                    anchors.fill: parent
                    source: desktopCapture
                    blurEnabled: true
                    blur: 1
                    blurMax: 32
                }
            }

            Rectangle {
                id: panel
                readonly property real inset: 10 * (1 - root.progress)

                x: inset
                y: parent.height * (1 - root.progress)
                width: parent.width - 2 * inset
                height: parent.height + radius
                border { width: 2; color: root.scheme.base03 }
                color: root.scheme.base01
                radius: 8

                Column {
                    anchors.horizontalCenter: parent.horizontalCenter
                    y: (surface.height - height) / 2
                    spacing: 14

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: root.scheme.base0B
                        font { pixelSize: 110; weight: Font.Bold; family: "JetBrains Mono Nerd Font" }
                        text: Qt.formatTime(clock.date, "HH:mm")
                    }

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: root.scheme.base05
                        font { pixelSize: 22; weight: Font.DemiBold; family: "JetBrains Mono Nerd Font" }
                        text: Qt.formatDate(clock.date, "dddd, d MMMM")
                    }

                    Item { width: 1; height: 30 }

                    Rectangle {
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 340
                        height: 46
                        radius: 8
                        color: root.scheme.base00
                        border {
                            width: 2
                            color: root.message !== "" ? root.scheme.base08
                                 : root.busy ? root.scheme.base0A
                                 : root.scheme.base0D
                        }
                        Behavior on border.color { ColorAnimation { duration: 200 } }

                        Text {
                            anchors.centerIn: parent
                            visible: input.text === ""
                            color: root.scheme.base03
                            font { pixelSize: 16; family: "JetBrains Mono Nerd Font" }
                            text: Quickshell.env("USER") ?? ""
                        }

                        TextInput {
                            id: input
                            anchors { fill: parent; leftMargin: 14; rightMargin: 14 }
                            verticalAlignment: TextInput.AlignVCenter
                            horizontalAlignment: TextInput.AlignHCenter
                            clip: true
                            focus: true
                            readOnly: pam.active || root.unlocking
                            echoMode: TextInput.Password
                            passwordCharacter: "●"
                            inputMethodHints: Qt.ImhSensitiveData | Qt.ImhNoPredictiveText
                            color: root.scheme.base05
                            font { pixelSize: 16; family: "JetBrains Mono Nerd Font" }

                            Component.onCompleted: forceActiveFocus()
                            onTextChanged: root.password = text
                            onAccepted: root.submit()
                            Keys.onEscapePressed: root.password = ""

                            // Keep every monitor's field in sync.
                            Connections {
                                target: root
                                function onPasswordChanged() {
                                    if (input.text !== root.password) input.text = root.password;
                                }
                            }
                        }
                    }

                    Item {
                        id: fingerprintReader
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 34
                        height: 34
                        property real shakeOffset: 0

                        Text {
                            id: fingerprintIcon
                            x: (parent.width - width) / 2 + parent.shakeOffset
                            y: (parent.height - height) / 2
                            width: 30
                            height: 30
                            property color iconColor: {
                                if (root.fingerprintState === "reading") return root.scheme.base0A;
                                if (root.fingerprintState === "rejected") return root.scheme.base08;
                                if (root.fingerprintState === "accepted") return root.scheme.base0B;
                                return root.scheme.base0D;
                            }
                            color: iconColor
                            text: "󰈷"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font { pixelSize: 28; family: "JetBrainsMono Nerd Font Mono" }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: root.startFingerprint()
                            }
                        }
                    }
                }
            }
        }
    }
}
