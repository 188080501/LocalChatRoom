#include "Communication.h"

Communication::Communication(void)
{
    this->startTimer(500);

    m_Port = 0;
    m_NetworkAddressEntry = getNetworkAddressEntry();

    connect(&m_UdpServer, SIGNAL(readyRead()), this, SLOT(acceptedUDP()));
    connect(&m_TcpServer, SIGNAL(newConnection()), this, SLOT(acceptedTCP()));
}

void Communication::setPort(const quint16 &Port)
{
    m_Port = Port;
}

void Communication::setName(const QString &Name)
{
    m_Name = Name;
}

bool Communication::listen(void)
{
    return m_UdpServer.bind(QHostAddress::Any, m_Port) && m_TcpServer.listen(QHostAddress::Any, m_Port);
}

void Communication::ping(void)
{
    QJsonObject Data;
    Data.insert("Type", "Ping");
    Data.insert("Ip", QString::number(m_NetworkAddressEntry.ip().toIPv4Address()));

    this->sendUdp(QJsonDocument(Data).toJson());
}

void Communication::rename(const QString &Name)
{
    QJsonObject Data;
    Data.insert("Type", "Rename");
    Data.insert("Name", Name);

    const QByteArray buf(QJsonDocument(Data).toJson());

    for(QMap<quint32, quint32>::iterator Now = m_Available.begin(); Now != m_Available.end(); Now++)
    {
        QtConcurrent::run(Communication::sendTcp, QHostAddress(Now.key()), m_Port, buf);
    }
}

void Communication::talk(const QString &Message, const QString &UserName, const int &UserIcon)
{
    QJsonObject Data;
    Data.insert("Type", "Message");
    Data.insert("Message", Message);
    Data.insert("UserName", UserName);
    Data.insert("UserIcon", UserIcon);
    Data.insert("IP", m_NetworkAddressEntry.ip().toString());

    const QByteArray buf(QJsonDocument(Data).toJson());

    for(QMap<quint32, quint32>::iterator Now = m_Available.begin(); Now != m_Available.end(); Now++)
    {
        QtConcurrent::run(Communication::sendTcp, QHostAddress(Now.key()), m_Port, buf);
    }
}

void Communication::sendUdp(const QByteArray &Data)
{
    m_UdpClient.writeDatagram(Data, m_NetworkAddressEntry.broadcast(), m_Port);
}

void Communication::sendTcp(const QHostAddress &IP, const quint16 &Port, const QByteArray &Data)
{
    QTcpSocket Socket;
    Socket.connectToHost(IP, Port);
    if(!Socket.waitForConnected(3000))
    {
        return;
    }

    Socket.write(Data);
    Socket.waitForBytesWritten(3000);
}

QString Communication::name(void) const
{
    return m_Name;
}

int Communication::available(void) const
{
    return m_Available.size();
}

void Communication::timerEvent(QTimerEvent *)
{
    this->refreshAvailable();
}

QNetworkAddressEntry Communication::getNetworkAddressEntry(void)
{
    auto allInterfaces = QNetworkInterface::allInterfaces();

    // Scan en0
    for(const auto &interface: allInterfaces)
    {
        if(interface.name().indexOf("en0") != -1)
        {
            for(const auto &entry: interface.addressEntries())
            {
                if(entry.ip().toIPv4Address())
                {
                    return entry;
                }
            }
        }
    }

    // Scan other
    for(const auto &interface: allInterfaces)
    {
        for(const auto &entry: interface.addressEntries())
        {
            if(entry.ip().toIPv4Address())
            {
                if(entry.ip().toString().indexOf("10.0.") == 0)
                {
                    return entry;
                }
                else if(entry.ip().toString().indexOf("192.168.") == 0)
                {
                    return entry;
                }
            }
        }
    }

    return QNetworkAddressEntry();
}

void Communication::acceptedUDP(void)
{
    while(m_UdpServer.hasPendingDatagrams())
    {
        QByteArray datagram;

        datagram.resize(m_UdpServer.pendingDatagramSize());
        m_UdpServer.readDatagram(datagram.data(), datagram.size());

        QJsonObject Data = QJsonDocument::fromJson(datagram).object();
        if(Data.value("Type").toString() == "Ping")
        {
            m_Available.insert(Data.value("Ip").toString().toUInt(), QDateTime::currentDateTime().toTime_t());
        }
    }
}

void Communication::acceptedTCP(void)
{
    QTcpSocket *socket = m_TcpServer.nextPendingConnection();

    socket->waitForReadyRead(3000);
    QByteArray buf = socket->readAll();

    socket->deleteLater();

    QJsonObject Data = QJsonDocument::fromJson(buf).object();

    if(Data.value("Type").toString() == "Message")
    {
        emit hear(Data.value("Message").toString(), Data.value("UserName").toString(), Data.value("UserIcon").toInt(), Data.value("IP").toString() == m_NetworkAddressEntry.ip().toString());
    }
    else if(Data.value("Type").toString() == "Rename")
    {
        m_Name = Data.value("Name").toString();

        emit titleChange(m_Name);
    }
}

void Communication::refreshAvailable(void)
{
    for(QMap<quint32, quint32>::iterator Now = m_Available.begin(); Now != m_Available.end(); Now++)
    {
        if((QDateTime::currentDateTime().toTime_t() - Now.value()) > 3)
        {
            m_Available.erase(Now);
            this->refreshAvailable();
            return;
        }
    }

    if(m_Available.size() != m_AvailableLast)
    {
        m_AvailableLast = m_Available.size();
        emit availableChange(m_Available.size());
    }
}
