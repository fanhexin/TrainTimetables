import QtQuick 1.1
import com.nokia.meego 1.0
import "ui"
import "./UIConstants.js" as UI

Page {
    orientationLock: PageOrientation.LockPortrait
    Header {
        id: header
        color: UI.HEADER_COLOR
        content: '列车时刻表'
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
        Column {
            id: col
            width: parent.width
            ItemBtn {
                text: '站站查询'
                describe: '查询经过起始站和终点站的列车'
                onClick: goto_page("StationFromToPage.qml")
            }

            ItemBtn {
                text: '车次查询'
                describe: '通过车次查询列车的详细信息'
                onClick: goto_page("TrainNumberPage.qml")
            }

            ItemBtn {
                text: '车站查询'
                describe: '查询经过指定车站的所有列车'
                onClick: goto_page("StationPage.qml")
            }

            ItemBtn {
                text: '设置'
                onClick: goto_page("SettingPage.qml")
            }
        }
    }
}
