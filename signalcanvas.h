#ifndef SIGNALCANVAS_H
#define SIGNALCANVAS_H

#include <QtQuick>
#include "qlmsensors.h"


class LineNode : public QSGGeometryNode
{
public:
    LineNode(QSensorItem *sensor = 0);

    void setTimestamp(qint64 new_time){m_timestamp=new_time;};

    void updateGeometry(const QRectF &bounds);

private:
    QSGGeometry *m_geometry;
    QSensorItem *m_sensor;
    qint64 m_timestamp;
    QSGFlatColorMaterial *m_material;
    QColor m_color;
};


class GridNode : public QSGGeometryNode
{
public:
    GridNode();

    void updateGeometry(const QRectF &bounds);

private:
    QSGGeometry *m_geometry;
    QSGFlatColorMaterial *m_material;
    QColor m_color;
};


class RootNode : public QSGNode
{
public:
    QVector<LineNode*> lines;
    GridNode *grid;
};

class SignalCanvas : public QQuickItem
{
    Q_OBJECT
    Q_PROPERTY(int interval READ interval WRITE setinterval)
    Q_PROPERTY(QLmSensors* sensors READ getSensors CONSTANT)

public:
    explicit SignalCanvas(QQuickItem *parent = 0);
    QSGNode *updatePaintNode(QSGNode *node, UpdatePaintNodeData *);

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
