import QtQuick 2.15
import QtQuick.Layouts 1.15
import HuskarUI.Basic 1.0

Item {
    id: root

    width: parent.width
    height: column.height

    property string source: ''
    onSourceChanged:{
        if(tableLoader.active){
            tableLoader.active=false
            tableLoader.active=true
        }
    }
    HusMessage {
        id: message
        z: 999
        parent: galleryWindow.captionBar
        width: parent.width
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.bottom
    }

    HusPopup {
        id: editPopup

        property int row
        property var edit

        padding: 5
        contentItem: Row {
            spacing: 5

            HusAutoComplete {
                id: editInput
                width: 200
                options: galleryGlobal.primaryTokens
                tooltipVisible: true
                iconSource: length > 0 ? HusIcon.CloseCircleFilled : 0
                filterOption: function(input, option){
                    return option.label.toUpperCase().indexOf(input.toUpperCase()) !== -1;
                }
            }

            HusButton {
                text: qsTr('确认')
                onClicked: {
                    editPopup.edit.value = editInput.text;
                    galleryGlobal.componentTokens[root.source][editPopup.row].tokenValue.value = editPopup.edit.value;
                    message.info("修改组件"+root.source+"token:"+editPopup.edit.token+ " to value:"+ editPopup.edit.value,10000);

                    HusTheme.installComponentToken(root.source, editPopup.edit.token, editInput.text);
                    editPopup.close();
                }
            }

            HusButton {
                text: qsTr('取消')
                onClicked: {
                    editPopup.close();
                }
            }

            HusButton {
                text: qsTr('重置')
                onClicked: {
                    editPopup.edit.value = editPopup.edit.rawValue;
                    HusTheme.installComponentToken(root.source, editPopup.edit.token, editPopup.edit.rawValue);
                    editPopup.close();
                }
            }
        }
    }

    Component {
        id: tagDelegate

        Item {
            HusTag {
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                text: cellData
                presetColor: 'orange'
                font {
                    family: HusTheme.Primary.fontPrimaryFamily
                    pixelSize: HusTheme.Primary.fontPrimarySize
                }

                HoverHandler {
                    id: hoverHandler
                }

                HusToolTip {
                    text: parent.text
                    visible: hoverHandler.hovered
                }
            }
        }
    }

    Component {
        id: editDelegate

        Item {
            Row {
                id: editRow
                anchors.fill: parent
                anchors.leftMargin: 10
                spacing: 5

                property string token: cellData.token
                property string rawValue: cellData.rawValue
                property string value: cellData.value

                HusIconButton {
                    anchors.verticalCenter: parent.verticalCenter
                    iconSource: HusIcon.EditOutlined
                    topPadding: 2
                    bottomPadding: 2
                    leftPadding: 4
                    rightPadding: 4
                    onClicked: {
                        editPopup.parent = this;
                        editPopup.row = row;
                        editPopup.edit = editRow;
                        editInput.text = editRow.value;
                        editInput.filter();
                        editPopup.open();
                    }

                    HusToolTip {
                        visible: parent.hovered
                        text: qsTr('编辑Token')
                    }
                }

                HusTag {
                    anchors.verticalCenter: parent.verticalCenter
                    text: editRow.value
                    presetColor: 'green'
                    font {
                        family: HusTheme.Primary.fontPrimaryFamily
                        pixelSize: HusTheme.Primary.fontPrimarySize
                    }
                    HoverHandler {
                        id: hoverHandler2
                    }

                    HusToolTip {
                        text: parent.text
                        visible: hoverHandler2.hovered
                    }
                }
            }
        }
    }

    Component {
        id: colorTagDelegate

        Item {
            property var theCellData: HusTheme[root.source][cellData]
            property bool isColorToken: cellData.toLowerCase().indexOf('color') !== -1
            property bool isColorValue: {
                // 检查是否为颜色Token
                if (isColorToken) {
                    return true;
                }
                
                // 检查是否为颜色对象
                if (typeof theCellData === 'object' && theCellData !== null) {
                    // 检查是否包含颜色相关的属性
                    return theCellData.hasOwnProperty('r') && theCellData.hasOwnProperty('g') && 
                           theCellData.hasOwnProperty('b') && theCellData.hasOwnProperty('a');
                }
                
                // 检查字符串格式的颜色值
                if (typeof theCellData === 'string') {
                    // 检查十六进制颜色
                    if (theCellData.startsWith('#') && (theCellData.length === 7 || theCellData.length === 9)) {
                        return true;
                    }
                    // 检查rgb/rgba格式
                    if (theCellData.startsWith('rgb')) {
                        return true;
                    }
                    // 检查常见的颜色名称
                    var colorNames = ['red', 'blue', 'green', 'yellow', 'black', 'white', 'gray', 'grey', 'orange', 'purple', 'pink', 'brown', 'cyan', 'magenta'];
                    return colorNames.indexOf(theCellData.toLowerCase()) !== -1;
                }
                
                return false;
            }
            property string colorString: {
                if (!isColorValue) {
                    return 'transparent';
                }
                
                // 处理null或undefined值
                if (theCellData === null || theCellData === undefined) {
                    console.log("Color token with null/undefined value:", cellData);
                    return 'transparent';
                }
                
                // 如果是颜色对象
                if (typeof theCellData === 'object' && theCellData !== null && theCellData.hasOwnProperty('r')) {
                    // 检查对象属性是否有效
                    if (theCellData.r === undefined || theCellData.g === undefined || 
                        theCellData.b === undefined || theCellData.a === undefined) {
                        console.log("Color object with missing properties :", cellData,JSON.stringify(theCellData));    
                        return 'transparent';
                    }
                    // 转换为RGBA字符串
                    return 'rgba(' + Math.round(theCellData.r * 255) + ', ' + 
                                   Math.round(theCellData.g * 255) + ', ' + 
                                   Math.round(theCellData.b * 255) + ', ' + 
                                   theCellData.a.toFixed(2) + ')';
                }
                
                // 如果是字符串颜色值
                if (typeof theCellData === 'string') {
                    return theCellData;
                }
                
                return 'transparent';
            }
            property bool isNumericValue: {
                if (isColorValue) {
                    return false; // 颜色值优先级更高
                }
                
                if (typeof theCellData === 'number') {
                    return true;
                }
                
                if (typeof theCellData === 'string') {
                    // 检查是否为数字或带px单位的数字
                    return !isNaN(parseFloat(theCellData)) || 
                           (theCellData.endsWith('px') && !isNaN(parseFloat(theCellData.slice(0, -2))));
                }
                
                return false;
            }
            property bool isFontValue: {
                if (isColorValue || isNumericValue) {
                    return false; // 颜色和数值优先级更高
                }
                // 处理null或undefined值
                if (theCellData === null || theCellData === undefined) {
                    console.log("Font token with null/undefined value:", cellData);
                    return 'false';
                }
                
                
                if (typeof theCellData !== 'string') {
                    return false;
                }
                
                // 检查是否包含字体相关的关键词
                var fontKeywords = ['font', 'family', 'serif', 'sans', 'arial', 'helvetica', 'times', 'courier'];
                var lowerValue = theCellData.toLowerCase();
                for (var i = 0; i < fontKeywords.length; i++) {
                    if (lowerValue.indexOf(fontKeywords[i]) !== -1) {
                        return true;
                    }
                }
                return false;
            }

            Row {
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                spacing: 10

                // 颜色预览
                Rectangle {
                    width: isColorValue ? 20 : 0
                    height: isColorValue ? 20 : 0
                    visible: isColorValue
                    color: {
                        // 直接使用theCellData而不是转换后的colorString来确保颜色正确显示
                        if (isColorValue) {
                            if (typeof theCellData === 'object' && theCellData !== null && theCellData.hasOwnProperty('r')) {
                                // 对于颜色对象，直接使用Qt.rgba创建颜色
                                try {
                                    return Qt.rgba(theCellData.r, theCellData.g, theCellData.b, theCellData.a);
                                } catch (e) {
                                    console.log("Error Creating Color from object:", cellData,JSON.stringify(theCellData));
                                    return 'transparent';
                                }
                            } else {
                                // 对于字符串颜色值，直接使用
                                return colorString;
                            }
                        }
                        return 'transparent';
                    }
                    border.color: color == 'transparent'? 'black' :Qt.darker(color, 1.2) 
                    radius: 3

                    // 如果颜色太暗，添加白色边框以便可见
                    border.width: isColorValue ? 1 : 0
                }

                // 数值预览（尺寸）
                Item {
                    width: isNumericValue && !isColorValue ? 50 : 0
                    height: isNumericValue && !isColorValue ? 30 : 0
                    visible: isNumericValue && !isColorValue

                    // 显示数值的可视化表示
                    Rectangle {
                        width: {
                            if (!isNumericValue) return 0;
                            var numValue = typeof theCellData === 'number' ? theCellData : parseFloat(theCellData);
                            if (isNaN(numValue)) {
                                var pxMatch = typeof theCellData === 'string' ? theCellData.match(/(\d+)px/) : null;
                                if (pxMatch) {
                                    numValue = parseFloat(pxMatch[1]);
                                } else {
                                    return 0;
                                }
                            }
                            // 限制最大宽度以避免过大
                            return Math.min(numValue * 2, 40);
                        }
                        height: width
                        anchors.centerIn: parent
                        color: HusTheme.Primary.colorPrimary
                        border.color: HusTheme.Primary.colorPrimaryBorder
                        radius: 2
                    }
                }

                // 字体预览
                Rectangle {
                    width: isFontValue && !isColorValue && !isNumericValue ? 40 : 0
                    height: isFontValue && !isColorValue && !isNumericValue ? 30 : 0
                    visible: isFontValue && !isColorValue && !isNumericValue
                    color: HusTheme.Primary.colorFillQuaternary
                    border.color: HusTheme.Primary.colorBorder
                    radius: 3

                    HusText {
                        anchors.centerIn: parent
                        text: "Aa"
                        font.family:typeof theCellData ==='string' ? theCellData : "sans-serif"
                        font.pixelSize: 14
                        color: HusTheme.Primary.colorTextPrimary
                    }
                }

                HusTag {
                    id: tag
                    Layout.leftMargin: 15
                    Layout.alignment: Qt.AlignVCenter
                    text: {
                        if (theCellData === null) {
                            console.log("token value is null");
                            return 'null'
                        }
                        if (theCellData === undefined) {
                            console.log("token value is undefined");
                            return 'undefined'
                        }
                        if (typeof theCellData === 'object' && theCellData !== null) {
                            if (theCellData.hasOwnProperty('r') && theCellData.hasOwnProperty('g') && 
                                theCellData.hasOwnProperty('b') && theCellData.hasOwnProperty('a')) {
                                // 对于颜色对象，显示RGBA值
                                return 'rgba(' + Math.round(theCellData.r * 255) + ', ' + 
                                       Math.round(theCellData.g * 255) + ', ' + 
                                       Math.round(theCellData.b * 255) + ', ' + 
                                       theCellData.a.toFixed(2) + ')';
                            }
                            // 其他对象类型转换为JSON字符串
                            return JSON.stringify(theCellData);
                        }
                        try {
                            return theCellData.toString();
                            
                        } catch(e) {
                            console.log("Error Converting token value to string :", cellData,typeof theCellData);
                            return "error"
                        }
                    }
                    presetColor: {
                        if (isColorValue) return 'blue';
                        if (isNumericValue) return 'purple';
                        if (isFontValue) return 'cyan';
                        return 'orange';
                    }
                    font {
                        family: HusTheme.Primary.fontPrimaryFamily
                        pixelSize: HusTheme.Primary.fontPrimarySize
                    }
                }
            }
        }
    }

    Column {
        id: column
        width: parent.width - 20
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 15

        HusText {
            text: qsTr('主题变量（Design Token）')
            width: parent.width
            font {
                pixelSize: HusTheme.Primary.fontPrimarySizeHeading3
                weight: Font.DemiBold
            }
        }

        Loader {
            id: tableLoader
            width: parent.width
            height: 40 * (galleryGlobal.componentTokens[root.source].length + 1)
            active: root.source != ''
            asynchronous: true
            sourceComponent: HusTableView {
                propagateWheelEvent: true
                columnGridVisible: true
                columns: [
                    {
                        title: qsTr('Token 名称'),
                        dataIndex: 'tokenName',
                        key: 'tokenName',
                        delegate: tagDelegate,
                        width: 250
                    },
                    {
                        title: qsTr('Token 值'),
                        key: 'tokenValue',
                        dataIndex: 'tokenValue',
                        delegate: editDelegate,
                        width: 400
                    },
                    {
                        title: qsTr('Token 计算值'),
                        key: 'tokenCalcValue',
                        dataIndex: 'tokenCalcValue',
                        delegate: colorTagDelegate,
                        width: 250
                    }
                ]
                Component.onCompleted: {
                    if (root.source != '') {
                        const model = galleryGlobal.componentTokens[root.source];
                        height = defaultColumnHeaderHeight + model.length * minimumRowHeight;
                        initModel = model;
                    }
                }
            }
        }
    }
}