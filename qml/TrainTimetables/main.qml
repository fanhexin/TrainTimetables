import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.0

PageStackWindow {
    id: appWindow

    InfoBanner{
        id: info_banner
        topMargin: 40
        timerShowTime: 2*1000
        z: 1
    }

    ToolBarLayout {
        id: common_tools
        visible: false

        ToolIcon {
            iconId: "toolbar-back"
            onClicked: {
                pageStack.pop();
            }
        }
        ToolIcon {
            iconId: "toolbar-edit"
            onClicked: {
                update.get();
            }
        }
    }

    initialPage: MainPage{}

    function goto_page(path, param) {
        if (!arguments.length) {
            console.log('Error!');
            return;
        }

        if (arguments.length == 1) {
            pageStack.push(Qt.resolvedUrl(path));
        }else if(arguments.length == 2){
            pageStack.push(Qt.resolvedUrl(path), param);
        }
    }

    function get_station(filter, model) {
        var ret = timetable.getStation(filter);
        for (var i = 0; i < ret.length; i++) {
            var title = ret[i].Station;
            model.append({
                           title: title,
                           filter: title
                       });
        }
        return ret.length;
    }

    function show_info_bar(text) {
        info_banner.text = text;
        info_banner.show();
    }

    function init() {
        theme.inverted = (setting.value("dark_theme").toString() == "true")?true:false;
    }

    Component.onCompleted: init()
}
