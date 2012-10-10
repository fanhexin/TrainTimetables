#ifndef TRAINSINFO_H
#define TRAINSINFO_H

#include <QtCore>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlRecord>
#include "macro.h"

class TrainsInfo : public QObject
{
    Q_OBJECT
public:
    explicit TrainsInfo(QSettings *setting, QObject *parent = 0);
    Q_INVOKABLE QVariantList getTrain(const QString &id);
    Q_INVOKABLE QVariantList getTrainsByStation(const QString &station);
    Q_INVOKABLE QVariantList getTrainsBetweenStations(const QString &from, const QString &to);
//    Q_INVOKABLE QVariantList getTrainsBSOneStop(const QString &from, const QString &to);
    Q_INVOKABLE QVariantList getTrainInfo(const QString &id);
    Q_INVOKABLE QVariantList getProvince();
    Q_INVOKABLE QVariantList getProvince(const QString &filter);
    Q_INVOKABLE QVariantList getStation(const QString &filter);
    Q_INVOKABLE QVariantList getTrainStation(const QString &id, const QString &station);
    Q_INVOKABLE QVariantList getTrainInfoInSection(const QString &section);
    QVariantList get(const QString &sql);
signals:
    
public slots:
    void closeDB();
    void changeDB();
private:
    QSqlDatabase m_db;
    QSettings *m_setting;
};

#endif // TRAINSINFO_H
