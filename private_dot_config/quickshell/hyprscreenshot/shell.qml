// ┌─────────────────────────────────────────────────────────────────────────┐
// │  hyprscreenshot — QuickShell wrapper for hyprshot                       │
// │  Place at:  ~/.config/quickshell/hyprscreenshot/shell.qml               │
// │  Autostart: exec-once = qs -c hyprscreenshot                            │
// │  Toggle:    qs ipc -c hyprscreenshot call hyprscreenshot toggle         │
// └─────────────────────────────────────────────────────────────────────────┘

import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ShellRoot {
    id: root

    // ── State ──────────────────────────────────────────────────────────────
    property string selectedMode: "region"
    property int selectedDelay: 0
    property bool isCapturing: false
    property int countdown: 0

    // ── Colors — Dynamically reads Caelestia's scheme.json ─────────────────
    property color accentColor: "#82aaff"
    property color accentText: "#000000"
    property color bgColor: "#1e1e2e"
    property color cardColor: "#181825"
    property color textColor: "#cdd6f4"

    // Dynamic derived colors
    property color mutedColor: Qt.rgba(textColor.r, textColor.g, textColor.b, 0.50)
    readonly property color dangerColor: Qt.rgba(0.95, 0.34, 0.41, 1.0)
    property color accentFaint: Qt.rgba(accentColor.r, accentColor.g, accentColor.b, 0.13)
    property color accentMed: Qt.rgba(accentColor.r, accentColor.g, accentColor.b, 0.22)
    property color accentBorder: Qt.rgba(accentColor.r, accentColor.g, accentColor.b, 0.50)
    readonly property color rimLight: Qt.rgba(1, 1, 1, 0.06)
    property color surfaceHover: Qt.rgba(textColor.r, textColor.g, textColor.b, 0.05)

    // Parses Caelestia's Material You colors safely
    // Parses Caelestia's Material You colors safely
    // ── Colors loader (FIXED, non-breaking) ────────────────────────────────
    property string schemePath: ((Quickshell.env("XDG_STATE_HOME") ? Quickshell.env("XDG_STATE_HOME") : ((Quickshell.env("HOME") || "") + "/.local/state")) + "/caelestia/scheme.json")

    function normalizeHex(value, fallback) {
        if (typeof value !== "string" || value.length === 0)
            return fallback;
        return value.startsWith("#") ? value : ("#" + value);
    }

    property int themeVersion: 0

    function applyTheme(raw) {
        var text = (raw || "").toString().trim();
        console.log("[DEBUG - Colors] Loaded JSON length:", text.length);

        if (text.length === 0) {
            console.log("[ERROR - Colors] Empty or missing file:", root.schemePath);
            return;
        }

        try {
            var json = JSON.parse(text);
            var c = json.colours || json.colors || json;

            if (c.primary)
                root.accentColor = normalizeHex(c.primary, root.accentColor.toString());

            if (c.onPrimary)
                root.accentText = normalizeHex(c.onPrimary, root.accentText.toString());

            if (c.background)
                root.bgColor = normalizeHex(c.background, root.bgColor.toString());

            if (c.surfaceContainerHigh)
                root.cardColor = normalizeHex(c.surfaceContainerHigh, root.cardColor.toString());
            else if (c.surface)
                root.cardColor = normalizeHex(c.surface, root.cardColor.toString());

            if (c.onBackground)
                root.textColor = normalizeHex(c.onBackground, root.textColor.toString());

            // recompute derived colors (IMPORTANT)
            root.mutedColor = Qt.rgba(root.textColor.r, root.textColor.g, root.textColor.b, 0.50);
            root.accentFaint = Qt.rgba(root.accentColor.r, root.accentColor.g, root.accentColor.b, 0.13);
            root.accentMed = Qt.rgba(root.accentColor.r, root.accentColor.g, root.accentColor.b, 0.22);
            root.accentBorder = Qt.rgba(root.accentColor.r, root.accentColor.g, root.accentColor.b, 0.50);
            root.surfaceHover = Qt.rgba(root.textColor.r, root.textColor.g, root.textColor.b, 0.05);

            console.log("[SUCCESS - Colors] Theme applied!");
        } catch (e) {
            console.log("[ERROR - Colors] JSON parse failed:", e.message);
        }

        root.themeVersion++;
    }

    // Replace your FileView block with this:
    Timer {
        id: reloadDebounce
        interval: 150
        repeat: false
        onTriggered: schemeFile.reload()
    }

    FileView {
        id: schemeFile
        path: root.schemePath
        blockLoading: true
        watchChanges: true

        onLoaded: root.applyTheme(text())
        onFileChanged: reloadDebounce.restart()  // debounce instead of instant reload
        onLoadFailed: function (err) {
            console.log("[ERROR - Colors] Load failed:", err);
        }
    }

    Component.onCompleted: schemeFile.reload()

    // ── Processes ──────────────────────────────────────────────────────────
    Process {
        id: captureProc
        onRunningChanged: {
            if (!running) {
                root.isCapturing = false;
            }
        }
    }

    // ── Countdown → hide → capture chain ──────────────────────────────────
    Timer {
        id: countdownTimer
        interval: 1000
        repeat: true
        onTriggered: {
            root.countdown--;
            if (root.countdown <= 0) {
                stop();
                mainWindow.visible = false;
                freezeDelay.start();
            }
        }
    }

    Timer {
        id: freezeDelay
        interval: 380
        repeat: false
        onTriggered: runHyprshot()
    }

    function startCapture() {
        root.isCapturing = true;
        if (root.selectedDelay === 0) {
            mainWindow.visible = false;
            freezeDelay.start();
        } else {
            root.countdown = root.selectedDelay;
            countdownTimer.start();
        }
    }

    function cancelCapture() {
        countdownTimer.stop();
        root.isCapturing = false;
        root.countdown = 0;
    }

    function runHyprshot() {
        var cmd = "hyprshot -m " + root.selectedMode + " --freeze --raw | swappy -f -";
        captureProc.command = ["bash", "-c", cmd];
        captureProc.running = true;
    }

    // ── IPC ────────────────────────────────────────────────────────────────
    IpcHandler {
        target: "hyprscreenshot"
        function toggle() {
            if (!mainWindow.visible)
                schemeFile.reload();
            mainWindow.visible = !mainWindow.visible;
        }
        function open() {
            schemeFile.reload();
            mainWindow.visible = true;
        }
        function close() {
            if (root.isCapturing)
                root.cancelCapture();
            mainWindow.visible = false;
        }
    }

    // ── Window ─────────────────────────────────────────────────────────────
    FloatingWindow {
        id: mainWindow
        visible: false

        implicitWidth: 420
        implicitHeight: root.isCapturing ? 230 : 420

        color: "transparent"
        onVisibleChanged: {
            if (visible)
                schemeFile.reload();
        }

        Rectangle {
            id: card
            property int _forceUpdate: root.themeVersion

            anchors.fill: parent
            radius: 14
            color: root.bgColor
            border.color: root.rimLight
            border.width: 1
            clip: true
            Rectangle {
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                }
                height: 1
                color: root.rimLight
            }

            ColumnLayout {
                anchors {
                    fill: parent
                    margins: 20
                }
                spacing: 0

                // ── Header ──────────────────────────────────────────────
                RowLayout {
                    Layout.fillWidth: true
                    Layout.bottomMargin: 18
                    spacing: 10

                    Rectangle {
                        Layout.preferredWidth: 32
                        Layout.preferredHeight: 32
                        radius: 8
                        color: root.accentFaint
                        border.color: root.accentBorder
                        border.width: 1
                        Text {
                            anchors.centerIn: parent
                            text: "⊙"
                            color: root.accentColor
                            font.pixelSize: 15
                        }
                    }

                    Column {
                        spacing: 1
                        Text {
                            text: "Screenshot"
                            color: root.textColor
                            font.pixelSize: 15
                            font.weight: Font.Medium
                        }
                        Text {
                            text: "hyprshot · swappy"
                            color: root.mutedColor
                            font.pixelSize: 10
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    Rectangle {
                        Layout.preferredWidth: 26
                        Layout.preferredHeight: 26
                        radius: 6
                        color: xHov.containsMouse ? Qt.rgba(root.dangerColor.r, root.dangerColor.g, root.dangerColor.b, 0.18) : "transparent"
                        Behavior on color {
                            ColorAnimation {
                                duration: 100
                            }
                        }
                        Text {
                            anchors.centerIn: parent
                            text: "✕"
                            color: xHov.containsMouse ? root.dangerColor : root.mutedColor
                            font.pixelSize: 11
                        }
                        HoverHandler {
                            id: xHov
                        }
                        TapHandler {
                            onTapped: mainWindow.visible = false
                        }
                    }
                }

                // ── Content Area Wrapper ─────────────────────────────────
                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    // ── Setup UI ─────────────────────────────────────────
                    ColumnLayout {
                        anchors.fill: parent
                        visible: !root.isCapturing
                        spacing: 0

                        Text {
                            Layout.fillWidth: true
                            Layout.bottomMargin: 8
                            text: "CAPTURE MODE"
                            color: root.mutedColor
                            font.pixelSize: 10
                            font.weight: Font.Medium
                            font.letterSpacing: 1.5
                        }

                        GridLayout {
                            Layout.fillWidth: true
                            Layout.bottomMargin: 16
                            columns: 2
                            columnSpacing: 8
                            rowSpacing: 8

                            Repeater {
                                model: [
                                    {
                                        key: "region",
                                        label: "Region",
                                        sub: "drag to select",
                                        span: 2
                                    },
                                    {
                                        key: "window",
                                        label: "Window",
                                        sub: "click a window",
                                        span: 1
                                    },
                                    {
                                        key: "output",
                                        label: "Full Screen",
                                        sub: "whole display",
                                        span: 1
                                    },
                                ]

                                delegate: Rectangle {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 58
                                    Layout.columnSpan: modelData.span
                                    radius: 9

                                    property bool sel: root.selectedMode === modelData.key

                                    color: sel ? root.accentMed : (mHov.containsMouse ? root.surfaceHover : root.cardColor)
                                    border.color: sel ? root.accentBorder : "transparent"
                                    border.width: 1
                                    Behavior on color {
                                        ColorAnimation {
                                            duration: 110
                                        }
                                    }

                                    Column {
                                        anchors.centerIn: parent
                                        spacing: 3
                                        Text {
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            text: modelData.label
                                            color: sel ? root.accentColor : root.textColor
                                            font.pixelSize: 13
                                            font.weight: sel ? Font.Medium : Font.Normal
                                            Behavior on color {
                                                ColorAnimation {
                                                    duration: 110
                                                }
                                            }
                                        }
                                        Text {
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            text: modelData.sub
                                            color: root.mutedColor
                                            font.pixelSize: 10
                                        }
                                    }

                                    HoverHandler {
                                        id: mHov
                                    }
                                    TapHandler {
                                        onTapped: root.selectedMode = modelData.key
                                    }
                                }
                            }
                        }

                        Text {
                            Layout.fillWidth: true
                            Layout.bottomMargin: 8
                            text: "DELAY"
                            color: root.mutedColor
                            font.pixelSize: 10
                            font.weight: Font.Medium
                            font.letterSpacing: 1.5
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 8

                            Rectangle {
                                Layout.preferredWidth: 36
                                Layout.preferredHeight: 36
                                radius: 8
                                color: minHov.containsMouse ? root.surfaceHover : root.cardColor
                                Behavior on color {
                                    ColorAnimation {
                                        duration: 100
                                    }
                                }
                                Text {
                                    anchors.centerIn: parent
                                    text: "−"
                                    color: root.selectedDelay > 0 ? root.textColor : root.mutedColor
                                    font.pixelSize: 20
                                }
                                HoverHandler {
                                    id: minHov
                                }
                                TapHandler {
                                    onTapped: if (root.selectedDelay > 0)
                                        root.selectedDelay--
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 36
                                radius: 8
                                color: delayInput.activeFocus ? root.accentFaint : root.cardColor
                                border.color: delayInput.activeFocus ? root.accentBorder : "transparent"
                                border.width: 1
                                Behavior on color {
                                    ColorAnimation {
                                        duration: 100
                                    }
                                }
                                Behavior on border.color {
                                    ColorAnimation {
                                        duration: 100
                                    }
                                }

                                Row {
                                    anchors.centerIn: parent
                                    spacing: 4

                                    TextInput {
                                        id: delayInput
                                        text: root.selectedDelay.toString()
                                        color: root.textColor
                                        font.pixelSize: 14
                                        font.weight: Font.Medium
                                        width: 28
                                        horizontalAlignment: TextInput.AlignHCenter
                                        selectByMouse: true
                                        validator: IntValidator {
                                            bottom: 0
                                            top: 999
                                        }

                                        onEditingFinished: {
                                            var v = parseInt(text);
                                            root.selectedDelay = isNaN(v) ? 0 : v;
                                            text = root.selectedDelay.toString();
                                        }
                                        onTextChanged: {
                                            var v = parseInt(text);
                                            if (!isNaN(v) && v >= 0)
                                                root.selectedDelay = v;
                                        }
                                        Connections {
                                            target: root
                                            function onSelectedDelayChanged() {
                                                if (!delayInput.activeFocus)
                                                    delayInput.text = root.selectedDelay.toString();
                                            }
                                        }
                                    }

                                    Text {
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: "sec"
                                        color: root.mutedColor
                                        font.pixelSize: 11
                                    }
                                }
                            }

                            Rectangle {
                                Layout.preferredWidth: 36
                                Layout.preferredHeight: 36
                                radius: 8
                                color: plusHov.containsMouse ? root.surfaceHover : root.cardColor
                                Behavior on color {
                                    ColorAnimation {
                                        duration: 100
                                    }
                                }
                                Text {
                                    anchors.centerIn: parent
                                    text: "+"
                                    color: root.textColor
                                    font.pixelSize: 20
                                }
                                HoverHandler {
                                    id: plusHov
                                }
                                TapHandler {
                                    onTapped: root.selectedDelay++
                                }
                            }
                        }

                        Item {
                            Layout.fillHeight: true
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 44
                            radius: 10

                            color: capHov.containsMouse ? Qt.darker(root.accentColor, 1.08) : root.accentColor
                            Behavior on color {
                                ColorAnimation {
                                    duration: 110
                                }
                            }

                            scale: capHov.containsMouse ? 0.975 : 1.0
                            Behavior on scale {
                                NumberAnimation {
                                    duration: 90
                                    easing.type: Easing.OutQuad
                                }
                            }

                            Text {
                                anchors.centerIn: parent
                                text: root.selectedDelay > 0 ? "Capture in " + root.selectedDelay + "s" : "Capture Now"
                                color: root.accentText
                                font.pixelSize: 14
                                font.weight: Font.Medium
                            }

                            HoverHandler {
                                id: capHov
                            }
                            TapHandler {
                                onTapped: root.startCapture()
                            }
                        }
                    }

                    // ── Countdown UI ───────────────────────────────────────
                    ColumnLayout {
                        anchors.fill: parent
                        visible: root.isCapturing
                        spacing: 10

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 130
                            radius: 12
                            color: root.accentFaint
                            border.color: root.accentBorder
                            border.width: 1

                            Column {
                                anchors.centerIn: parent
                                spacing: 6
                                Text {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    text: root.countdown > 0 ? root.countdown.toString() : "…"
                                    color: root.accentColor
                                    font.pixelSize: 48
                                    font.weight: Font.Bold
                                }
                                Text {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    text: root.countdown > 0 ? "capturing in " + root.countdown + (root.countdown === 1 ? " second" : " seconds") : "capturing…"
                                    color: root.mutedColor
                                    font.pixelSize: 12
                                }
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 36
                            radius: 8
                            visible: root.countdown > 0
                            color: cxHov.containsMouse ? Qt.rgba(root.dangerColor.r, root.dangerColor.g, root.dangerColor.b, 0.18) : root.cardColor
                            border.color: Qt.rgba(root.dangerColor.r, root.dangerColor.g, root.dangerColor.b, 0.35)
                            border.width: 1
                            Behavior on color {
                                ColorAnimation {
                                    duration: 100
                                }
                            }
                            Text {
                                anchors.centerIn: parent
                                text: "Cancel"
                                color: root.dangerColor
                                font.pixelSize: 13
                            }
                            HoverHandler {
                                id: cxHov
                            }
                            TapHandler {
                                onTapped: root.cancelCapture()
                            }
                        }

                        Item {
                            Layout.fillHeight: true
                        }
                    }
                }
            } // End ColumnLayout

            Keys.onEscapePressed: {
                if (root.isCapturing)
                    root.cancelCapture();
                else
                    mainWindow.visible = false;
            }
            focus: true
        } // Rectangle card
    }   // FloatingWindow
} // ShellRoot
