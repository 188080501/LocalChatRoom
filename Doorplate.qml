import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.2
import QtGraphicalEffects 1.0
import QtQuick.Controls.Styles 1.2
import QtGraphicalEffects 1.0
import LocalChatRoom 1.0

Item
{
    id: doorplate;

    property bool inTalk: false;
    property var room;

    signal titleChange(string title);

    function sendMessage(message)
    {
        communication.talk(message, settings.userName(), settings.userIcon());
    }

    function exitRoom()
    {
        doorplate.inTalk = false;
        console.log(itemPort + ": Out");

        doorplate.room.talk.disconnect(doorplate.sendMessage);
        doorplate.room.exitRoom.disconnect(doorplate.exitRoom);
        doorplate.titleChange.disconnect(doorplate.room.titleChange);
        communication.hear.disconnect(doorplate.room.hear);
    }

    function refreshTitle()
    {
        if(communication.available())
        {
            textTitle.text = communication.name() + "(" + communication.available() + qsTr("人在线)");
        }
        else
        {
            textTitle.text = communication.name() + qsTr("(无人)");
        }
        doorplate.titleChange(textTitle.text);
    }

    Rectangle
    {
        x: 10;
        y: 5;
        width: mainWindow.width - 20;
        height: 60;
        color: "transparent";

        Communication
        {
            id: communication;
            Component.onCompleted:
            {
                communication.setPort(itemPort);
                communication.setName(itemText);
                communication.listen();
                refreshTitle();
            }
            onTitleChange:
            {
                console.log(itemPort + ": " + "NameChange: " + Name);
                refreshTitle();
            }
            onAvailableChange:
            {
                console.log(itemPort + ": " + "AvailableChange: " + Available);
                refreshTitle();
            }
        }

        Timer
        {
            interval: 500;
            repeat: true;
            triggeredOnStart: true;

            Component.onCompleted:
            {
                start();
            }

            onTriggered:
            {
                if(doorplate.inTalk)
                {
                    communication.ping();
                }
            }
        }

        Item
        {
            id: container;
            anchors.fill: parent;

            Rectangle
            {
                id: mainRect;
                width: container.width   - (2 * rectShadow.radius);
                height: container.height - (2 * rectShadow.radius);
                anchors.centerIn: parent;

                // Main rect
                Text
                {
                    id: textTitle
                    x: 33
                    y: 0
                    text: itemText;
                    color: itemColor;
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 25
                    anchors.fill: parent;
                }

                Button
                {
                    anchors.fill: parent;
                    style: ButtonStyle
                    {
                        background: Rectangle
                        {
                            color: "transparent";
                        }
                    }

                    onClicked:
                    {
                        doorplate.inTalk = true;
                        console.log(itemPort + ": In");

                        if(mainWindow.component.status == Component.Ready)
                        {
                            doorplate.room = mainWindow.component.createObject(mainWindow);

                            doorplate.room.talk.connect(doorplate.sendMessage);
                            doorplate.room.exitRoom.connect(doorplate.exitRoom);
                            doorplate.titleChange.connect(doorplate.room.titleChange);
                            doorplate.titleChange(textTitle.text);
                            communication.hear.connect(doorplate.room.hear);
                        }
                    }
                }
            }
        }
        DropShadow
        {
            id: rectShadow;
            anchors.fill: container
            cached: true;
            horizontalOffset: 0;
            verticalOffset: 3;
            radius: 8.0;
            samples: 16;
            color: "#50000000";
            smooth: true;
            source: container;
        }
    }
}
