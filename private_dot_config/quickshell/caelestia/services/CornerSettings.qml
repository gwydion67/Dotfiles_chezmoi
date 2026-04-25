pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import qs.utils

Singleton {
    id: root

    property string topLeftAction: ""
    property int topLeftDelay: 250

    property string topRightAction: ""
    property int topRightDelay: 250

    property string bottomLeftAction: ""
    property int bottomLeftDelay: 250

    property string bottomRightAction: ""
    property int bottomRightDelay: 250

    function save(): void {
        const data = {
            topLeftAction: root.topLeftAction,
            topLeftDelay: root.topLeftDelay,
            topRightAction: root.topRightAction,
            topRightDelay: root.topRightDelay,
            bottomLeftAction: root.bottomLeftAction,
            bottomLeftDelay: root.bottomLeftDelay,
            bottomRightAction: root.bottomRightAction,
            bottomRightDelay: root.bottomRightDelay
        };
        storage.setText(JSON.stringify(data));
        console.log("CornerSettings: Saved configuration");
    }

    FileView {
        id: storage
        path: Paths.state + "/corners.json"
        onLoaded: {
            try {
                const data = JSON.parse(text());
                root.topLeftAction = data.topLeftAction || "";
                root.topLeftDelay = data.topLeftDelay || 250;
                root.topRightAction = data.topRightAction || "";
                root.topRightDelay = data.topRightDelay || 250;
                root.bottomLeftAction = data.bottomLeftAction || "";
                root.bottomLeftDelay = data.bottomLeftDelay || 250;
                root.bottomRightAction = data.bottomRightAction || "";
                root.bottomRightDelay = data.bottomRightDelay || 250;
                console.log("CornerSettings: Loaded configuration from corners.json");
            } catch (e) {
                console.warn("CornerSettings: Failed to parse corners.json", e);
            }
        }
        onLoadFailed: err => {
            if (err === FileViewError.FileNotFound) {
                console.log("CornerSettings: No corners.json found, using defaults");
            }
        }
    }
}
