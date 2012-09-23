// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "../Data.js" as DATA

Menu {
    id: menu
    property string filter
    MenuLayout {
        MenuItem {
            text: "加入收藏夹"
            onClicked: {
                if (DATA.favorite_isExist(menu.filter)) {
                    show_info_bar('该列车已收藏!');
                    return;
                }

                DATA.favorite_insert([menu.filter, '']);
                show_info_bar('收藏成功');
            }
        }
    }
}
