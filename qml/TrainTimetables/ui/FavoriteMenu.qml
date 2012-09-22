// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0

Menu {
    property string filter
    signal addToFavorite(string filter)
    MenuLayout {
        MenuItem { text: "加入收藏夹"; onClicked: addToFavorite(filter)}
    }
}
