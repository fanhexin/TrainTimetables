// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "ui"
import "./UIConstants.js" as UI

Page {
    id: me
    orientationLock: PageOrientation.LockPortrait
    tools: common_tools

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
            content: '站站查询'
        }
    }

    MultiSelcBar {
        id: multi_selc
        anchors {
            top: col.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        onClickStartBtn: {
            var tmp = Qt.createComponent("./ui/StationPicker.qml");
            var sheet = tmp.createObject(me);
            sheet.accept.connect(function(filter) {
                                     multi_selc.startStation = filter;
                                 });
            sheet.open();
        }

        onClickEndBtn: {
            var tmp = Qt.createComponent("./ui/StationPicker.qml");
            var sheet = tmp.createObject(me);
            sheet.accept.connect(function(filter) {
                                     multi_selc.endStation = filter;
                                 });
            sheet.open();

        }

        onClickSearchBtn: {
            if (multi_selc.startStation == '请选择' || multi_selc.endStation == '请选择') {
                return;
            }

            goto_page("TrainBetweenStationsPage.qml", {
                          startStation: multi_selc.startStation,
                          endStation: multi_selc.endStation,
                          header_text: '从'+multi_selc.startStation+'到'+multi_selc.endStation
                      });
        }
    }
}
