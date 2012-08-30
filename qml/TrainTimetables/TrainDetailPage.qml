// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "ui"
import "./UIConstants.js" as UI

Page {
    orientationLock: PageOrientation.LockPortrait
    tools: common_tools
    property alias header_text: header.content
    property string train_id

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
            content: '车次详细信息'
        }

        SeparatorHLine {}
    }

    CommonList {
        id: list
        anchors {
            top: col.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        onModelLoad: {
            var ret = timetable.getTrain(filter);
            for (var i = 0; i < ret.length; i++) {
                list.model.append({
                                      title: ret[i].Station+'  '+ret[i].A_Time+'~'+ret[i].D_Time,
                                      subtitle: '硬座: '+ret[i].P1+'  '+'软座: '+ret[i].P2+'\n'+
                                                '硬卧: '+ret[i].P3+'  '+'软卧: '+ret[i].P4,
                                      filter: ret[i].Station
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
