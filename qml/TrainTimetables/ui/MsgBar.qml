// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "../UIConstants.js" as UI
Rectangle {
    id: msg_bar
    property alias subtitle_text: subtitle.text
    property alias text: msg.text
    height: col.height
    color: (theme.inverted)?'#333333':'#CCCCCC'
    Column {
        id: col
        anchors {
            top: parent.top
            left: parent.left
            leftMargin: UI.SMALL_MARGIN
        }

        Label {
            id: msg
            font.pixelSize: 20
        }

        Row {
            id: sub_row
            visible: subtitle.text
            Rectangle {
                width: 5
                height: sub_row.height
                color: '#F98F00'
            }

            Label {
                id: subtitle
                font.pixelSize: 20
            }
        }
    }
}
