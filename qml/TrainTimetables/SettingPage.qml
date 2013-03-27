// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "ui"
import "./UIConstants.js" as UI

Page {
    id: me
    orientationLock: PageOrientation.LockPortrait
    tools: common_tools
//在手动调用update的cancel操作时，设置为false则不会弹出出错提示
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
            icon: "../img/settings_header_icon.png"
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
                Row {
                    id: database_row
                    spacing: 10
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
                            text: update.ver
                            font.weight: Font.Light
                            font.pixelSize: 22
                            color: theme.inverted ? "#d2d2d2" : "#505050"
                        }
                    }

                    Image {
                        source: "image://theme/"+(theme.inverted ?"icon-m-textinput-combobox-arrow":"icon-m-common-combobox-arrow")
                    }
                }

                Rectangle {
                    id: background
                    z: -1
                    anchors.fill: database_row
                    color: '#2A8EE0'
                    visible: mouse_area.pressed
                }

                MouseArea {
                    id: mouse_area
                    anchors.fill: database_row
                    onClicked: {
                        var tmp = Qt.createComponent('./ui/AlarmDlg.qml');
                        var dlg = tmp.createObject(me, {
                                                       title_text: '警告',
                                                       title_img: "image://theme/icon-l-error",
                                                       content_text: '是否确定回退数据库到最初版本?'
                                                   });
                        dlg.accepted.connect(function() {
                                                 update.revert();
                                                 show_info_bar("数据库回退成功");
                                               });
                        dlg.open();
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
                            update.cancelUpdate();
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
                text: '帮助'
                width: parent.width
                user_margin: 0
                font_pixelSize: 26
                onClick: goto_page("HelpPage.qml")
            }
        }
    }

    Timer {
        id: timer
        interval: 20*1000
        onTriggered: {
            show_info_bar('连接超时');
            bErr = false;
            update.cancelCheck();
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
                    database_row.visible = false;
                    background.enabled = false;
                    mouse_area.enabled = false;
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
                    database_row.visible = true;
                    background.enabled = true;
                    mouse_area.enabled = true;
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
                                           title_text: '数据库更新',
                                           title_img: "image://theme/icon-m-low-power-mode-system-update",
                                           content_text: '<p>版本: '+ver+'</p><p>大小: '+size+'</p><p>是否更新?</p>'
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
                show_info_bar('数据库更新完成');
            }
        }

        onError: {
            if (me.state == "showPBar")
                me.state = "hidePBar";
            else if(me.state == "showIndicator")
                me.state = "hideIndicator";

            if (!bErr) {
                bErr = true;
                return;
            }
//            console.log(err);
            show_info_bar('发生错误');
        }
    }
}
