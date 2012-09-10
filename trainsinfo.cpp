#include "trainsinfo.h"

TrainsInfo::TrainsInfo(QSettings *setting, QObject *parent) :
    QObject(parent),
    m_setting(setting)
{
    m_db = QSqlDatabase::addDatabase("QSQLITE");
    m_db.setDatabaseName(m_setting->value("db_path").toString());
    if ( !m_db.open()) {
        qDebug() << "open error!";
    }
    qDebug() << m_db.databaseName();
}

QVariantList TrainsInfo::getTrain(const QString &id)
{
    return get("SELECT * FROM Train WHERE ID='"+
               id+"' COLLATE NOCASE");
}

QVariantList TrainsInfo::getTrainsByStation(const QString &station)
{
    return get("SELECT a.*, b.A_Time, b.D_Time, b.Day FROM TrainList a,Train b WHERE b.Station='"+
               station+"' AND b.ID=a.ID");
}

QVariantList TrainsInfo::getTrainsBetweenStations(const QString &from, const QString &to)
{
    return get("SELECT c.*, a.A_Time sA_Time, a.D_Time sD_Time, a.Day sDay, b.A_Time eA_Time, b.Day eDay, b.R_Date-a.R_Date Interval FROM Train a,Train b,TrainList c WHERE (a.Station LIKE '"+
               from+"%' AND b.Station LIKE '"+
               to+"%') AND a.S_No<b.S_No AND a.ID=b.ID AND c.ID=a.ID ORDER BY Interval");
}

//QVariantList TrainsInfo::getTrainsBSOneStop(const QString &from, const QString &to)
//{
//    return get("SELECT a.ID startID, a.endStation Station, b.ID endID FROM NoStopRoute a, NoStopRoute b WHERE a.startStation LIKE '"+
//               from+"%' AND b.endStation LIKE '"+
//               to+"%' AND a.endStation=b.startStation");
//}

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

QVariantList TrainsInfo::getTrainStation(const QString &id, const QString &station)
{
    return get("SELECT * FROM Train WHERE ID='"+
               id+"' AND Station LIKE '"+
               station+"%' COLLATE NOCASE");
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

void TrainsInfo::startUpdate()
{
    m_db.close();
}

void TrainsInfo::endUpdate()
{
    m_db.setDatabaseName(m_setting->value("db_path").toString());
    m_db.open();
}
