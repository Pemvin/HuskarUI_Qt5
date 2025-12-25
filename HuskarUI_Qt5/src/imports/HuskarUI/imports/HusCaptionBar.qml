import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import HuskarUI.Basic 1.0

Rectangle {
    id: control

    property var targetWindow: null
    property HusWindowAgent windowAgent: null

    property alias layoutDirection: __row.layoutDirection

    property url winIcon: ''
    property alias winIconWidth: __winIconLoader.width
    property alias winIconHeight: __winIconLoader.height
    property alias winIconVisible: __winIconLoader.visible

    property string winTitle: targetWindow ? targetWindow.title : ''
    property font winTitleFont: Qt.font({
                                            family: HusTheme.Primary.fontPrimaryFamily,
                                            pixelSize: 14
                                        })
    property color winTitleColor: HusTheme.Primary.colorTextBase
    property alias winTitleVisible: __winTitleLoader.visible

    property bool returnButtonVisible: false
    property bool themeButtonVisible: false
    property bool topButtonVisible: false
    property bool minimizeButtonVisible: Qt.platform.os !== 'osx'
    property bool maximizeButtonVisible: Qt.platform.os !== 'osx'
    property bool closeButtonVisible: Qt.platform.os !== 'osx'

    property var returnCallback: () => { }
    property var themeCallback: () => { HusTheme.darkMode = HusTheme.isDark ? HusTheme.Light : HusTheme.Dark; }
    property var topCallback: checked => { }
    property var minimizeCallback:
        () => {
            if (targetWindow) HusApi.setWindowState(targetWindow, Qt.WindowMinimized);
        }
    property var maximizeCallback:
        () => {
            if (!targetWindow) return;

            if (targetWindow.visibility === Window.Maximized) targetWindow.showNormal();
            else targetWindow.showMaximized();
        }
    property var closeCallback: () => { if (targetWindow) targetWindow.close(); }
    property string contentDescription: targetWindow ? targetWindow.title : ''

    // 自定义按钮列表
    property var customButtons: []
    
    // 自定义控件列表
    property var customWidgets: []
    
    // 信号：自定义按钮列表发生变化
    signal custom_ButtonsChanged()
    
    // 信号：自定义控件列表发生变化
    signal custom_WidgetsChanged()

    // 添加自定义按钮的方法
    function addCustomButton(iconSource, iconSize, contentDescription, onClicked, options) {
        var button = Qt.createQmlObject(
            'import QtQuick 2.15; import HuskarUI.Basic 1.0; HusCaptionButton {}',
            control,
            "customButton"
        );
        
        // 检查对象是否创建成功
        if (!button) {
            console.error("Failed to create button");
            return null;
        }
        
        button.iconSource = iconSource || "";
        button.iconSize = iconSize || 16;
        button.contentDescription = contentDescription || "";
        if (onClicked) {
            button.clicked.connect(onClicked);
        }
        
        // 应用可选属性
        if (options) {
            if (options.visible !== undefined) button.visible = options.visible;
            if (options.checkable !== undefined) button.checkable = options.checkable;
            if (options.checked !== undefined) button.checked = options.checked;
            if (options.isError !== undefined) button.isError = options.isError;
            if (options.enabled !== undefined) button.enabled = options.enabled;
            if (options.width !== undefined) button.width = options.width;
        }
        
        // 使用技巧强制触发数组变化通知
        var newArray = customButtons.slice();
        newArray.push(button);
        customButtons = newArray;
        
        // 如果windowAgent已经设置，立即添加交互支持
        if (windowAgent) {
            control.addInteractionItem(button);
        }
        
        return button;
    }
    
    // 添加自定义控件的方法
    function addCustomWidget(component, properties, options) {
        // 检查组件是否已准备好
        if (component.status !== Component.Ready) {
            console.error("Component is not ready, status:", component.status);
            if (component.status === Component.Error) {
                console.error("Component error:", component.errorString());
            }
            return null;
        }
        
        var widget = component.createObject(control, properties || {});
        
        // 检查对象是否创建成功
        if (!widget) {
            console.error("Failed to create widget from component");
            return null;
        }
        
        // 应用可选属性
        if (options) {
            if (options.visible !== undefined) widget.visible = options.visible;
            if (options.enabled !== undefined) widget.enabled = options.enabled;
            if (options.width !== undefined) widget.width = options.width;
            if (options.height !== undefined) widget.height = options.height;
        }
        
        // 使用技巧强制触发数组变化通知
        var newArray = customWidgets.slice();
        newArray.push(widget);
        customWidgets = newArray;
        
        // 如果windowAgent已经设置，立即添加交互支持
        if (windowAgent) {
            control.addInteractionItem(widget);
        }
        
        return widget;
    }
    
    // 移除自定义按钮的方法
    function removeCustomButton(button) {
        var index = customButtons.indexOf(button);
        if (index !== -1) {
            // 使用技巧强制触发数组变化通知
            var newArray = customButtons.slice();
            newArray.splice(index, 1);
            customButtons = newArray;
            
            button.destroy();
            return true;
        }
        return false;
    }
    
    // 移除自定义控件的方法
    function removeCustomWidget(widget) {
        var index = customWidgets.indexOf(widget);
        if (index !== -1) {
            // 使用技巧强制触发数组变化通知
            var newArray = customWidgets.slice();
            newArray.splice(index, 1);
            customWidgets = newArray;
            
            widget.destroy();
            return true;
        }
        return false;
    }
    
    // 清空所有自定义按钮
    function clearCustomButtons() {
        for (var i = 0; i < customButtons.length; i++) {
            customButtons[i].destroy();
        }
        // 使用技巧强制触发数组变化通知
        customButtons = [];
    }
    
    // 清空所有自定义控件
    function clearCustomWidgets() {
        for (var i = 0; i < customWidgets.length; i++) {
            customWidgets[i].destroy();
        }
        // 使用技巧强制触发数组变化通知
        customWidgets = [];
    }

    property Component winIconDelegate: Image {
        source: control.winIcon
        sourceSize.width: width
        sourceSize.height: height
        mipmap: true
    }
    property Component winTitleDelegate: HusText {
        text: winTitle
        color: winTitleColor
        font: winTitleFont
    }
    property Component winExtraButtonsDelegate: Row {
        id: extraButtonsRow
        
        Connections {
            target: control
            function onWindowAgentChanged() {
                control.addInteractionItem(__themeButton);
                control.addInteractionItem(__topButton);
                
                // 为自定义按钮添加交互支持
                for (var i = 0; i < control.customButtons.length; i++) {
                    control.addInteractionItem(control.customButtons[i]);
                }
                
                // 为自定义控件添加交互支持
                for (var j = 0; j < control.customWidgets.length; j++) {
                    control.addInteractionItem(control.customWidgets[j]);
                }
            }
            
            function onCustom_ButtonsChanged() {
                // 当自定义按钮列表发生变化时，确保所有按钮都有交互支持
                if (windowAgent) {
                    for (var i = 0; i < control.customButtons.length; i++) {
                        control.addInteractionItem(control.customButtons[i]);
                    }
                }
            }
            
            function onCustom_WidgetsChanged() {
                // 当自定义控件列表发生变化时，确保所有控件都有交互支持
                if (windowAgent) {
                    for (var j = 0; j < control.customWidgets.length; j++) {
                        control.addInteractionItem(control.customWidgets[j]);
                    }
                }
            }
        }
        
        // 动态添加自定义按钮
        Repeater {
            model: control.customButtons
            
            Item {
                height: extraButtonsRow.height
                width: children[0] ? children[0].width : 0
                
                // 直接使用已创建的按钮实例
                Component.onCompleted: {
                    if (modelData) {
                        var button = modelData;
                        button.parent = this;
                        button.anchors.verticalCenter = verticalCenter;
                        
                        if (windowAgent) {
                            control.addInteractionItem(button);
                        }
                    }
                }
            }
        }
        
        // 动态添加自定义控件
        Repeater {
            model: control.customWidgets
            
            Item {
                height: extraButtonsRow.height
                width: children[0] ? children[0].width : 100
                
                // 直接使用已创建的控件实例
                Component.onCompleted: {
                    if (modelData) {
                        var widget = modelData;
                        widget.parent = this;
                        widget.anchors.verticalCenter = verticalCenter;
                        
                        if (windowAgent) {
                            control.addInteractionItem(widget);
                        }
                    }
                }
            }
        }
        
        HusCaptionButton {
            id: __themeButton
            height: parent.height
            visible: control.themeButtonVisible
            iconSource: HusTheme.isDark ? HusIcon.MoonOutlined : HusIcon.SunOutlined
            iconSize: 16
            contentDescription: qsTr('明暗主题切换')
            onClicked: control.themeCallback();
        }

        HusCaptionButton {
            id: __topButton
            height: parent.height
            visible: control.topButtonVisible
            iconSource: HusIcon.PushpinOutlined
            iconSize: 16
            checkable: true
            contentDescription: qsTr('置顶')
            onClicked: control.topCallback(checked);
        }

    }
    property Component winButtonsDelegate: Row {
        Connections {
            target: control
            function onWindowAgentChanged() {
                if (windowAgent) {
                    windowAgent.setSystemButton(HusWindowAgent.Minimize, __minimizeButton);
                    windowAgent.setSystemButton(HusWindowAgent.Maximize, __maximizeButton);
                    windowAgent.setSystemButton(HusWindowAgent.Close, __closeButton);
                }
            }
        }

        HusCaptionButton {
            id: __minimizeButton
            height: parent.height
            visible: control.minimizeButtonVisible
            iconSource: HusIcon.LineOutlined
            iconSize: 14
            contentDescription: qsTr('最小化')
            onClicked: control.minimizeCallback();
        }

        HusCaptionButton {
            id: __maximizeButton
            height: parent.height
            visible: control.maximizeButtonVisible
            topPadding: 8
            bottomPadding: 8
            contentItem: HusIconText {
                iconSource: HusIcon.SwitcherTwotonePath3
                iconSize: 14
                colorIcon: __maximizeButton.colorIcon
                visible: targetWindow

                HusIconText {
                    iconSource: HusIcon.SwitcherTwotonePath2
                    iconSize: 14
                    colorIcon: __maximizeButton.colorIcon
                    visible: targetWindow.visibility === Window.Maximized
                }
            }
            contentDescription: qsTr('最大化')
            onClicked: control.maximizeCallback();
        }

        HusCaptionButton {
            id: __closeButton
            height: parent.height
            visible: control.closeButtonVisible
            iconSource: HusIcon.CloseOutlined
            iconSize: 14
            isError: true
            contentDescription: qsTr('关闭')
            onClicked: control.closeCallback();
        }
    }

    objectName: '__HusCaptionBar__'
    color: 'transparent'

    function addInteractionItem(item) {
        if (windowAgent)
            windowAgent.setHitTestVisible(item, true);
    }

    function removeInteractionItem(item) {
        if (windowAgent)
            windowAgent.setHitTestVisible(item, false);
    }

    RowLayout {
        id: __row
        anchors.fill: parent
        spacing: 0

        HusCaptionButton {
            id: __returnButton
            Layout.alignment: Qt.AlignVCenter
            iconSource: HusIcon.ArrowLeftOutlined
            iconSize: HusTheme.HusCaptionButton.fontSize + 2
            visible: control.returnButtonVisible
            onClicked: returnCallback();
            contentDescription: qsTr('返回')
        }

        Item {
            id: __title
            Layout.fillWidth: true
            Layout.fillHeight: true
            Component.onCompleted: {
                if (windowAgent)
                    windowAgent.setTitleBar(__title);
            }

            Row {
                height: parent.height
                anchors.left: Qt.platform.os === 'osx' ? undefined : parent.left
                anchors.leftMargin: Qt.platform.os === 'osx' ? 0 : 8
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: Qt.platform.os === 'osx' ? parent.horizontalCenter : undefined
                spacing: 5

                Loader {
                    id: __winIconLoader
                    width: 20
                    height: 20
                    anchors.verticalCenter: parent.verticalCenter
                    sourceComponent: winIconDelegate
                }

                Loader {
                    id: __winTitleLoader
                    anchors.verticalCenter: parent.verticalCenter
                    sourceComponent: winTitleDelegate
                }
            }
        }

        Loader {
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignVCenter
            sourceComponent: winExtraButtonsDelegate
        }

        Loader {
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignVCenter
            sourceComponent: winButtonsDelegate
        }
    }

    Accessible.role: Accessible.TitleBar
    Accessible.name: control.contentDescription
    Accessible.description: control.contentDescription
}
