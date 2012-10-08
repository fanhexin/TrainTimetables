// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "ui"
import "./UIConstants.js" as UI

Page {
    orientationLock: PageOrientation.LockPortrait
    tools: common_tools

    Header {
        id: header
        color: UI.HEADER_COLOR
        content: '帮助'
    }

    Flickable {
        anchors {
            top: header.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            leftMargin: UI.NORMAL_MARGIN
            rightMargin: UI.NORMAL_MARGIN
        }
        clip: true
        contentHeight: help_text.height

        Label {
            id: help_text
            width: parent.width
            text: "<h3>1.站站查询</h3>
<pre><code>   通过起始站和终点站选择界面选择站
点点击查询即可。站点选择界面输入框支
持站点的全部拼音和首字母简写，同样支
持站点的全部和部分汉字。输入之后下面
会显示相关的站点，从中选择想要的，然
后点击确定即可完成输入。例如若想输入
'北京'，只需在输入框中输入字母bj或者
全部拼音beijing(不区分大小写),也可
只输入'北'，结果里会显示所有'北'开头
的站点，更可以输入完整的'北京'，结果
中会显示所有'北京'开头的站点，如北京
北、北京西等。
</code></pre>
<h3>2.车次查询</h3>
<pre><code>   直接在输入框中输入车次信息即可完
成查询。当只输入车次的部分信息时，结
果列表中会显示所有相关的列车。例如输
入'D'即会显示所有D字头的列车。
</code></pre>
<h3>3.车站查询</h3>
<pre><code>   在输入框中输入站点信息列表中即会
显示所有相关的站点(输入方式同站站查
询)，点击目的站点，就会显示所有途径
该站点的列车。
</code></pre>
<h3>4.收藏</h3>
<pre><code>   在三种查询功能查询结果列表上，通
过长按任意一个条目均会弹出菜单，在菜
单中选择'加入收藏夹'即可完成收藏。也
可通过点击列车详细信息界面工具栏里的
五角星型图标完成车次收藏。在主界面点
击'收藏夹'，可查看收藏夹中所有列车。
点击收藏夹工具栏里的垃圾桶型图标可清
空收藏夹，通过长按任意收藏车次，在弹
出菜单中选择删除即可删除单个条目。
</code></pre>
<h3>5.过滤</h3>
<pre><code>   站站查询和车站查询的查询结果界面
可进行过滤操作。方法为点击标题栏，此
时会弹出过滤操作列表，列表中显示所有
列车类型，如'动车'、'特快'等。从中选
择欲过滤掉的列车类型(可多选),点击'确
定'按钮即可。
</code></pre>
<h3>6.数据库更新</h3>
<pre><code>   在设置界面中点击'检查更新'按钮可
检测是否有新的数据库更新，根据接下来
的提示操作即可。
</code></pre>
<h3>7.数据库回退</h3>
<pre><code>   点击数据库版本文字，会弹出警告回
退数据库的对话框，点击确认即回退数据
库到最初版本。部分用户在更新数据库后
出现了无法查询的情况，此时即可通过回
退数据库然后再次更新解决。
</code></pre>"
        }
    }
}
