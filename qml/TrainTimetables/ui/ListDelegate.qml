// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.0
import "../UIConstants.js" as UI

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

    Loader {
        anchors {
            top: row.top
            left: parent.left
        }
        sourceComponent: (model.highlight)?highlight_com:null
    }

    Row {
        id: row
        width: parent.width  - UI.NORMAL_MARGIN
        anchors.centerIn: parent
        spacing: 18

        Loader {
            sourceComponent: model.iconSource?icon_com:null
        }

        Column {
            Row {
                Loader {
                    sourceComponent: (model.cnt)?cnt_com:null
                }

                Label {
                    id: mainText
                    text: model.title
                    font.weight: listItem.titleWeight
                    font.pixelSize: listItem.titleSize
                    color: listItem.titleColor
                }
            }

            Loader {
                sourceComponent: model.subtitle?subTitle_com:null
            }

            Loader {
                sourceComponent: (model.notice)?notice_com:null
            }
        }
    }

    Component {
        id: interval_com
        Row {
            spacing: UI.SMALL_MARGIN
            Image {
                asynchronous: true
                source: "../img/train_time.png"
            }

            Label {
                text: minute_to_hour(model.filter.split(',')[1])
                font.weight: listItem.subtitleWeight
                font.pixelSize: listItem.subtitleSize
                color: listItem.subtitleColor
            }
        }
    }

    Component {
        id: icon_com

        Image {
            anchors.verticalCenter: parent.verticalCenter
            width: 64
            height: 64
            source: model.iconSource
        }
    }

    Component {
        id: subTitle_com
        Row {
            spacing: 10
            Repeater {
                model: subtitle.count
                Label {
                    text: subtitle.get(index).title
                    font.weight: listItem.subtitleWeight
                    font.pixelSize: listItem.subtitleSize
                    color: listItem.subtitleColor
                }
            }
        }
    }

    Component {
        id: highlight_com
        Rectangle {
            z: -2
            width: 5
            height: row.height
            color: "#42D809"
        }
    }

    Component {
        id: cnt_com

        CountBubble {
            value: model.cnt
            largeSized: true
        }
    }

    Component {
        id: notice_com
        Row {
            spacing: UI.SMALL_MARGIN
            Column {
                spacing: 2
                Repeater {
                    model: notice.count
                    Row {
                        id: notice_row
                        visible: noticeCntBubble.value
                        spacing: 5
                        Rectangle {
                            width: 5
                            height: notice_row.height
                            color: "#42D809"
                        }

                        CountBubble {
                            id: noticeCntBubble
                            value: notice.get(index).cnt
                            largeSized: true
                        }

                        Label {
                            text: notice.get(index).title
                            font.weight: listItem.subtitleWeight
                            font.pixelSize: listItem.subtitleSize
                            color: listItem.subtitleColor
                        }
                    }
                }
            }

            Item {
                height: parent.height
                width: interval_loader.width
                Loader {
                    id: interval_loader
                    anchors.verticalCenter: parent.verticalCenter
                    sourceComponent: (model.notice.count==2)?interval_com:null
                }
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

