#include <QtGui/QApplication>
#include <QtDeclarative>
#include "qmlapplicationviewer.h"
#include "trainsinfo.h"
#include "update.h"
#include "settings.h"
#include "macro.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));

    QmlApplicationViewer viewer;

    QSettings setting("IndependentSoft", "TrainTimetables");
    Settings config(&setting);
    viewer.rootContext()->setContextProperty("setting", &config);

    Update up(&setting);
    viewer.rootContext()->setContextProperty("update", &up);

    TrainsInfo trains(&setting);
    viewer.rootContext()->setContextProperty("timetable", &trains);

    QObject::connect(&up, SIGNAL(startUpdate()), &trains, SLOT(closeDB()));
    QObject::connect(&up, SIGNAL(endUpdate()), &trains, SLOT(changeDB()));

    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    viewer.setMainQmlFile(QLatin1String("qml/TrainTimetables/main.qml"));
    viewer.showExpanded();

    return app->exec();
}
