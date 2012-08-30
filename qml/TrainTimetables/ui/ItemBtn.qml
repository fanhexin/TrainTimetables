// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "../UIConstants.js" as UI

Item {
    width: parent.width
    height: img.height + 2*UI.NORMAL_MARGIN

    property alias text: title.text
    property alias describe: sub_title.text
    property alias source: img.source
    signal click()

    Image {
        id: img
        width: 80
        height: 80
        anchors {
            top: parent.top
            left: parent.left
            margins: UI.NORMAL_MARGIN
        }
    }

    Label {
        id: title
        anchors {
            top: parent.top
            topMargin: UI.NORMAL_MARGIN
            left: img.right
        }
        font.pixelSize: UI.FONT_SIZE_LARGE
        font.bold: true
    }

    Label {
        id: sub_title
        anchors {
            bottom: parent.bottom
            bottomMargin: UI.NORMAL_MARGIN
            left: img.right
        }
    }

    SeparatorHLine {
        anchors.top: parent.bottom
    }

    BorderImage {
        asynchronous: true
        anchors.fill: parent
        z: -1
        visible: mouse_area.pressed
        source: (theme.inverted)?"image://theme/meegotouch-list-inverted-background-pressed-center":"image://theme/meegotouch-list-background-pressed-center"
    }

    MouseArea {
        id: mouse_area
        anchors.fill: parent
        onClicked: click()
    }
}
