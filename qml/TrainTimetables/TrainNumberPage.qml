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
    property variant condition
    property string from
    property string to
    property alias header_text: header.content
    property int ret_cnt

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

        MsgBar {
            id: msg_bar
            width: parent.width
            text: '共'+ret_cnt+'条结果'
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

        onModelLoad: {
            var ret = (method == "getTrainsBetweenStations")?timetable[method](from, to):timetable[method](filter);

            for (var i = 0; i < ret.length; i++) {
                var title = ret[i].ID+' '+ret[i].Type;
                var subtitle = ret[i].startStation+'->'+ret[i].endStation+' '+ret[i].Distance+'公里 '+ret[i].R_Date;
                train_list.model.append({
                                           title: title,
                                           subtitle: subtitle,
                                           filter: ret[i].ID
                                       });
            }
            ret_cnt = ret.length;
        }
    }

    Component.onCompleted: {
        if (bLoadOnInit) {
            train_list.model_load(condition);
        }
    }
}
