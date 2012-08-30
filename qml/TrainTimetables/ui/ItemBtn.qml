// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "../UIConstants.js" as UI

Item {
    id: item_btn
    width: parent.width
    height: row.height + 20

    property int titleWeight: Font.Bold
    property color titleColor: theme.inverted ? "#ffffff" : "#282828"

    property int subtitleWeight: Font.Light
    property color subtitleColor: theme.inverted ? "#d2d2d2" : "#505050"

    property alias text: mainText.text
    property alias describe: subText.text
    property string iconSource
    signal click()

    Row {
        id: row
        width: parent.width
        anchors.verticalCenter: parent.verticalCenter
        spacing: 18

        Image {
            anchors.verticalCenter: parent.verticalCenter
            visible: iconSource ? true : false
            width: 64
            height: 64
            source: iconSource ? iconSource : ""
        }

        Column {
            Label {
                id: mainText
                font.weight: titleWeight
                font.pixelSize: 32
                color: titleColor
            }

            Label {
                id: subText
                font.weight: subtitleWeight
                color: subtitleColor

                visible: text != ""
            }
        }
    }

    Image {
        source: "image://theme/icon-m-common-drilldown-arrow" + (theme.inverted ? "-inverse" : "")
        anchors.right: parent.right;
        anchors.verticalCenter: parent.verticalCenter
    }

    Rectangle {
        id: background
        z: -1
        anchors.fill: parent
        color: '#2A8EE0'
        visible: mouse_area.pressed
    }

    MouseArea {
        id: mouse_area
        anchors.fill: parent
        onClicked: click()
    }
}
