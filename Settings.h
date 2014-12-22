#ifndef __Settings_h__
#define __Settings_h__

// Qt lib import
#include <QObject>
#include <QSettings>
#include <QSharedPointer>
#include <QDir>

class Settings: public QObject
{
    Q_OBJECT

private:
    QString m_UserName;
    int m_UserIcon;

public:
    Settings(void);

    ~Settings(void);

public slots:
    QString userName(void) const;

    int userIcon(void) const;

    void setUserName(const QString &UserName);

    void setUserIcon(const int &UserIcon);

private:
    QSettings *getSettinges(const QString &GroupName, const QString &FileName);
};

#endif//__Settings_h__
