import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Templates 2.15 as T
import HuskarUI.Basic 1.0

T.Drawer {
    id: control

    property bool animationEnabled: HusTheme.animationEnabled
    property int drawerSize: 378
    property string title: ''
    property font titleFont
    property color colorTitle: HusTheme.HusDrawer.colorTitle
    property color colorBg: HusTheme.HusDrawer.colorBg
    property color colorOverlay: HusTheme.HusDrawer.colorOverlay
    property var captionBarRef
    property var _titleItem: null
    property Component titleDelegate: Item {
        id: __titleRoot
        objectName: "drawerTitleRoot"
        height: 56

        Row {
            height: parent.height
            anchors.left: control.edge === Qt.LeftEdge ? undefined : parent.left
            anchors.right: control.edge === Qt.LeftEdge ? parent.right : undefined
            anchors.leftMargin: control.edge === Qt.LeftEdge ? 15 : 0
            anchors.rightMargin: control.edge === Qt.RightEdge ? 15 : 0
            spacing: 5
            layoutDirection: control.edge === Qt.LeftEdge ? Qt.RightToLeft : Qt.LeftToRight
            HusCaptionButton {
                id: __close
                objectName: "drawerCloseBtn"
                topPadding: 2
                bottomPadding: 2
                leftPadding: 4
                rightPadding: 4
                radiusBg: 4
                anchors.verticalCenter: parent.verticalCenter
                iconSource: HusIcon.CloseOutlined
                hoverCursorShape: Qt.PointingHandCursor
                onClicked: {
                    control.close();
                }
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: control.title
                font: control.titleFont
                color: control.colorTitle
            }
        }

        HusDivider {
            width: parent.width
            height: 1
            anchors.bottom: parent.bottom
        }
    }
    property Component contentDelegate: Item { }

    enter: Transition { NumberAnimation { duration: control.animationEnabled ? HusTheme.Primary.durationMid : 0 } }
    exit: Transition { NumberAnimation { duration: control.animationEnabled ? HusTheme.Primary.durationMid : 0 } }

    width: edge === Qt.LeftEdge || edge === Qt.RightEdge ? drawerSize : parent.width
    height: edge === Qt.LeftEdge || edge === Qt.RightEdge ? parent.height : drawerSize
    titleFont {
        family: HusTheme.HusDrawer.fontFamily
        pixelSize: HusTheme.HusDrawer.fontSizeTitle
    }
    edge: Qt.RightEdge
    parent: T.Overlay.overlay
    modal: true
    onOpened: {
        if (!captionBarRef) return;
        var titleItem = control._titleItem;
        if (titleItem) captionBarRef.addInteractionItem(titleItem);
        var closeBtn = titleItem && titleItem.findChild ? titleItem.findChild("drawerCloseBtn") : null;
        if (closeBtn) captionBarRef.addInteractionItem(closeBtn);
    }
    background: Item {
        HusShadow {
            anchors.fill: __rect
            source: __rect
            shadowColor: HusTheme.HusDrawer.colorShadow
        }

        Rectangle {
            id: __rect
            anchors.fill: parent
            color: control.colorBg
        }
    }
    contentItem: ColumnLayout {
        Loader {
            Layout.fillWidth: true
            sourceComponent: titleDelegate
            onLoaded: {
                /*! 无边框窗口的标题栏会阻止事件传递, 需要调这个 */
                control._titleItem = item;
                if (captionBarRef && item) {
                    captionBarRef.addInteractionItem(item);
                    var closeBtn = item.findChild ? item.findChild("drawerCloseBtn") : null;
                    if (closeBtn) captionBarRef.addInteractionItem(closeBtn);
                }
            }
        }
        Loader {
            Layout.fillWidth: true
            Layout.fillHeight: true
            sourceComponent: contentDelegate
        }
    }

    T.Overlay.modal: Rectangle {
        color: control.colorOverlay
    }
}
