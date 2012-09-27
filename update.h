#ifndef UPDATE_H
#define UPDATE_H

#include <QtCore>
#include <QtNetwork>
#include "macro.h"

class Update : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString ver READ ver NOTIFY verChanged)
public:
    explicit Update(QSettings *setting, QObject *parent = 0);
    Q_INVOKABLE void check(void);
    Q_INVOKABLE void get(void);
    Q_INVOKABLE void cancelCheck();
    Q_INVOKABLE void cancelUpdate();
    Q_INVOKABLE void revert();
    QString ver() const;
signals:
    void startUpdate();
    void endUpdate();
    void needUpdate(QString ver, QString size);
    void noUpdate();
    void error();
    void downloadProgress(qint64 bytesReceived, qint64 bytesTotal);
    void verChanged();
public slots:
    void readVer();
    void readDB();
private:
    uint m_ver;
    bool m_bCancelUpdate;
    bool m_bCancelCheck;
    QSettings *m_setting;
    QNetworkReply *m_check_reply;
    QNetworkReply *m_get_reply;
    QNetworkAccessManager m_manager;
};

#endif // UPDATE_H
