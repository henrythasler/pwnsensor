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
    qmlRegisterType<appSettings>("sensors", 1, 0, "appSettings");

    QtQuick2ApplicationViewer viewer;
    viewer.rootContext()->setContextProperty("settings", &settings);

    QSurfaceFormat format = viewer.format();

    qDebug() << "OpenGL v" << format.majorVersion() << "." << format.minorVersion();

    format.setSamples(16);
    viewer.setFormat(format);

    viewer.setTitle("pwnsensor alpha-3");
    viewer.setMainQmlFile(QStringLiteral("qml/pwnsensor/main.qml"));
    viewer.showExpanded();

//    settings.set("position", viewer.geometry());
//    viewer.setGeometry(100,100,320,200);
//    QSettings storage("Henry", "pwnsensor");


    return app.exec();
}
