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
    m_check_reply = m_manager.get(QNetworkRequest(QUrl(UPDATE_CHECK_URL)));

    connect(m_check_reply, SIGNAL(error(QNetworkReply::NetworkError)),
            this, SIGNAL(error()));

    connect(m_check_reply, SIGNAL(finished()), this, SLOT(readVer()));
}

void Update::get(void)
{
    m_get_reply = m_manager.get(QNetworkRequest(QUrl(UPDATE_GET_URL)));
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

void Update::revert()
{
    emit startUpdate();
    m_ver = INIT_DB_VER;
    m_setting->setValue("ver", INIT_DB_VER);
    m_setting->setValue("db_path", INIT_DB_PATH);
    emit verChanged();
    emit endUpdate();
}

QString Update::ver() const
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
        emit needUpdate(ver(), list[1]);
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
    if (!dir.exists(DB_SAVE_PATH)) {
        dir.mkdir(DB_SAVE_PATH);
    }

    QString file_path = GZIP_DB_SAVE_PATH;
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

    m_setting->setValue("db_path", AFTER_UPDATE_DB_PATH);
    m_setting->setValue("ver", m_ver);
    emit verChanged();
}
