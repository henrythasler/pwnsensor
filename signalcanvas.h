#ifndef SIGNALCANVAS_H
#define SIGNALCANVAS_H

#include <QtQuick>
#include "qlmsensors.h"

class SignalCanvas : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY(qint64 interval READ interval WRITE setinterval)
    Q_PROPERTY(QLmSensors* sensors READ getSensors CONSTANT)

public:
    explicit SignalCanvas(QQuickItem *parent = 0);
    void paint(QPainter *painter);

    int interval(){return timer->interval();};
    void setinterval(int val);

    QLmSensors* getSensors(){return LmSensors;};

signals:

public slots:

private:
    QLmSensors *LmSensors;
    QTimer *timer;

};
#endif // SIGNALCANVAS_H
