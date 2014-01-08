#ifndef SIGNALCANVAS_H
#define SIGNALCANVAS_H

#include <QtQuick>
#include "qlmsensors.h"

class SignalCanvas : public QQuickItem
{
    Q_OBJECT
    Q_PROPERTY(int interval READ interval WRITE setinterval)
    Q_PROPERTY(QLmSensors* sensors READ getSensors CONSTANT)

public:
    explicit SignalCanvas(QQuickItem *parent = 0);
    QSGNode *updatePaintNode(QSGNode *node, UpdatePaintNodeData *);
//    void paint(QPainter *painter);

    int interval(){return timer->interval();};
    void setinterval(int val);

    QLmSensors* getSensors(){return LmSensors;};
    QTimer *timer;

signals:

public slots:
    void timerevt();

public slots:



private:
    int counter;
    QLmSensors *LmSensors;
    QStringList palette;
};
#endif // SIGNALCANVAS_H
