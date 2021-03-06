// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "ui"
import "./UIConstants.js" as UI

Page {
    orientationLock: PageOrientation.LockPortrait
    tools: common_tools
    property int ret_cnt:0
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
            content: '车站查询'
            icon: "../img/station_header_icon.png"
        }

        SearchBar {
            id: find_bar
            placeholderText: '请输入站点名称(支持拼音或首字母)'
            onTextChanged: {
                ret_cnt = 0;
                if (find_bar.text.charAt(0) == '%' || find_bar.text.charAt(0) == '_')
                    return;

                if (find_bar.text)
                    station_list.model_refresh(find_bar.text);
                else {
                    station_list.model_clear();
                }
            }
        }

        SeparatorHLine {}
    }

    CommonList {
        id: station_list
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
            var ret = timetable.getStation(filter);
            ret_cnt = ret.length;
            for (var i = 0; i < ret.length; i++) {
                var title = ret[i].Station;
                station_list.model.append({
                                           title: title,
                                           filter: title
                                       });
            }
        }

        onItemClicked: {
            goto_page("TrainPassStationPage.qml", {
                          condition: filter,
                          header_text: '经过'+filter+'的列车'
                      });
        }
    }

    ScrollDecorator {
        flickableItem: station_list
    }

    onStatusChanged: {
        if (status == PageStatus.Active) {
            if (bAutoSoftKeyboard) {
                bAutoSoftKeyboard = false;
                find_bar.text_fild_focus();
            }
        }
    }
}
