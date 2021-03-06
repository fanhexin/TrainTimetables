// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.0

Sheet {
    property int ret_cnt:0
    property alias station: find_bar.text
    signal accept(string filter)

    acceptButtonText: "确定"
    rejectButtonText: "取消"

    title: Label{
        id: title_label
        anchors.centerIn: parent
        text:'选择站点'
    }

    content: Item {
        anchors.fill: parent
        Column {
            id: col
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }

            SearchBar {
                id: find_bar
                placeholderText: '请输入站点名称(支持拼音或首字母)'

                onTextChanged: {
                    if (find_bar.text.charAt(0) == '%' || find_bar.text.charAt(0) == '_')
                        return;

                    if (find_bar.text)
                        list_view.model_refresh(find_bar.text);
                    else {
                        ret_cnt = 0;
                        list_view.model_clear();
                    }
                }
            }

            SeparatorHLine {}
        }

        SingleSelectList {
            id: list_view
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
                    list_view.model.append({
                                               title: title,
                                               filter: title,
                                               highlight: false
                                           });
                }
            }
            Label {
                visible: !ret_cnt
                opacity: 0.5
                anchors.centerIn: parent
                font.pixelSize: 65
                font.weight: Font.Light
                text: '在结果中选择'
            }
        }

        ScrollDecorator {
            flickableItem: list_view
        }
    }

    onAccepted: {
        var obj = list_view.model.get(list_view.currentIndex);
        var station = (obj)?obj.title:find_bar.text;
        if (station)
            accept(station);
    }
    onStatusChanged: {
        if (status == 1) {
            find_bar.text_fild_focus();
        }
    }
}
