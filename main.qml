import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.2
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import LocalChatRoom 1.0

ApplicationWindow
{
    id: mainWindow
    title: qsTr("LocalChatRoom")
    width: 320
    height: 548
    visible: true

    property Component component: Qt.createComponent("Room.qml");

    Settings
    {
        id: settings;
    }

    Rectangle
    {
        id: centerWidget;
    }

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
        text: qsTr("首页");
    }

    ListView
    {
        id: doorplateList
        x: 0
        width: mainWindow.width;
        height: mainWindow.height - 45;
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 45
        clip: true
        delegate: Item
        {
            width: 320;
            height: 60;
            Doorplate
            { }
        }
        model: ListModel
        {
            id: listModel;
            Component.onCompleted:
            {
                listModel.append({"itemText": "1号房间",  "itemColor": "#00ff00", "itemPort" : 23450});
                listModel.append({"itemText": "2号房间",  "itemColor": "#ff0000", "itemPort" : 23451});
                listModel.append({"itemText": "3号房间",  "itemColor": "#0000ff", "itemPort" : 23452});
                listModel.append({"itemText": "4号房间",  "itemColor": "#f0f000", "itemPort" : 23453});
                listModel.append({"itemText": "5号房间",  "itemColor": "#a1a1a1", "itemPort" : 23454});
                listModel.append({"itemText": "6号房间",  "itemColor": "#00f0f0", "itemPort" : 23455});
                listModel.append({"itemText": "7号房间",  "itemColor": "#123456", "itemPort" : 23456});
                listModel.append({"itemText": "8号房间",  "itemColor": "#f0000f", "itemPort" : 23457});
                listModel.append({"itemText": "9号房间",  "itemColor": "#0f00f0", "itemPort" : 23458});
                listModel.append({"itemText": "10号房间", "itemColor": "#900900", "itemPort" : 23459});
            }
        }
    }

    Button
    {
        id: buttonSettings
        width: 80
        height: 45
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0

        Text
        {
            anchors.centerIn: parent;
            text: qsTr("设置");
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
            settingsPage.visible = true;
        }
    }

    SettingsPage
    {
        id: settingsPage;
        visible: false;
    }
}
