// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "ui"
import "./UIConstants.js" as UI

Page {
    id: me
    orientationLock: PageOrientation.LockPortrait
    tools: common_tools

    property bool bErr: true

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
            content: '设置'
        }
    }

    Flickable {
        anchors {
            top: col.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            leftMargin: UI.NORMAL_MARGIN
            rightMargin: UI.NORMAL_MARGIN
        }
        clip: true

        contentHeight: cfg_content.height

        Column {
            id: cfg_content
            width: parent.width
            anchors.top: parent.top
            anchors.topMargin: UI.NORMAL_MARGIN
            spacing: UI.NORMAL_MARGIN

            Item {
                width: parent.width
                height: database_col.height
                Column {
                    id: database_col
                    Label {
                        text: '数据库版本'
                        font.weight: Font.Bold
                        font.pixelSize: 26
                        color: theme.inverted ? "#ffffff" : "#282828"
                    }

                    Label {
                        id: ver_label
                        text: update.getFormatVer()
                        font.weight: Font.Light
                        font.pixelSize: 22
                        color: theme.inverted ? "#d2d2d2" : "#505050"
                    }
                }

                ProgressBar {
                    id: progressBar
                    anchors.verticalCenter: parent.verticalCenter
                    visible: false
                    width: parent.width - update_btn.width - 20
                }

                BusyIndicator {
                     id: indicator
                     anchors {
                         right: update_btn.left
                         verticalCenter: parent.verticalCenter
                     }
                     visible: false
                     running: true
                     platformStyle: BusyIndicatorStyle { size: "medium" }
                }

                Button {
                    id: update_btn
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    width: 150
                    text: '检查更新'
                    onClicked: {
                        if (me.state != 'showPBar') {
                            update.check();
                            me.state = "showIndicator";
                        }else{
                            bErr = false;
                            update.cancel();
                        }
                    }
                }
            }

            Column {
                width: parent.width
                Label {
                    text: '主题'
                    font.weight: Font.Bold
                    font.pixelSize: 26
                    color: theme.inverted ? "#ffffff" : "#282828"
                }

                ButtonRow {
                    width: parent.width
                    Button {
                        text: 'Light'
                        checked: !theme.inverted
                        onClicked: {
                            theme.inverted = false;
                            setting.setValue("dark_theme", "false");
                        }
                    }

                    Button {
                        text: 'Dark'
                        checked: theme.inverted
                        onClicked: {
                            theme.inverted = true;
                            setting.setValue("dark_theme", "true");
                        }
                    }
                }
            }

            ItemBtn {
                text: '意见反馈'
                width: parent.width
                user_margin: 0
                font_pixelSize: 26
                onClick: {
                    Qt.openUrlExternally('mailto:fanhexin@gmail.com');
                }
            }

            ItemBtn {
                text: '关于'
                width: parent.width
                user_margin: 0
                font_pixelSize: 26
                onClick: goto_page("AboutPage.qml")
            }
        }
    }

    Timer {
        id: timer
        interval: 20*1000
        onTriggered: {
            show_info_bar('连接超时');
            update.cancel();
            me.state = 'hideIndicator';
        }
    }

    states: [
        State {
            name: "showPBar"

            StateChangeScript {
                script: {
                    progressBar.value = 0;
                    progressBar.visible = true;
                    database_col.visible = false;
                    update_btn.text = '取消';
                }
            }
        },
        State {
            name: "hidePBar"

            StateChangeScript {
                script: {
                    progressBar.value = 0;
                    progressBar.visible = false;
                    database_col.visible = true;
                    update_btn.text = '检查更新';
                }
            }
        },
        State {
            name: "showIndicator"

            StateChangeScript {
                script: {
                    timer.start();
                    indicator.visible = true;
                    update_btn.enabled = false;
                }
            }
        },
        State {
            name: "hideIndicator"

            StateChangeScript {
                script: {
                    timer.stop();
                    indicator.visible = false;
                    update_btn.enabled = true;
                }
            }
        }
    ]

    Connections {
        target: update

        onNoUpdate: {
            me.state = "hideIndicator";
            show_info_bar('数据库已经是最新版本');
        }

        onNeedUpdate: {
            me.state = "hideIndicator";
            var tmp = Qt.createComponent('./ui/AlarmDlg.qml');
            var dlg = tmp.createObject(me, {
                                           title_text: '更新',
                                           title_img: "image://theme/icon-m-low-power-mode-system-update",
                                           content_text: '<p>已经有新版数据库了！</p><p>总大小'+size+'是否更新?</p>'
                                       });
            dlg.accepted.connect(function() {
                                     me.state = "showPBar";
                                     update.get();
                                   });
            dlg.open();
        }

        onDownloadProgress: {
            progressBar.maximumValue = bytesTotal;
            progressBar.value = bytesReceived;
            if (bytesTotal == bytesReceived) {
                me.state = "hidePBar";
                ver_label.text = update.getFormatVer();
                show_info_bar('数据库更新完成');
            }
        }

        onError: {
            me.state = "hidePBar";
            if (!bErr) {
                bErr = true;
                return;
            }
            show_info_bar('发生错误更新失败');
        }
    }
}
