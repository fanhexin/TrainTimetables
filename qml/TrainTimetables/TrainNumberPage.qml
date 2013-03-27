// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "ui"
import "./UIConstants.js" as UI

Page {
    id: me
    orientationLock: PageOrientation.LockPortrait
    tools: common_tools
    property alias header_text: header.content
    property int ret_cnt:0
    property bool bPop: true

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
            icon: "../img/train_header_icon.png"
        }

        SearchBar {
            id: find_bar
            placeholderText: '请输入车次号'
            onTextChanged: {
                ret_cnt = 0;
                if (find_bar.text.charAt(0) == '%' || find_bar.text.charAt(0) == '_')
                    return;

                if (find_bar.text)
                    train_list.model_refresh(find_bar.text);
                else {
                    train_list.model_clear();
                }
            }
        }

        SeparatorHLine {}
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
            var ret = timetable.getTrainInfo(filter);
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
            var tmp = Qt.createComponent('./ui/FavoriteMenu.qml');
            var dlg = tmp.createObject(me, {'filter': filter});
            dlg.open();
        }
    }

    ScrollDecorator {
        flickableItem: train_list
    }

    onStatusChanged: {
        if (status == PageStatus.Active && bPop) {
            bPop = false;
            find_bar.text_fild_focus();
        }
    }
}
