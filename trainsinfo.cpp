#include "trainsinfo.h"

TrainsInfo::TrainsInfo(const QString &db_name, QObject *parent) :
    QObject(parent)
{
    m_db = QSqlDatabase::addDatabase("QSQLITE");
    m_db.setDatabaseName(db_name);
    if ( !m_db.open()) {
        qDebug() << "open error!";
    }
}

QVariantList TrainsInfo::getTrain(const QString &id)
{
    return get("SELECT * FROM Train WHERE ID LIKE '"+id+"%'");
}

QVariantList TrainsInfo::getTrainsByStation(const QString &station)
{
    return get("SELECT b.* FROM Train AS a,TrainList As b WHERE a.ID=b.ID AND a.Station LIKE '"+station+"%'");
}

QVariantList TrainsInfo::getTrainsBetweenStations(const QString &from, const QString &to)
{
    return get("select a.ID from Train as a,Train as b where (a.Station LIKE '"+from+"%' AND b.Station LIKE '"+to+"%') AND a.S_No<b.S_No AND a.ID=b.ID");
}

QVariantList TrainsInfo::getTrainInfo(const QString &id)
{
    return get("SELECT * FROM TrainList WHERE ID LIKE '"+id+"%'");
}

QVariantList TrainsInfo::get(const QString &sql)
{
    QVariantList list;
    QVariantMap obj;
    QSqlQuery query;

    query.exec(sql);
    QSqlRecord rec = query.record();
    while (query.next()) {
        for (int i = 0; i < rec.count(); i++) {
            obj.insert(rec.fieldName(i), query.value(i));
        }
        list.append(obj);
        obj.clear();
    }
    return list;
}
