// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "ui"
import "./UIConstants.js" as UI

Page {
    id: me
    orientationLock: PageOrientation.LockPortrait

    property alias header_text: header.content
    property string startStation
    property string endStation
    property int ret_cnt:0

    tools: ToolBarLayout {
        id: common_tools
        visible: false

        ToolIcon {
            iconId: "toolbar-back"
            onClicked: {
                pageStack.pop();
            }
        }

//        ToolIcon {
//            iconId: "toolbar-share"
//            onClicked: {
//                Qt.openUrlExternally('mailto:?subject='+header.content+'&body='+format_share_msg());
//            }
//        }
    }

    FilterDialog {
        id: filter_dlg
        onAccepted: {
            train_list.model_refresh();
        }
    }

    Column {
        id: col

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        SelectHeader {
            id: header
            color: UI.HEADER_COLOR
            onClickHeader: {
                filter_dlg.open();
            }
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

        section.property: "title"
        section.criteria: ViewSection.FirstCharacter
        section.delegate: SectionItem {
            width: parent.width
            text: section
        }


        onModelLoad: {
            var ret = timetable.getTrainsBetweenStations(startStation, endStation);
            ret_cnt += ret.length;
            for (var i = 0; i < ret.length; i++) {
                var regexp = make_filter_reg(filter_dlg.selectedIndexes);
                if (regexp && ret[i].ID.match(RegExp(regexp, "g"))) {
                    ret_cnt--;
                    continue;
                }

                var title = ret[i].ID+' '+ret[i].Type;
                var subtitle = [{title:ret[i].startStation+'->'+ret[i].endStation+
                        ', '+ret[i].Distance+'km, '+ minute_to_hour(ret[i].R_Date)}];
                var startTitle = ret[i].sStation+': '+((ret[i].sA_Time=='始发站')?ret[i].sD_Time:ret[i].sA_Time);
                train_list.model.append({
                                           title: title,
                                           subtitle: subtitle,
                                            filter: ret[i].ID+','+minute_to_hour(parseInt(ret[i].Interval))+','+ret[i].sStation+','+ret[i].eStation,
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
                betweenStationTime: arr[1]
            };
            goto_page("TrainDetailPage.qml", param);
        }

        onItemPressAndHold: {
            var tmp = Qt.createComponent('./ui/FavoriteMenu.qml');
            var dlg = tmp.createObject(me, {'filter': filter.split(',')[0]});
            dlg.open();
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

    FastScroll {
        listView: train_list
    }

    Component.onCompleted: init()

    function init() {
        train_list.model_load();
    }

    function format_share_msg() {
        var line = '共'+ret_cnt+'条结果\n\n';

        for (var i = 0; i < train_list.model.count; i++) {
            line += (train_list.model.get(i).title +'\n');
            line += (train_list.model.get(i).subtitle.get(0).title + '\n');
            line += ('(' + train_list.model.get(i).notice.get(0).cnt + ') ' +
                     train_list.model.get(i).notice.get(0).title +
                     '--->' + train_list.model.get(i).filter.split(',')[1] + '\n');
            line += ('(' + train_list.model.get(i).notice.get(1).cnt + ') ' + train_list.model.get(i).notice.get(1).title + '\n\n');
        }
        return line;
    }
}
