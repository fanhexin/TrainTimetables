#ifndef SETTINGS_H
#define SETTINGS_H

#include <QtCore>

class Settings : public QObject
{
    Q_OBJECT
public:
    explicit Settings(QSettings *setting, QObject *parent = 0);
    Q_INVOKABLE QVariant value(const QString &key);
    Q_INVOKABLE void setValue(const QString &key, const QVariant &value);
    Q_INVOKABLE void clear();
    Q_INVOKABLE bool contains(const QString &key);
signals:
    
public slots:

private:
    QSettings *m_setting;
};

#endif // SETTINGS_H
