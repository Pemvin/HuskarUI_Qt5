import QtQuick 2.15
import QtGraphicalEffects 1.15
import HuskarUI.Basic 1.0

DropShadow {
    id: control
    radius: 12
    samples: 12
    color: HusTheme.Primary.colorTextBase
    opacity: 0.2
    property alias shadowColor: control.color
}
