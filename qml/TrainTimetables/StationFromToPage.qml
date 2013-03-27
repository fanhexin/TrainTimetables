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
            icon: "../img/railroad_header_icon.png"
        }
    }

    Image {
        anchors {
            top: col.bottom
            topMargin: 20
            horizontalCenter: parent.horizontalCenter
        }

        asynchronous: true
        source: "./img/Train_clip_art_medium.png"
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
            var param = {};
            if (multi_selc.startStation != '请选择') {
                param.station = multi_selc.startStation;
            }

            var tmp = Qt.createComponent("./ui/StationPicker.qml");
            var sheet = tmp.createObject(me, param);
            sheet.accept.connect(function(filter) {
                                     multi_selc.startStation = filter;
                                 });
            sheet.open();
        }

        onClickEndBtn: {
            var param = {};
            if (multi_selc.endStation != '请选择') {
                param.station = multi_selc.endStation;
            }

            var tmp = Qt.createComponent("./ui/StationPicker.qml");
            var sheet = tmp.createObject(me, param);
            sheet.accept.connect(function(filter) {
                                     multi_selc.endStation = filter;
                                 });
            sheet.open();

        }

        onClickSearchBtn: {
            if (multi_selc.startStation == '请选择' || multi_selc.endStation == '请选择') {
                return;
            }
            setting.setValue('startStation', startStation);
            setting.setValue('endStation', endStation);
            goto_page("TrainBetweenStationsPage.qml", {
                          startStation: multi_selc.startStation,
                          endStation: multi_selc.endStation,
                          header_text: '从'+multi_selc.startStation+'到'+multi_selc.endStation
                      });
        }

        Component.onCompleted: {
            if (setting.contains('startStation'))
                startStation = setting.value('startStation').toString();
            if (setting.contains('endStation'))
                endStation = setting.value('endStation').toString();
        }
    }
}
