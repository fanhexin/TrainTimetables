// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "ui"
import "./UIConstants.js" as UI

Page {
    orientationLock: PageOrientation.LockPortrait
    tools: common_tools
    property string train_id
    property string train_type
    property string train_distance
    property string train_times
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
            content: train_id +' '+train_type
        }
    }

    CommonList {
        id: list
        anchors {
            top: col.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        header: MsgBar {
            id: msg_bar
            width: parent.width
            text: '共'+ret_cnt+'站 '+'行程'+train_distance+'公里 '+'耗时'+train_times
        }

        onModelLoad: {
            var ret = timetable.getTrain(filter);
            ret_cnt = ret.length;
            train_type = ret[0].Type;
            train_distance = ret[ret.length-1].Distance;
            train_times = ret[ret.length-1].R_Date;
            for (var i = 0; i < ret.length; i++) {
                list.model.append({
                                      title: ret[i].Station+'  '+ret[i].A_Time+'~'+ret[i].D_Time,
                                      subtitle: '硬座: '+ret[i].P1+'  '+'软座: '+ret[i].P2+'\n'+
                                                '硬卧: '+ret[i].P3+'  '+'软卧: '+ret[i].P4,
                                      filter: ret[i].Station,
                                      highlight: ((startStation&&ret[i].Station.match(startStation) != null)||
                                                  (endStation&&ret[i].Station.match(endStation) != null))
                                  });
            }
        }

        onItemClicked: {
            goto_page("TrainNumberPage.qml", {
                          method: "getTrainsByStation",
                          bLoadOnInit: true,
                          condition: filter,
                          header_text: '经过'+filter+'的列车'
                      });
        }
    }

    Component.onCompleted: init()

    function init() {
        list.model_load(train_id);
    }
}
