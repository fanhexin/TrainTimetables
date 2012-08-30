// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "../UIConstants.js" as UI
Rectangle {
    id: srearch_cnt
    height: 30
    color: (theme.inverted)?'#333333':'#CCCCCC'

    property alias text: msg.text

    Label {
        id: msg
        anchors {
            top: parent.top
            left: parent.left
            leftMargin: UI.SMALL_MARGIN
            verticalCenter: parent.verticalCenter
        }
    }
}
