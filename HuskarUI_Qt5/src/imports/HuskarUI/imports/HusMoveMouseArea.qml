import QtQuick 2.15

MouseArea {
    id: root

    // === 现有属性 ===
    property var target: undefined
    property real minimumX: -Number.MAX_VALUE
    property real maximumX: Number.MAX_VALUE
    property real minimumY: -Number.MAX_VALUE
    property real maximumY: Number.MAX_VALUE

    property int clickThreshold: 5           // 点击判断阈值（像素）
    property int clickTimeThreshold: 200     // 点击判断时间阈值（毫秒）
    property bool enableClickDetection: true  // 启用点击检测

    readonly property bool shouldBlockClick: __private.shouldBlockClick

    objectName: '__HusMoveMouseArea__'

    QtObject {
        id: __private
        property point startPos: Qt.point(0, 0)
        property point offsetPos: Qt.point(0, 0)
        property bool hasMoved: false
        property bool isDragging: false
        property date pressTime: new Date()
        
        // 阻断状态
        property bool shouldBlockClick: false
    }

    onPressed: (mouse) => {
        __private.startPos = Qt.point(mouse.x, mouse.y);
        __private.hasMoved = false;
        __private.isDragging = false;
        __private.pressTime = new Date();
        __private.shouldBlockClick = false;
        
        cursorShape = Qt.SizeAllCursor;
    }

    onReleased: (mouse) => {
        
        if (enableClickDetection) {
            // 基于移动和时间判断
            let timeDiff = new Date() - __private.pressTime;
            let movedBeyondThreshold = __private.hasMoved;
            let timeBeyondThreshold = timeDiff > clickTimeThreshold;
            
            __private.shouldBlockClick = movedBeyondThreshold || timeBeyondThreshold;
        } else {
            __private.shouldBlockClick = false;
        }
        
        __private.hasMoved = false;
        __private.isDragging = false;
        cursorShape = Qt.ArrowCursor;
    }
    
    onPositionChanged: (mouse) => {
        if (pressed) {
            __private.offsetPos = Qt.point(mouse.x - __private.startPos.x, mouse.y - __private.startPos.y);
            
            let deltaX = Math.abs(__private.offsetPos.x);
            let deltaY = Math.abs(__private.offsetPos.y);
            
            if (!__private.hasMoved && (deltaX > clickThreshold || deltaY > clickThreshold)) {
                __private.hasMoved = true;
                __private.isDragging = true;
            }
            
            if (__private.isDragging && target) {
                performMove();
            }
        }
    }
    
    
    function performMove() {
        
        // x 轴移动
        let newX = target.x + __private.offsetPos.x;
        if (minimumX !== Number.NaN && minimumX > newX) {
            target.x = minimumX;
        } else if (maximumX !== Number.NaN && maximumX < newX) {
            target.x = maximumX;
        } else {
            target.x = newX;
        }
        
        // y 轴移动
        let newY = target.y + __private.offsetPos.y;
        if (minimumY !== Number.NaN && minimumY > newY) {
            target.y = minimumY;
        } else if (maximumY !== Number.NaN && maximumY < newY) {
            target.y = maximumY;
        } else {
            target.y = newY;
        }
        
    }
}
