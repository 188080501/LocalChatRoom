#ifndef __Communication_h__
#define __Communication_h__

// Qt lib import
#include <QObject>
#include <QtConcurrent>
#include <QUdpSocket>
#include <QTcpSocket>
#include <QTcpServer>
#include <QNetworkAddressEntry>

class Communication: public QObject
{
    Q_OBJECT

private:
    QUdpSocket m_UdpClient;
    QUdpSocket m_UdpServer;
    QTcpServer m_TcpServer;

    QNetworkAddressEntry m_NetworkAddressEntry;
    quint16 m_Port;

    int m_AvailableLast = -1;
    QMap<quint32, quint32> m_Available;
    QString m_Name;

public:
    Communication(void);

public slots:
    void setPort(const quint16 &Port);

    void setName(const QString &Name);

    bool listen(void);

    void ping(void);

    void rename(const QString &Name);

    void talk(const QString &Message, const QString &UserName, const int &UserIcon);

    void sendUdp(const QByteArray &Data);

    static void sendTcp(const QHostAddress &IP, const quint16 &Port, const QByteArray &Data);

    QString name(void) const;

    int available(void) const;

private:
    void timerEvent(QTimerEvent *);

    QNetworkAddressEntry getNetworkAddressEntry(void);

private slots:
    void acceptedUDP(void);

    void acceptedTCP(void);

    void refreshAvailable(void);

signals:
    void titleChange(const QString Name);

    void availableChange(const int Available);

    void hear(const QString Message, const QString UserName, const int UserIcon, const bool Self);
};

#endif//__Communication_h__
