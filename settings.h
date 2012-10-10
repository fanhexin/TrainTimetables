#ifndef SETTINGS_H
#define SETTINGS_H

#include <QtCore>

class Settings : public QObject
{
    Q_OBJECT
public:
    explicit Settings(QSettings *setting, QObject *parent = 0);

signals:
    
public slots:
    QVariant value(const QString &key, const QVariant &defaultValue = QVariant());
    void setValue(const QString &key, const QVariant &value);
    void clear();
    bool contains(const QString &key);

private:
    QSettings *m_setting;
};

#endif // SETTINGS_H
