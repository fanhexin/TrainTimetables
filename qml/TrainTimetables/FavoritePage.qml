// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "ui"
import "./UIConstants.js" as UI
import "./Data.js" as DATA

Page {
    id: me
    property int ret_cnt
    property bool bReload: false

    orientationLock: PageOrientation.LockPortrait
    tools: ToolBarLayout {
        visible: false

        ToolIcon {
            iconId: "toolbar-back"
            onClicked: {
                pageStack.pop();
            }
        }

        ToolIcon {
            iconId: "toolbar-delete"
            onClicked: {
                var tmp = Qt.createComponent('./ui/AlarmDlg.qml');
                var dlg = tmp.createObject(me, {
                                               title_text: '警告',
                                               title_img: "image://theme/icon-l-error",
                                               content_text: '确定要清空收藏夹吗?'
                                           });
                dlg.accepted.connect(function() {
                                         DATA.favorite_clear();
                                         train_list.model.clear();
                                         ret_cnt = 0;
                                       });
                dlg.open();
            }
        }
    }

    Menu {
        id: del_menu
        property int index
        MenuLayout {
            MenuItem {
                text: "删除"
                onClicked: {
                    ret_cnt--;
                    DATA.favorite_del(train_list.model.get(del_menu.index).filter);
                    train_list.model.remove(del_menu.index);
                }
            }
        }
    }

    Column {
        id: col

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        Header {
            id: header
            color: UI.HEADER_COLOR
            content: '收藏夹'
        }
    }

    CommonList {
        id: train_list
        anchors {
            top: col.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        header: MsgBar {
            id: msg_bar
            width: parent.width
            text: '共'+ret_cnt+'条结果'
        }

        delegate: ListDelegate {
            Image {
                source: "image://theme/icon-m-common-drilldown-arrow" + (theme.inverted ? "-inverse" : "")
                anchors.right: parent.right;
                anchors.verticalCenter: parent.verticalCenter
            }
            onClicked: train_list.itemClicked(filter)
            onPressAndHold: train_list.itemPressAndHold(index)
        }

        onModelLoad: {
            var ret = timetable.getTrainInfoInSection(DATA.favorite_get());
            ret_cnt = ret.length;

            for (var i = 0; i < ret.length; i++) {
                var param = {
                    title: ret[i].ID+' '+ret[i].Type,
                    subtitle: [{title:ret[i].startStation+'->'+ret[i].endStation+', '+ret[i].Distance+'km, '+ minute_to_hour(ret[i].R_Date)}],
                    filter: ret[i].ID
                };
                train_list.model.append(param);
            }
        }

        onItemClicked: {
            goto_page("TrainDetailPage.qml", {
                          train_id: filter
                      });
        }

        onItemPressAndHold: {
            del_menu.index = filter;
            del_menu.open();
        }
    }
//在查看收藏夹的列车详细信息界面取消收藏后，回退到收藏夹界面需要刷新
    onStatusChanged: {
        if (status == PageStatus.Active && bReload) {
            train_list.model_refresh();
        }
    }

    Component.onCompleted: {
        train_list.model_load();
        bReload = true;
    }
}
