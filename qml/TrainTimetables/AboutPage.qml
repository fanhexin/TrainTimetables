// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "ui"
import "./UIConstants.js" as UI

Page {
    orientationLock: PageOrientation.LockPortrait
    tools: common_tools

    Header {
        id: header
        color: UI.HEADER_COLOR
        content: '关于列车时刻表'
    }

    Flickable {
        anchors {
            top: header.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        clip: true
        contentHeight: col.height

        Image {
            id: logo
            anchors {
                top: parent.top
                horizontalCenter: parent.horizontalCenter
                topMargin: UI.NORMAL_MARGIN
            }
            source: "./img/about_logo.png"
        }

        Column {
            id: col
            anchors {
                top: logo.bottom
                left: parent.left
                right: parent.right
                margins: UI.SMALL_MARGIN
            }
            spacing: UI.NORMAL_MARGIN

            Label {
                width: parent.width
                wrapMode: 'WordWrap'
                text: '"列车时刻表"是用于查询全国列车时刻的N9原生应用，采用离线数据，无需联网。数据库不定期更新，可通过设置界面检测并下载最新离线数据库。如发现数据库信息错误和软件bug或者想要提出功能建议，可在新浪微博<span style="color:steelblue;">@追梦人</span>，或者点击以下邮件地址发送电子邮件。'
            }

            Label {
                text: 'Email: <a href="mailto:fanhexin@gmail.com">fanhexin@gmail.com</a>'
                onLinkActivated: {
                    Qt.openUrlExternally(link);
                }
            }
        }
    }
}
