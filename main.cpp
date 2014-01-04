#include <QtGui/QGuiApplication>
#include "qtquick2applicationviewer.h"

#include <QtQml>
#include "qlmsensors.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);


    qmlRegisterType<QLmSensors>("sensors", 1, 0, "QLmSensors");
    qmlRegisterType<QSensorItem>("sensors", 1, 0, "QSensorItem");
    qmlRegisterType<QSensorSample>("sensors", 1, 0, "QSensorSample");

    QtQuick2ApplicationViewer viewer;
    viewer.setTitle("pwnsensor alpha-1");
    viewer.setMainQmlFile(QStringLiteral("qml/pwnsensor/main.qml"));
    viewer.showExpanded();

    return app.exec();
}
