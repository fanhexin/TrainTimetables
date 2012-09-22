import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.0
import "ui"
import "./Data.js" as DATA

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

    function show_info_bar(text) {
        info_banner.text = text;
        info_banner.show();
    }

    function minute_to_hour(minutes) {
        var hour = Math.floor(minutes/60);
        var ret = (hour)?hour+'h':'';
        var minute = minutes%60;
        ret += (minute)?minute+'m':'';
        return ret;
    }

    function make_filter_reg(selc_indexs) {
        if (!selc_indexs.length)
            return null;

        var ret = '^[';
        var tmp = ['G', 'D', 'Z', 'T', 'K', 'L', 'C', 'Y', '0-9'];
        for (var i = 0; i < selc_indexs.length; i++) {
            ret += tmp[selc_indexs[i]];
        }
        ret += '].*';
        return ret;
    }

    function init() {
        theme.inverted = (setting.value("dark_theme").toString() == "true")?true:false;
        DATA.init();
    }

    Component.onCompleted: init()
}
