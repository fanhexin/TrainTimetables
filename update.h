#ifndef UPDATE_H
#define UPDATE_H

#include <QtCore>
#include <QtNetwork>

class Update : public QObject
{
    Q_OBJECT
public:
    explicit Update(QSettings *setting, QObject *parent = 0);
    Q_INVOKABLE void check(void);
    Q_INVOKABLE void get(void);
    Q_INVOKABLE void cancel();
    Q_INVOKABLE QString getFormatVer();
signals:
    void startUpdate();
    void endUpdate();
    void needUpdate(QString ver, QString size);
    void noUpdate();
    void error();
    void downloadProgress(qint64 bytesReceived, qint64 bytesTotal);
public slots:
    void readVer();
    void readDB();
private:
    uint m_ver;
    bool m_bCancelUpdate;
    QSettings *m_setting;
    QNetworkReply *m_check_reply;
    QNetworkReply *m_get_reply;
    QNetworkAccessManager m_manager;
};

#endif // UPDATE_H
