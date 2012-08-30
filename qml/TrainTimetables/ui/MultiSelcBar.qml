// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.0
import "../UIConstants.js" as UI

Item {
    property alias startStation: start_btn.text
    property alias endStation: end_btn.text

    signal clickStartBtn()
    signal clickEndBtn()
    signal clickSearchBtn()

    Column {
        anchors.centerIn: parent
        spacing: 20

        SeparatorHLine{}
        Row {
            spacing: 20
            Label {
                id: start_label
                text: '出发站：'
            }

            TumblerButton {
                id: start_btn
                width: 480 - start_label.width -60
                text: '请选择'
                onClicked: clickStartBtn()
            }
        }

        Row {
            spacing: 20
            Label {
                id: end_label
                text: '到达站：'
            }

            TumblerButton {
                id: end_btn
                width: 480 - end_label.width -60
                text: '请选择'
                onClicked: clickEndBtn()
            }
        }

        Row {
            spacing: 20
            Button {
                id: exchange_btn
                width: end_label.width
                iconSource: "../img/exchange_btn_icon"+(theme.inverted?"_invert.png":".png")
                onClicked: {
                    var tmp = start_btn.text;
                    start_btn.text = end_btn.text;
                    end_btn.text = tmp;
                }
            }

            Button {
                width: 480 - exchange_btn.width -60
                text: '查询'
                onClicked: clickSearchBtn()
            }
        }

        SeparatorHLine{}
    }
}
