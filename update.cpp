#include "update.h"

Update::Update(QSettings *setting, QObject *parent) :
    QObject(parent),
    m_setting(setting)
{
    m_bCancelUpdate = false;
    m_bCancelCheck = false;
    m_ver = m_setting->value("ver").toUInt();
}

void Update::check(void)
{
    m_check_reply = m_manager.get(QNetworkRequest(QUrl("http://chinese-timetable-db.googlecode.com/svn/trunk/ver.txt")));

    connect(m_check_reply, SIGNAL(error(QNetworkReply::NetworkError)),
            this, SIGNAL(error()));

    connect(m_check_reply, SIGNAL(finished()), this, SLOT(readVer()));
}

void Update::get(void)
{
    m_get_reply = m_manager.get(QNetworkRequest(QUrl("http://chinese-timetable-db.googlecode.com/svn/trunk/trains.db.gz")));
    connect(m_get_reply, SIGNAL(finished()), this, SLOT(readDB()));

    connect(m_get_reply, SIGNAL(downloadProgress(qint64,qint64)),
            this, SIGNAL(downloadProgress(qint64,qint64)));

    connect(m_get_reply, SIGNAL(error(QNetworkReply::NetworkError)), this, SIGNAL(error()));
}

void Update::cancelUpdate()
{
    m_bCancelUpdate = true;
    m_get_reply->abort();
}

void Update::cancelCheck()
{
    m_bCancelCheck = true;
    m_check_reply->abort();
}

QString Update::getFormatVer()
{
    QDateTime time;
    time.setTime_t(m_ver);
    return time.toString(Qt::DefaultLocaleShortDate);
}

void Update::readVer()
{
    if (m_bCancelCheck) {
        m_bCancelCheck = false;
        return;
    }

    QString data = m_check_reply->readAll();
    if (!data.size())
        return;

    QStringList list = data.split('\n');

    m_ver = list[0].toUInt();
    if (m_ver != m_setting->value("ver").toUInt()) {
        emit needUpdate(getFormatVer(), list[1]);
    }else{
        emit noUpdate();
    }
}

void Update::readDB()
{
    if (m_bCancelUpdate) {
        m_bCancelUpdate = false;
        return;
    }

    QByteArray data = m_get_reply->readAll();
    if (!data.size())
        return;

    QDir dir;
    if (!dir.exists("/home/user/.train")) {
        dir.mkdir("/home/user/.train");
    }

    QString file_path = "/home/user/.train/trains.db.gz";
    QFile gz(file_path);
    if (!gz.open(QIODevice::ReadWrite)) {
        qDebug() << "QFile open error!";
        return;
    }
    gz.write(data);
    gz.close();

    emit startUpdate();
    QStringList arg;
    arg << "-f" << "-d" << file_path;
    QProcess *gzip = new QProcess(this);
    gzip->start("gzip", arg);
    connect(gzip, SIGNAL(finished(int)), this, SIGNAL(endUpdate()));

    m_setting->setValue("db_path", "/home/user/.train/trains.db");
    m_setting->setValue("ver", m_ver);
}
