// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0

Item {
    id: listItem

    signal clicked
    property alias pressed: mouse_area.pressed

    property int titleSize: 26
    property int titleWeight: Font.Bold
    property color titleColor: theme.inverted ? "#ffffff" : "#282828"

    property int subtitleSize: 22
    property int subtitleWeight: Font.Light
    property color subtitleColor: theme.inverted ? "#d2d2d2" : "#505050"

    height: row.height+20
    width: parent.width

    Rectangle {
        id: background
        z: -1
        anchors.fill: parent
        color: '#2A8EE0'
        visible: mouse_area.pressed
    }

    Row {
        id: row
        width: parent.width
        anchors.verticalCenter: parent.verticalCenter
        spacing: 18

        Image {
            anchors.verticalCenter: parent.verticalCenter
            visible: model.iconSource ? true : false
            width: 64
            height: 64
            source: model.iconSource ? model.iconSource : ""
        }

        Column {
            Label {
                id: mainText
                text: model.title
                font.weight: listItem.titleWeight
                font.pixelSize: listItem.titleSize
                color: listItem.titleColor
            }

            Label {
                id: subText
                text: (model.subtitle)?model.subtitle:''
                font.weight: listItem.subtitleWeight
                font.pixelSize: listItem.subtitleSize
                color: listItem.subtitleColor

                visible: text != ""
            }
        }
    }

    MouseArea {
        id: mouse_area
        anchors.fill: parent
        onClicked: {
            listItem.clicked();
        }
    }
}

