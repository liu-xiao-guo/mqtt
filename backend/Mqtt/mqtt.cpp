#include "mqtt.h"

MQTT::MQTT(QObject *parent) :
    QObject(parent)
{
    // re-initialize connection whenever the
    // host or the port changes
    QObject::connect(this, SIGNAL(hostChanged(QString)),
            this, SLOT(initializeConnection()));
    QObject::connect(this, SIGNAL(portChanged(int)),
            this, SLOT(initializeConnection()));
}


void MQTT::initializeConnection()
{
    qDebug() << "m_host: " << m_host;
    qDebug() << "m_port: " << m_port;

    DEBUG;
    if(m_host.isEmpty() || !m_port || m_topic.isEmpty())
    {
        DEBUG << "Please define a host and a port and a topic";
        // disconnect();
        return;
    }
    this->client = new QMQTT::Client(m_host, m_port);
    this->client->setClientId(QString(QUuid::createUuid().toString()));
    this->client->setUsername(m_username);
    this->client->setPassword(m_password);
    this->client->connect();
    QObject::connect(this->client, SIGNAL(received(const QMQTT::Message&)),
            this, SLOT(processReceivedMessage(const QMQTT::Message&)));
    QObject::connect(this->client, SIGNAL(connacked(quint8)),
                     this, SLOT(subscribeToTopic(quint8)));
    QObject::connect(this->client, SIGNAL(subscribed(QString)),
                     this, SLOT(subscribedToTopic(QString)));
    QObject::connect(this->client, SIGNAL(disconnected()),
                     this, SIGNAL(disconnected()));
}

QString MQTT::username() const
{
    return m_username;
}

void MQTT::setUsername(QString username)
{
    if (m_username != username) {
        m_username = username;
        emit usernameChanged(username);
    }
}

QString MQTT::password() const
{
    return m_password;
}

void MQTT::setPassword(QString password)
{
    if (m_password != password) {
        m_password = password;
        emit passwordChanged(password);
    }
}


