// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "../UIConstants.js" as UI

CommonList {
    id: list_view
    highlightFollowsCurrentItem: false
    signal click

    delegate: Item {
        height: 88
        width: 480
        Column {
            anchors {
                left: parent.left
                leftMargin: UI.SMALL_MARGIN
                verticalCenter: parent.verticalCenter
            }

            Label {
                text: title
                font.pixelSize: 26
                font.bold: true
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                list_view.currentIndex = index;
                click();
            }
        }
    }

    Component {
        id: highlightBar
        Rectangle {
            id: highlight_rec
            width: 480; height: 88
            color: "#2A8EE0"
            y: list_view.currentItem?list_view.currentItem.y:0
        }
    }

    highlight: highlightBar
}
