// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "ui"
import "./UIConstants.js" as UI

Page {
    orientationLock: PageOrientation.LockPortrait
    tools: common_tools
    property alias header_text: header.content
    property string startStation
    property string endStation
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
            var ret = timetable.getTrainsBetweenStations(startStation, endStation);
            ret_cnt = ret.length;
            for (var i = 0; i < ret.length; i++) {
                var title = ret[i].ID+' '+ret[i].Type;
                var subtitle = [{title:ret[i].startStation+'->'+ret[i].endStation+
                        ', '+ret[i].Distance+'km, '+ minute_to_hour(ret[i].R_Date)}];
                var startTitle = ret[i].sStation+': '+((ret[i].sA_Time=='始发站')?ret[i].sD_Time:ret[i].sA_Time);
                train_list.model.append({
                                           title: title,
                                           subtitle: subtitle,
                                            filter: ret[i].ID+','+ret[i].Interval+','+ret[i].sStation+','+ret[i].eStation,
                                            notice: [
                                                        {
                                                            title: startTitle,
                                                            cnt: ret[i].sDay
                                                        },
                                                        {
                                                            title: ret[i].eStation+': '+ret[i].eA_Time,
                                                            cnt: ret[i].eDay
                                                        }
                                                    ]
                                       });
            }
        }

        onItemClicked: {
            var arr = filter.split(',');
            var param = {
                train_id: arr[0],
                startStation: arr[2],
                endStation: arr[3],
                betweenStationTime: minute_to_hour(parseInt(arr[1]))
            };
            goto_page("TrainDetailPage.qml", param);
        }

        Label {
            visible: !ret_cnt
            opacity: 0.5
            anchors.centerIn: parent
            font.pixelSize: 80
            font.weight: Font.Light
            text: '无直达列车'
        }
    }

    Component.onCompleted: init()

    function init() {
        train_list.model_load();
    }
}
