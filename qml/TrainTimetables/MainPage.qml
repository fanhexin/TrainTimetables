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
        icon: "../img/main_header_icon.png"
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
                iconSource: "../img/" + (theme.inverted?"railroad_white.png":"railroad.png")
                onClick: goto_page("StationFromToPage.qml")
            }

            ItemBtn {
                text: '车次查询'
                describe: '通过车次查询列车的详细信息'
                iconSource: "../img/" + (theme.inverted?"train_white.png":"train.png")
                onClick: goto_page("TrainNumberPage.qml")
            }

            ItemBtn {
                text: '车站查询'
                describe: '查询经过指定车站的所有列车'
                iconSource: "../img/" + (theme.inverted?"station_white.png":"station.png")
                onClick: goto_page("StationPage.qml")
            }

            ItemBtn {
                text: '收藏夹'
                describe: '查看管理收藏夹中的列车'
                iconSource: "../img/" + (theme.inverted?"favorite_white.png":"favorite.png")
                onClick: goto_page("FavoritePage.qml")
            }

            ItemBtn {
                text: '设置'
                describe: '进行数据库更新、修改主题等'
                iconSource: "../img/" + (theme.inverted?"settings_white.png":"settings.png")
                onClick: goto_page("SettingPage.qml")
            }
        }
    }
}
