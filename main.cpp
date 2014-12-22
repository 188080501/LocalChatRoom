#include <QApplication>
#include <QQmlApplicationEngine>
#include <QtQml>
#include <QSystemTrayIcon>
#include "Communication.h"
#include "Settings.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    qmlRegisterType<Communication>("LocalChatRoom", 1, 0, "Communication");
    qmlRegisterType<Settings>("LocalChatRoom", 1, 0, "Settings");

    QThreadPool::globalInstance()->setMaxThreadCount(5);

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
