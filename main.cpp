#include <QtGui/QGuiApplication>
#include "qtquick2applicationviewer.h"

#include <QtQml>
#include "signalcanvas.h"
#include "settings.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    appSettings settings;

    qmlRegisterType<QLmSensors>("sensors", 1, 0, "QLmSensors");
    qmlRegisterType<QSensorItem>("sensors", 1, 0, "QSensorItem");
    qmlRegisterType<QSensorSample>("sensors", 1, 0, "QSensorSample");
    qmlRegisterType<SignalCanvas>("sensors", 1, 0, "SignalCanvas");
//    qmlRegisterType<appSettings>("sensors", 1, 0, "appSettings");

    QtQuick2ApplicationViewer viewer;
    viewer.rootContext()->setContextProperty("settings", &settings);
    viewer.rootContext()->setContextProperty("mainwindow",&viewer);
    qDebug() << viewer.engine()->importPathList();

    QSurfaceFormat format = viewer.format();

    qDebug() << "OpenGL v" << format.majorVersion() << "." << format.minorVersion();

    format.setSamples(16);
//    format.setStereo(true);
    viewer.setFormat(format);

    viewer.setTitle("pwnsensor beta-1");
    viewer.setMainQmlFile(QStringLiteral("qml/pwnsensor/main.qml"));
    viewer.showExpanded();

    return app.exec();
}
