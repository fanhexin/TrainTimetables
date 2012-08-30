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
    return get("SELECT * FROM Train  WHERE ID LIKE '"+
               id+"%' COLLATE NOCASE");
}

QVariantList TrainsInfo::getTrainsByStation(const QString &station)
{
    return get("SELECT a.* FROM TrainList AS a,Train AS b WHERE b.Station LIKE '"+
               station+"%' AND b.ID=a.ID");
}

QVariantList TrainsInfo::getTrainsBetweenStations(const QString &from, const QString &to)
{
    return get("select c.* from Train as a,Train as b,TrainList as c where (a.Station LIKE '"+
               from+"%' AND b.Station LIKE '"+
               to+"%') AND a.S_No<b.S_No AND a.ID=b.ID AND c.ID=a.ID");
}

QVariantList TrainsInfo::getTrainInfo(const QString &id)
{
    return get("SELECT * FROM TrainList WHERE ID LIKE '"+
               id+"%' COLLATE NOCASE");
}

QVariantList TrainsInfo::getProvince()
{
    return get("SELECT * FROM ProvinceList");
}

QVariantList TrainsInfo::getProvince(const QString &filter)
{
    return get("SELECT * FROM ProvinceList WHERE ProPinyin LIKE '"+
               filter+"%' OR Province LIKE '"+
               filter+"%' COLLATE NOCASE");
}

QVariantList TrainsInfo::getStation(const QString &filter)
{
    return get("SELECT Station,Shortcode,FullCode FROM Pinyin WHERE Province LIKE '"+
               filter+"%' OR Shortcode LIKE '"+
               filter+"%' OR FullCode LIKE '"+
               filter+"%' COLLATE NOCASE");
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
