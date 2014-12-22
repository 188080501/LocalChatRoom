import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.2
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2

Item
{
    id: settingsPage;

    function hear(message, name, icon)
    {
        talkBox.append("(" + icon + ")" + name + ": " + message);
    }

    function titleChange(title)
    {
        textTitle.text = title;
    }

    Rectangle
    {
        id: mainRoom
        width: mainWindow.width;
        height: mainWindow.height;
        z: 60;
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        color: "transparent"

        Rectangle
        {
            x: 0;
            y: 0;
            z: -9;
            width: parent.width;
            height: 45;
            color: "#f7f7f8";
        }

        Rectangle
        {
            x: 0;
            y: 44;
            z: -9;
            width: parent.width;
            height: 1;
            color: "#a7a7ab";
        }

        Rectangle
        {
            x: 0;
            y: 0;
            z: -10;
            width: parent.width;
            height: parent.height;
            color: "#efeff4"
        }

        Text
        {
            id: textTitle
            width: mainWindow.width;
            height: 45
            anchors.horizontalCenterOffset: 0
            z: -8
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 20
            text: qsTr("设置");
        }

        Button
        {
            id: buttonExit
            width: 80
            height: 45
            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            z: 2

            Text
            {
                anchors.centerIn: parent;
                text: qsTr("返回");
                color: (parent.pressed) ? ("#c5def9") : ("#0091ff")
                font.pixelSize: 20
            }

            style: ButtonStyle
            {
                background: Rectangle
                {
                    color: "transparent";
                }
            }

            onClicked:
            {
                settingsPage.visible = false;
            }
        }

        TextField
        {
            id: textFieldUserName
            x: 110
            y: 178
            width: 150
            height: 30
            anchors.verticalCenterOffset: -30
            anchors.horizontalCenterOffset: 13
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            placeholderText: qsTr("请输入用户名")

            onTextChanged:
            {
                settings.setUserName(textFieldUserName.text);
            }
        }

        ComboBox
        {
            id: comboBoxUserIcon
            x: 98
            y: 257
            width: 150
            height: 26
            anchors.verticalCenterOffset: 30
            anchors.horizontalCenterOffset: 13
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter

            model: ListModel
            {
                ListElement { text: "默认头像"; }
                ListElement { text: "头像1"; }
                ListElement { text: "头像2"; }
                ListElement { text: "头像3"; }
                ListElement { text: "头像4"; }
                ListElement { text: "头像5"; }
                ListElement { text: "头像6"; }
            }

            onCurrentIndexChanged:
            {
                settings.setUserIcon(comboBoxUserIcon.currentIndex);
            }
        }

        onVisibleChanged:
        {
            textFieldUserName.text = settings.userName();
            comboBoxUserIcon.currentIndex = settings.userIcon();
        }

        MouseArea
        {
            z: -1;
            anchors.fill: parent;
            onClicked:
            { }
        }

        Text {
            id: text1
            width: 50
            height: 30
            text: qsTr("昵称: ")
            anchors.top: textFieldUserName.bottom
            anchors.topMargin: -30
            anchors.left: textFieldUserName.right
            anchors.leftMargin: -205
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignRight
            font.pixelSize: 15
        }

        Text {
            id: text2
            width: 50
            height: 26
            text: qsTr("头像: ")
            anchors.top: comboBoxUserIcon.bottom
            anchors.topMargin: -26
            anchors.left: comboBoxUserIcon.right
            anchors.leftMargin: -205
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignRight
            font.pixelSize: 15
        }
    }
}
