#include <QtGui/QApplication>
#include <QtDeclarative>
#include "qmlapplicationviewer.h"
#include "trainsinfo.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));

    QmlApplicationViewer viewer;
    TrainsInfo trains("/opt/TrainTimetables/data/trains.db");
    viewer.rootContext()->setContextProperty("timetable", &trains);

    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    viewer.setMainQmlFile(QLatin1String("qml/TrainTimetables/main.qml"));
    viewer.showExpanded();

    return app->exec();
}
