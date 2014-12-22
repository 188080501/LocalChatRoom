import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.2
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.1

Item
{
    id: room;

    signal talk(string message);
    signal exitRoom();

    function hear(message, name, icon, self)
    {
        var time = new Date;
        talkBoxListModel.append({"message": message, "name": name, "icon": icon, "self": self});
//        talkBox.positionViewAtEnd();
        if(talkBoxListModel.count > 500)
        {
            talkBoxListModel.remove(0);
        }
        talkBox.currentIndex = talkBox.count - 1;
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
            y: parent.height - 50;
            z: -9;
            width: parent.width;
            height: 50;
            color: "#f3f3f3";
        }

        Rectangle
        {
            x: 0;
            y: parent.height - 50;
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
            z: 1
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 20
        }

        Button
        {
            id: buttonExit
            width: 80
            height: 45
            z: 2

            Text
            {
                anchors.centerIn: parent;
                text: qsTr("退出");
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
                room.exitRoom();
                room.visible = false;
                room.destroy(200);
            }
        }

        ListView
        {
            id: talkBox
            x: 8
            y: 44
            width: mainWindow.width - 18;
            height: mainWindow.height - 96;
            clip: true
            delegate: Item
            {
                width: mainWindow.width - 18;
                height: 50
                Image
                {
                    x: (self) ? (parent.width - 30) : (0);
                    y: 10;
                    width: 30
                    height: 30;
                    fillMode: Image.Stretch
                    source: "/UserIcon" + String(icon) + ".jpg";
                }
                Text
                {
                    x: (self) ? (0) : (40);
                    y: 5;
                    width: mainWindow.width - 18 - 40;
                    height: 20;
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: (self) ? (Text.AlignRight) : (Text.AlignLeft);

                    Component.onCompleted:
                    {
                        var time = new Date;
                        text = name + "(" + time.toTimeString() + ")";
                    }
                }
                Text
                {
                    x: (self) ? (0) : (40);
                    y: 25;
                    width: mainWindow.width - 18 - 40;
                    height: 20;
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: (self) ? (Text.AlignRight) : (Text.AlignLeft);
                    text: message;
                }
            }
            model: ListModel
            {
                id: talkBoxListModel;
            }
        }

        TextField
        {
            id: readySend
            x: 10
            y: 45 + talkBox.height + 12;
            width: mainWindow.width - 82;
            height: 30

            onTextChanged:
            {
                buttonSend.enabled = text != String("");
            }

            Keys.onReturnPressed:
            {
                if(readySend.text != String(""))
                {
                    room.talk(readySend.text);
                    readySend.text = "";
                }
            }

            style: TextFieldStyle
            {
                background: Rectangle
                {
                    radius: 5
                    color: "#fafafa"
                    border.width: 1;
                    border.color: "#c8c8cd";
                }
            }
        }

        Button
        {
            id: buttonSend
            x: readySend.width + 20;
            y: readySend.y - 1;
            width: 50
            height: 30
            enabled: false;

            Text
            {
                anchors.centerIn: parent;
                text: qsTr("发送");
                font.bold: true;
                color: (parent.enabled) ? ((parent.pressed) ? ("#c6eed4") : ("#00cc47")) : ("#8e8e93")
                font.pixelSize: 20
            }

            onClicked:
            {
                if(readySend.text != String(""))
                {
                    room.talk(readySend.text);
                    readySend.text = "";
                }
            }

            style: ButtonStyle
            {
                background: Rectangle
                {
                    color: "transparent";
                }
            }
        }

        MouseArea
        {
            z: -1;
            anchors.fill: parent;
            onClicked:
            { }
        }
    }
}
