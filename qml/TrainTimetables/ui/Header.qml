import QtQuick 1.1
import com.nokia.meego 1.0
import "../UIConstants.js" as UI

Rectangle {
    width: parent.width
    height: UI.HEADER_HEIGHT

    property alias content: titleTxt.text
    property alias text_anchors: titleTxt.anchors
    property string icon

    Row {
        id: row
        anchors {
            left: parent.left
            leftMargin: 10
            verticalCenter: parent.verticalCenter
        }
        spacing: 10

        Image {
            asynchronous: true
            source: icon
            visible: icon.length != 0
        }

        Text {
            id: titleTxt
            color: "white"
            font.pixelSize: UI.FONT_SIZE_LARGE
        }
    }
}
