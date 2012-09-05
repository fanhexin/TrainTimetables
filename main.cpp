#include <QtGui/QApplication>
#include <QtDeclarative>
#include "qmlapplicationviewer.h"
#include "trainsinfo.h"
#include "update.h"
#include "settings.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));

    QSettings setting("IndependentSoft", "TrainTimetables");
    if (!setting.contains("ver")) {
        setting.setValue("ver", 1346751009);
    }
    if (!setting.contains("db_path")) {
        setting.setValue("db_path", "/opt/TrainTimetables/db/trains.db");
    }
    if (!setting.contains("dark_theme")) {
        setting.setValue("dark_theme", "false");
    }

    QmlApplicationViewer viewer;

    Settings config(&setting);
    viewer.rootContext()->setContextProperty("setting", &config);

    Update up(&setting);
    viewer.rootContext()->setContextProperty("update", &up);

    TrainsInfo trains(&setting);
    viewer.rootContext()->setContextProperty("timetable", &trains);

    QObject::connect(&up, SIGNAL(startUpdate()), &trains, SLOT(startUpdate()));
    QObject::connect(&up, SIGNAL(endUpdate()), &trains, SLOT(endUpdate()));

    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    viewer.setMainQmlFile(QLatin1String("qml/TrainTimetables/main.qml"));
    viewer.showExpanded();

    return app->exec();
}
