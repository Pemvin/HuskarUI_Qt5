import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import HuskarUI.Basic 1.0

import '../../Controls'

Flickable {
    contentHeight: column.height+100
    ScrollBar.vertical: HusScrollBar { }

    Column {
        id: column
        width: parent.width
        spacing: 30

        HusDivider {
            width: parent.width
            height: 66
            title: qsTr('Primary 主题变量')
            titleFont.pixelSize:HusTheme.Primary.fontPrimarySizeHeading1
            titleFont.bold: true
        }

        Column {
            width: parent.width
            spacing: 20

            // 字体相关属性展示
            Column {
                width: parent.width
                spacing: 10

                HusCopyableText {
                    text: qsTr('字体族 (HusTheme.Primary.fontPrimaryFamily): ') + HusTheme.Primary.fontPrimaryFamily
                    font.family: HusTheme.Primary.fontPrimaryFamily
                    font.pixelSize: HusTheme.Primary.fontPrimarySize
                }

                HusCopyableText {
                    text: qsTr('默认字体大小 (HusTheme.Primary.fontPrimarySize): ') + HusTheme.Primary.fontPrimarySize + "px"
                    font.family: HusTheme.Primary.fontPrimaryFamily
                    font.pixelSize: HusTheme.Primary.fontPrimarySize
                }

                HusCopyableText {
                    text: qsTr('标题1字体大小 (HusTheme.Primary.fontPrimarySizeHeading1): ') + HusTheme.Primary.fontPrimarySizeHeading1 + "px"
                    font.family: HusTheme.Primary.fontPrimaryFamily
                    font.pixelSize: HusTheme.Primary.fontPrimarySizeHeading1
                }

                HusCopyableText {
                    text: qsTr('标题2字体大小 (HusTheme.Primary.fontPrimarySizeHeading2): ') + HusTheme.Primary.fontPrimarySizeHeading2 + "px"
                    font.family: HusTheme.Primary.fontPrimaryFamily
                    font.pixelSize: HusTheme.Primary.fontPrimarySizeHeading2
                }

                HusCopyableText {
                    text: qsTr('标题3字体大小 (HusTheme.Primary.fontPrimarySizeHeading3): ') + HusTheme.Primary.fontPrimarySizeHeading3 + "px"
                    font.family: HusTheme.Primary.fontPrimaryFamily
                    font.pixelSize: HusTheme.Primary.fontPrimarySizeHeading3
                }

                HusCopyableText {
                    text: qsTr('行高 (HusTheme.Primary.fontPrimaryHeight): ') + HusTheme.Primary.fontPrimaryHeight + "px"
                    font.family: HusTheme.Primary.fontPrimaryFamily
                    font.pixelSize: HusTheme.Primary.fontPrimarySize
                    height: HusTheme.Primary.fontPrimaryHeight / HusTheme.Primary.fontPrimarySize
                }
            }

            // 颜色相关属性展示
            Column {
                width: parent.width
                spacing: 10

                HusText {
                    text: qsTr('颜色相关属性')
                    font.family: HusTheme.Primary.fontPrimaryFamily
                    font.pixelSize: HusTheme.Primary.fontPrimarySizeHeading3
                    font.bold: true
                }

                Grid {
                    columns: 3
                    spacing: 10

                    Repeater {
                        model: [
                            { name: "colorTextBase", value: HusTheme.Primary.colorTextBase },
                            { name: "colorTextPrimary", value: HusTheme.Primary.colorTextPrimary },
                            { name: "colorTextSecondary", value: HusTheme.Primary.colorTextSecondary },
                            { name: "colorTextTertiary", value: HusTheme.Primary.colorTextTertiary },
                            { name: "colorTextQuaternary", value: HusTheme.Primary.colorTextQuaternary },
                            { name: "colorBgBase", value: HusTheme.Primary.colorBgBase },
                            { name: "colorBgContainer", value: HusTheme.Primary.colorBgContainer },
                            { name: "colorBgElevated", value: HusTheme.Primary.colorBgElevated },
                            { name: "colorPrimary", value: HusTheme.Primary.colorPrimary },
                            { name: "colorPrimaryHover", value: HusTheme.Primary.colorPrimaryHover },
                            { name: "colorPrimaryActive", value: HusTheme.Primary.colorPrimaryActive },
                            { name: "colorSuccess", value: HusTheme.Primary.colorSuccess },
                            { name: "colorWarning", value: HusTheme.Primary.colorWarning },
                            { name: "colorError", value: HusTheme.Primary.colorError },
                            { name: "colorBorder", value: HusTheme.Primary.colorBorder },
                            { name: "colorFill", value: HusTheme.Primary.colorFill }
                        ]
                        delegate: Rectangle {
                            width: 220
                            height: 50
                            color: modelData.value
                            border.color: Qt.darker(modelData.value, 1.2)

                            Row {
                                anchors.fill: parent
                                anchors.margins: 5
                                spacing: 5

                                Rectangle {
                                    width: 20
                                    height: 20
                                    anchors.verticalCenter: parent.verticalCenter
                                    color: modelData.value
                                    border.color: Qt.darker(modelData.value, 1.2)
                                }

                                Column {
                                    anchors.verticalCenter: parent.verticalCenter

                                    HusCopyableText {
                                        text: "HusTheme.Primary." + modelData.name
                                        font.pixelSize: 10
                                        color: Qt.lighter(modelData.value, 2)
                                        wrapMode: TextEdit.WordWrap
                                    }

                                    HusCopyableText {
                                        text: modelData.value
                                        font.pixelSize: 10
                                        color: Qt.lighter(modelData.value, 2)
                                        wrapMode: TextEdit.WordWrap
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // 圆角相关属性展示
            Column {
                width: parent.width
                spacing: 10

                HusText {
                    text: qsTr('圆角相关属性')
                    font.family: HusTheme.Primary.fontPrimaryFamily
                    font.pixelSize: HusTheme.Primary.fontPrimarySizeHeading3
                    font.bold: true
                }

                Row {
                    spacing: 20

                    Repeater {
                        model: [
                            { name: "radiusPrimary", value: HusTheme.Primary.radiusPrimary },
                            { name: "radiusPrimaryLG", value: HusTheme.Primary.radiusPrimaryLG },
                            { name: "radiusPrimarySM", value: HusTheme.Primary.radiusPrimarySM },
                            { name: "radiusPrimaryXS", value: HusTheme.Primary.radiusPrimaryXS },
                            { name: "radiusPrimaryOuter", value: HusTheme.Primary.radiusPrimaryOuter }
                        ]
                        delegate: Column {
                            spacing: 5

                            HusRectangle {
                                width: 80
                                height: 80
                                color: HusTheme.Primary.colorPrimary
                                radius: modelData.value
                                border.width: 2
                                border.color: HusTheme.Primary.colorPrimaryBorder
                            }

                            HusCopyableText {
                                text: "HusTheme.Primary." + modelData.name + "\n" + modelData.value + "px"
                                font.family: HusTheme.Primary.fontPrimaryFamily
                                font.pixelSize: 12
                                horizontalAlignment: Text.AlignHCenter
                            }
                        }
                    }
                }
            }

            // 动画相关属性展示
            Column {
                width: parent.width
                spacing: 10

                HusText {
                    text: qsTr('动画相关属性')
                    font.family: HusTheme.Primary.fontPrimaryFamily
                    font.pixelSize: HusTheme.Primary.fontPrimarySizeHeading3
                    font.bold: true
                }

                Column {
                    width: parent.width
                    spacing: 5

                    HusCopyableText {
                        text: qsTr('快速动画时长 (HusTheme.Primary.durationFast): ') + HusTheme.Primary.durationFast + "ms"
                        font.family: HusTheme.Primary.fontPrimaryFamily
                        font.pixelSize: HusTheme.Primary.fontPrimarySize
                    }

                    HusCopyableText {
                        text: qsTr('中速动画时长 (HusTheme.Primary.durationMid): ') + HusTheme.Primary.durationMid + "ms"
                        font.family: HusTheme.Primary.fontPrimaryFamily
                        font.pixelSize: HusTheme.Primary.fontPrimarySize
                    }

                    HusCopyableText {
                        text: qsTr('慢速动画时长 (HusTheme.Primary.durationSlow): ') + HusTheme.Primary.durationSlow + "ms"
                        font.family: HusTheme.Primary.fontPrimaryFamily
                        font.pixelSize: HusTheme.Primary.fontPrimarySize
                    }

                    HusCopyableText {
                        text: qsTr('动画启用状态 (HusTheme.animationEnabled): ') + (HusTheme.animationEnabled ? qsTr("已启用") : qsTr("已禁用"))
                        font.family: HusTheme.Primary.fontPrimaryFamily
                        font.pixelSize: HusTheme.Primary.fontPrimarySize
                    }
                }
            }
        }

        HusDivider {
            width: parent.width
            height: 66
            title: qsTr('组件特定主题变量')
            titleFont.pixelSize:HusTheme.Primary.fontPrimarySizeHeading1
            titleFont.bold: true
        }

        Column {
            width: parent.width
            spacing: 20

            ComboBox {
                id: componentSelector
                width: 200
                model: Object.keys(galleryGlobal.componentTokens)
                onCurrentTextChanged: {
                    componentThemeToken.active=false
                    componentThemeToken.themeTokenName = currentText;
                    componentThemeToken.active=true
                }
                Component.onCompleted: {
                    if (count > 0) {
                        currentIndex = 0;
                        componentThemeToken.themeTokenName = currentText;
                        componentThemeToken.active=true
                    }
                }
            }

            Loader {
                id: componentThemeToken
                width: parent.width
                active:false
                property string themeTokenName:""
                sourceComponent: ThemeToken {
                    source: themeTokenName
                }
            }
        }
    }
}