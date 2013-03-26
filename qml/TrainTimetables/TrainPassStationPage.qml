// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "ui"
import "./UIConstants.js" as UI

Page {
    id: me
    orientationLock: PageOrientation.LockPortrait
    tools: ToolBarLayout {
        id: common_tools
        visible: false

        ToolIcon {
            iconId: "toolbar-back"
            onClicked: {
                pageStack.pop();
            }
        }

//        ToolIcon {
//            iconId: "toolbar-share"
//            onClicked: {
//                Qt.openUrlExternally('mailto:?subject='+header.content+'&body='+format_share_msg());
//            }
//        }
    }

    property string condition
    property alias header_text: header.content
    property int ret_cnt:0

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

        section.property: "title"
        section.criteria: ViewSection.FirstCharacter
        section.delegate: SectionItem {
            width: parent.width
            text: section
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
            dlg.open();
        }
    }

    FastScroll {
        listView: train_list
    }

    Component.onCompleted: {
        train_list.model_load(condition);
    }

    function format_share_msg() {
        var line = '共'+ret_cnt+'条结果\n\n';

        for (var i = 0; i < train_list.model.count; i++) {
            line += (train_list.model.get(i).title +'\n');
            line += (train_list.model.get(i).subtitle.get(0).title + '\n');
            line += ('(' + train_list.model.get(i).notice.get(0).cnt + ') ' + train_list.model.get(i).notice.get(0).title + '\n\n');
        }
        return line;
    }
}
