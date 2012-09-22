// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0

MultiSelectionDialog {
    titleText: "列车类型过滤"
    selectedIndexes: []
    model: ListModel {
        ListElement { name: "高铁(G)" }
        ListElement { name: "动车(D)" }
        ListElement { name: "直达(Z)" }
        ListElement { name: "特快(T)" }
        ListElement { name: "快速(K)" }
        ListElement { name: "临客(L)" }
        ListElement { name: "城际(C)" }
        ListElement { name: "旅游(Y)" }
        ListElement { name: "普通" }
    }

    platformStyle: SelectionDialogStyle{
        itemSelectedBackgroundColor: '#2A8EE0'
    }

    acceptButtonText: "确定"
}
