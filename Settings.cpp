#include "Settings.h"

Settings::Settings(void)
{
    QSharedPointer<QSettings> settings(getSettinges("LocalChatRoom", "User"));

    settings->beginGroup("User");

    m_UserName = settings->value("UserName").toString();
    m_UserIcon = settings->value("UserIcon").toInt();

    if(m_UserName.isEmpty())
    {
        m_UserName = QStringLiteral("未命名用户");
    }

    settings->endGroup();
}

Settings::~Settings(void)
{
    QSharedPointer<QSettings> settings(getSettinges("LocalChatRoom", "User"));

    settings->beginGroup("User");

    settings->setValue("UserName", m_UserName);
    settings->setValue("UserIcon", m_UserIcon);

    settings->endGroup();
}

QString Settings::userName(void) const
{
    return m_UserName;
}

int Settings::userIcon(void) const
{
    return m_UserIcon;
}

void Settings::setUserName(const QString &UserName)
{
    m_UserName = UserName;
}

void Settings::setUserIcon(const int &UserIcon)
{
    m_UserIcon = UserIcon;
}

QSettings *Settings::getSettinges(const QString &GroupName, const QString &FileName)
{
#ifdef Q_OS_MAC
#   ifdef Q_OS_IOS
    QDir Dir = QDir::tempPath();
    Dir.cdUp();
    Dir.cd("Documents");
    return new QSettings(Dir.path() + "/com.Jason" + ((GroupName.isEmpty()) ? ("") : ("." + GroupName)) + "/" + FileName, QSettings::IniFormat);
#   else
    QDir Dir = QDir::tempPath();
    Dir.cdUp();
    Dir.cd("C");
    return new QSettings(Dir.path() + "/com.Jason" + ((GroupName.isEmpty()) ? ("") : ("." + GroupName)) + "/" + FileName, QSettings::IniFormat);
#   endif
#endif

#ifdef Q_OS_ANDROID
    return new QSettings("/sdcard/Jason_" + GroupName + "/" + FileName, QSettings::IniFormat);
#endif

#ifdef Q_OS_WIN
    return new QSettings("HKEY_CURRENT_USER\\Software\\com_Jason" + ((GroupName.isEmpty()) ? ("") : ("_" + GroupName)) + "\\" + FileName, QSettings::NativeFormat);
#endif

    return new QSettings(QDir::currentPath() + "/Jason_" + GroupName + "/" + FileName, QSettings::IniFormat);
}
