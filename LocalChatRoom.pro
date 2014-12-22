TEMPLATE = app

QT += qml quick widgets network concurrent

CONFIG += c++11

SOURCES += main.cpp \
    Communication.cpp \
    Settings.cpp

RESOURCES += qml.qrc \
    UserIcon/UserIcon.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    Communication.h \
    Settings.h

INCLUDEPATH += \
    ./JasonQt
