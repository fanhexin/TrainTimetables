import QtQuick 1.1
import com.nokia.meego 1.0

PageStackWindow {
    id: appWindow

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
                theme.inverted = !theme.inverted;
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
}
