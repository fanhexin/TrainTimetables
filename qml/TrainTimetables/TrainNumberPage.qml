// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "ui"
import "./UIConstants.js" as UI

Page {
    orientationLock: PageOrientation.LockPortrait
    tools: common_tools
    property string method: "getTrainInfo"
    property bool bLoadOnInit: false
    property string condition
    property alias header_text: header.content
    property int ret_cnt
    property bool bAutoSoftKeyboard: true

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
            content: '车次查询'
        }

        SearchBar {
            id: find_bar
            visible: !bLoadOnInit
            placeholderText: '请输入车次号'
            onTextChanged: {
                if (find_bar.text)
                    train_list.model_refresh(find_bar.text);
                else {
                    ret_cnt = 0;
                    train_list.model_clear();
                }
            }
        }

        SeparatorHLine {visible: !bLoadOnInit}
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
            var ret = timetable[method](filter);
            ret_cnt = ret.length;
            for (var i = 0; i < ret.length; i++) {
                var param = {
                    title: ret[i].ID+' '+ret[i].Type,
                    subtitle: [{title:ret[i].startStation+'->'+ret[i].endStation+', '+ret[i].Distance+'km, '+ minute_to_hour(ret[i].R_Date)}],
                    filter: ret[i].ID
                };
                if (ret[i].A_Time) {
                    param.notice = [
                                {
                                    title: filter+': '+(ret[i].A_Time=='始发站'?ret[i].D_Time:ret[i].A_Time),
                                    cnt: ret[i].Day
                                }
                            ];
                }
                train_list.model.append(param);
            }
        }

        onItemClicked: {
            var param = {
                train_id: filter
            };

            if (condition) {
                param.startStation = condition;
            }
            goto_page("TrainDetailPage.qml", param);
        }
    }

    onStatusChanged: {
        if (status == PageStatus.Active) {
            if (bAutoSoftKeyboard) {
                bAutoSoftKeyboard = false;
                find_bar.text_fild_focus();
            }
        }
    }

    Component.onCompleted: {
        if (bLoadOnInit) {
            train_list.model_load(condition);
        }
    }
}
