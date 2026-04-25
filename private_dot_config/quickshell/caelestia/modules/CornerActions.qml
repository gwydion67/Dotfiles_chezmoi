pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Caelestia.Config
import qs.components
import qs.services
import qs.utils

Scope {
    id: root

    Variants {
        model: Screens.screens

        Scope {
            id: screenScope
            required property ShellScreen modelData

            Corner { 
                screen: modelData; anchorTop: true; anchorLeft: true; 
                action: CornerSettings.topLeftAction; delay: CornerSettings.topLeftDelay 
            }
            Corner { 
                screen: modelData; anchorTop: true; anchorRight: true; 
                action: CornerSettings.topRightAction; delay: CornerSettings.topRightDelay 
            }
            Corner { 
                screen: modelData; anchorBottom: true; anchorLeft: true; 
                action: CornerSettings.bottomLeftAction; delay: CornerSettings.bottomLeftDelay 
            }
            Corner { 
                screen: modelData; anchorBottom: true; anchorRight: true; 
                action: CornerSettings.bottomRightAction; delay: CornerSettings.bottomRightDelay 
            }
        }
    }

    component Corner: PanelWindow {
        id: cornerWin
        required property ShellScreen screen
        property bool anchorTop: false
        property bool anchorBottom: false
        property bool anchorLeft: false
        property bool anchorRight: false
        property string action
        property int delay

        implicitWidth: 40
        implicitHeight: 40
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.namespace: "caelestia-corner-actions"
        WlrLayershell.exclusionMode: ExclusionMode.Ignore
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

        anchors.top: anchorTop
        anchors.bottom: anchorBottom
        anchors.left: anchorLeft
        anchors.right: anchorRight

        color: "transparent"

        // Global cursor tracking to survive window focus/layer shifts
        property real globalMouseX: 0
        property real globalMouseY: 0
        
        Process {
            id: cursorProc
            command: ["hyprctl", "cursorpos", "-j"]
            stdout: StdioCollector {
                onStreamFinished: {
                    try {
                        const pos = JSON.parse(text);
                        cornerWin.globalMouseX = pos.x;
                        cornerWin.globalMouseY = pos.y;
                    } catch (e) {}
                }
            }
        }

        Timer {
            id: trackTimer
            interval: 50 // 20fps tracking is enough for smooth proximity
            repeat: true
            running: !!cornerWin.action // Only track if there's an action to show feedback for
            onTriggered: cursorProc.running = true
        }

        readonly property real maxTrackDist: 150
        readonly property real currentDist: {
            if (!cornerWin.action) return maxTrackDist;
            const dx = Math.abs(globalMouseX - (anchorLeft ? screen.x : screen.x + screen.width));
            const dy = Math.abs(globalMouseY - (anchorTop ? screen.y : screen.y + screen.height));
            
            // Only track if within the logical area of THIS screen
            if (dx > 300 || dy > 300) return maxTrackDist;
            
            return Math.sqrt(dx*dx + dy*dy);
        }

        readonly property bool inTriggerArea: {
            const dx = Math.abs(globalMouseX - (anchorLeft ? screen.x : screen.x + screen.width));
            const dy = Math.abs(globalMouseY - (anchorTop ? screen.y : screen.y + screen.height));
            return dx < 10 && dy < 10;
        }

        onInTriggerAreaChanged: {
            if (inTriggerArea && cornerWin.action) {
                triggerTimer.interval = cornerWin.delay || 250;
                triggerTimer.start();
            } else {
                triggerTimer.stop();
            }
        }

        mask: Region {
            Region {
                x: anchorLeft ? 0 : cornerWin.width - 300
                y: anchorTop ? 0 : cornerWin.height - 300
                width: 300
                height: 300
            }
        }

        Item {
            id: glowContainer
            anchors.fill: parent
            
            property real factor: Math.max(0, 1.0 - (cornerWin.currentDist / cornerWin.maxTrackDist))
            readonly property real smoothFactor: factor * factor
            
            opacity: 0.6 * smoothFactor
            scale: smoothFactor
            
            transformOrigin: {
                if (anchorTop && anchorLeft) return Item.TopLeft;
                if (anchorTop && anchorRight) return Item.TopRight;
                if (anchorBottom && anchorLeft) return Item.BottomLeft;
                if (anchorBottom && anchorRight) return Item.BottomRight;
                return Item.Center;
            }
            
            Behavior on factor { Anim { type: Anim.StandardSmall } }

            layer.enabled: true
            layer.effect: MultiEffect {
                blurEnabled: true
                blur: 1.0
                blurMax: 80
            }

            Rectangle {
                width: 60
                height: 60
                radius: 30
                
                x: anchorLeft ? -radius : cornerWin.width - radius
                y: anchorTop ? -radius : cornerWin.height - radius
                
                color: Colours.tPalette.m3primary
            }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            // MouseArea is now only used for the trigger timer if needed, 
            // but we mostly rely on global tracking now.
            // We keep it to prevent clicks from passing through if desired.
            hoverEnabled: true

            Timer {
                id: triggerTimer
                onTriggered: {
                    root.executeAction(cornerWin.screen, cornerWin.action);
                }
            }
        }

    }

    function executeAction(screen, action) {
        if (!action) return;
        
        const monitor = Hypr.monitorFor(screen);
        const vis = Visibilities.screens.get(monitor);
        if (!vis) {
            console.warn("CornerActions: No visibilities found for screen", screen.name);
            return;
        }

        console.log("CornerActions: Executing", action, "on", screen.name);

        if (action === "dashboard") vis.dashboard = !vis.dashboard;
        else if (action === "launcher") vis.launcher = !vis.launcher;
        else if (action === "session") vis.session = !vis.session;
        else if (action === "sidebar") vis.sidebar = !vis.sidebar;
        else if (action === "utilities") vis.utilities = !vis.utilities;
        else if (action === "osd") vis.osd = !vis.osd;
        else if (action === "overview") Quickshell.execDetached(["quickshell", "-i", "overview", "toggle"]);
        else if (action.startsWith("command:")) {
            const cmd = action.substring(8).trim().split(" ");
            Quickshell.execDetached(cmd);
        }
    }
}
