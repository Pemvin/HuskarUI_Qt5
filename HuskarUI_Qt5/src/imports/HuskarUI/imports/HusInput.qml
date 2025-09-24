import QtQuick 2.15
import QtQuick.Controls 2.15 as T
import HuskarUI.Basic 1.0

T.TextField {
    id: control

    enum IconPosition {
        Position_Left = 0,
        Position_Right = 1
    }

    property bool animationEnabled: HusTheme.animationEnabled
    readonly property bool active: hovered || activeFocus
    property var iconSource: 0 || ''
    property int iconSize: control.themeSource.fontIconSize
    property int iconPosition: HusInput.Position_Left
    property color colorIcon: colorText
    property color colorText: enabled ? control.themeSource.colorText : control.themeSource.colorTextDisabled
    property color colorBorder: enabled ?
                                    active ? control.themeSource.colorBorderHover :
                                              control.themeSource.colorBorder : control.themeSource.colorBorderDisabled
    property color colorBg: enabled ? control.themeSource.colorBg : control.themeSource.colorBgDisabled
    property int radiusBg: control.themeSource.radiusBg
    property string contentDescription: ''
    property var themeSource: HusTheme.HusInput

    property Component iconDelegate: HusIconText {
        iconSource: control.iconSource
        iconSize: control.iconSize
        colorIcon: control.colorIcon
    }

    objectName: '__HusInput__'
    focus: true
    padding: 6
    leftPadding: 10 + (((iconSource !== 0 && iconSource !== '') && iconPosition == HusInput.Position_Left) ? iconSize : 0)
    rightPadding: 10 + (((iconSource !== 0 && iconSource !== '') && iconPosition == HusInput.Position_Right) ? iconSize : 0)
    implicitWidth: contentWidth + leftPadding + rightPadding
    implicitHeight: contentHeight + topPadding + bottomPadding
    color: colorText
    placeholderTextColor: enabled ? control.themeSource.colorPlaceholderText : control.themeSource.colorPlaceholderTextDisabled
    selectedTextColor: control.themeSource.colorTextSelected
    selectionColor: control.themeSource.colorSelection
    selectByMouse: true
    font {
        family: control.themeSource.fontFamily
        pixelSize: control.themeSource.fontSize
    }
    background: Rectangle {
        color: control.colorBg
        border.color: control.colorBorder
        radius: control.radiusBg
    }

    Behavior on colorText { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }
    Behavior on colorBorder { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }
    Behavior on colorBg { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }

    Loader {
        anchors.left: iconPosition == HusInput.Position_Left ? parent.left : undefined
        anchors.right: iconPosition == HusInput.Position_Right ? parent.right : undefined
        anchors.margins: 5
        anchors.verticalCenter: parent.verticalCenter
        active: control.iconSize != 0
        sourceComponent: iconDelegate
    }

    Accessible.role: Accessible.EditableText
    Accessible.editable: true
    Accessible.description: control.contentDescription
}
