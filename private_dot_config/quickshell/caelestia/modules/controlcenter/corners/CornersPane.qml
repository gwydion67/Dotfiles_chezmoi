pragma ComponentBehavior: Bound

import ".."
import "../components"
import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.components
import qs.components.containers
import qs.components.controls
import qs.services
import qs.utils
import "../../../services"

Item {
    id: root

    required property Session session

    anchors.fill: parent

    StyledFlickable {
        anchors.fill: parent
        contentHeight: layout.implicitHeight + Tokens.padding.large * 2
        flickableDirection: Flickable.VerticalFlick

        ColumnLayout {
            id: layout
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: Tokens.padding.large * 2
            spacing: Tokens.spacing.large

            SettingsHeader {
                icon: "rounded_corner"
                title: qsTr("Corner Actions")
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: Tokens.spacing.normal

                CornerSetting {
                    title: qsTr("Top Left")
                    action: CornerSettings.topLeftAction
                    delay: CornerSettings.topLeftDelay
                    onActionEdited: val => { CornerSettings.topLeftAction = val; CornerSettings.save(); }
                    onDelayEdited: val => { CornerSettings.topLeftDelay = val; CornerSettings.save(); }
                }

                CornerSetting {
                    title: qsTr("Top Right")
                    action: CornerSettings.topRightAction
                    delay: CornerSettings.topRightDelay
                    onActionEdited: val => { CornerSettings.topRightAction = val; CornerSettings.save(); }
                    onDelayEdited: val => { CornerSettings.topRightDelay = val; CornerSettings.save(); }
                }

                CornerSetting {
                    title: qsTr("Bottom Left")
                    action: CornerSettings.bottomLeftAction
                    delay: CornerSettings.bottomLeftDelay
                    onActionEdited: val => { CornerSettings.bottomLeftAction = val; CornerSettings.save(); }
                    onDelayEdited: val => { CornerSettings.bottomLeftDelay = val; CornerSettings.save(); }
                }

                CornerSetting {
                    title: qsTr("Bottom Right")
                    action: CornerSettings.bottomRightAction
                    delay: CornerSettings.bottomRightDelay
                    onActionEdited: val => { CornerSettings.bottomRightAction = val; CornerSettings.save(); }
                    onDelayEdited: val => { CornerSettings.bottomRightDelay = val; CornerSettings.save(); }
                }
            }
            
            StyledText {
                Layout.fillWidth: true
                text: qsTr("Actions: dashboard, launcher, session, sidebar, utilities, osd, or command: <cmd>")
                color: Colours.palette.m3outline
                font.pointSize: Tokens.font.size.small
                wrapMode: Text.WordWrap
            }
        }
    }

    component CornerSetting: ColumnLayout {
        required property string title
        property string action
        property int delay
        
        signal actionEdited(string action)
        signal delayEdited(int delay)

        spacing: Tokens.spacing.smaller

        StyledText {
            text: title
            font.weight: 600
        }

        RowLayout {
            spacing: Tokens.spacing.normal
            
            StyledInputField {
                Layout.fillWidth: true
                text: action
                onTextEdited: actionEdited(text)
            }

            CustomSpinBox {
                min: 0
                max: 5000
                step: 50
                value: delay
                onValueModified: val => delayEdited(val)
            }
            
            StyledText {
                text: "ms"
                color: Colours.palette.m3outline
            }
        }
    }
}
