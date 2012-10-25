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
    ~TrainsInfo();

    QVariantList get(const QString &sql);
signals:
    
public slots:
    QVariantList getTrain(const QString &id);
    QVariantList getTrainsByStation(const QString &station);
    QVariantList getTrainsBetweenStations(const QString &from, const QString &to);
//    QVariantList getTrainsBSOneStop(const QString &from, const QString &to);
    QVariantList getTrainInfo(const QString &id);
    QVariantList getProvince();
    QVariantList getProvince(const QString &filter);
    QVariantList getStation(const QString &filter);
    QVariantList getTrainStation(const QString &id, const QString &station);
    QVariantList getTrainInfoInSection(const QString &section);

    void closeDB();
    void changeDB();
private:
    QSqlDatabase m_db;
    QSettings *m_setting;
};

#endif // TRAINSINFO_H
