// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "ui"
import "./UIConstants.js" as UI
import "./Data.js" as DATA

Page {
    id: me
    orientationLock: PageOrientation.LockPortrait
    tools: common_tools

    property string condition
    property alias header_text: header.content
    property int ret_cnt

    FilterDialog {
        id: filter_dlg
        onAccepted: {
            train_list.model_refresh(condition);
        }
    }

    Column {
        id: col

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        SelectHeader {
            id: header
            color: UI.HEADER_COLOR
            content: '车次查询'
            onClickHeader: {
                filter_dlg.open();
            }
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

        onModelLoad: {
            var ret = timetable.getTrainsByStation(filter);
            ret_cnt = ret.length;

            for (var i = 0; i < ret.length; i++) {
                var regexp = make_filter_reg(filter_dlg.selectedIndexes);
                if (regexp && ret[i].ID.match(RegExp(regexp, "g"))) {
                    ret_cnt--;
                    continue;
                }

                var param = {
                    title: ret[i].ID+' '+ret[i].Type,
                    subtitle: [{title:ret[i].startStation+'->'+ret[i].endStation+', '+ret[i].Distance+'km, '+ minute_to_hour(ret[i].R_Date)}],
                    filter: ret[i].ID + ',' + ret[i].Station,
                    notice: [
                                {
                                    title: ret[i].Station+': '+(ret[i].A_Time=='始发站'?ret[i].D_Time:ret[i].A_Time),
                                    cnt: ret[i].Day
                                }
                            ]
                };

                train_list.model.append(param);
            }
        }

        onItemClicked: {
            var arr = filter.split(',');
            goto_page("TrainDetailPage.qml", {
                          train_id: arr[0],
                          startStation: arr[1]
                      });
        }

        onItemPressAndHold: {
            var tmp = Qt.createComponent('./ui/FavoriteMenu.qml');
            var dlg = tmp.createObject(me, {'filter': filter.split(',')[0]});
            dlg.addToFavorite.connect(function(filter) {
                                          DATA.favorite_insert([filter, '']);
                                          show_info_bar('添加收藏');
                                      });
            dlg.open();
        }
    }

    Component.onCompleted: {
        train_list.model_load(condition);
    }
}
