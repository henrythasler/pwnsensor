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
    Q_PROPERTY(int samplerate READ samplerate WRITE setsamplerate NOTIFY samplerateChanged)
    Q_PROPERTY(int refreshrate READ refreshrate WRITE setrefreshrate NOTIFY refreshrateChanged)
    Q_PROPERTY(qint64 tmin READ tmin WRITE settmin NOTIFY tminChanged)
    Q_PROPERTY(QLmSensors* sensors READ getSensors CONSTANT)

public:
    explicit SignalCanvas(QQuickItem *parent = 0);
    QSGNode *updatePaintNode(QSGNode *node, UpdatePaintNodeData *);

    int samplerate(){return m_samplerate;};
    void setsamplerate(int val){m_samplerate=val; emit samplerateChanged();};

    int refreshrate(){return m_refreshrate;};
    void setrefreshrate(int val){m_refreshrate=val; emit refreshrateChanged();};

    qint64 tmin(){return m_tmin;};
    void settmin(qint64 val){m_tmin=val; emit tminChanged();};

    QLmSensors* getSensors(){return LmSensors;};
    QTimer *timer;

signals:
    void samplerateChanged();
    void refreshrateChanged();
    void tminChanged();

public slots:
    void timerevt();

public slots:



private:
    int counter;
    QLmSensors *LmSensors;
    QStringList palette;
    QRectF old_rect;

    qint64 m_tmin;
    qint64 m_timestamp;
    int m_refreshrate;
    int m_samplerate;
    int timerinterval;

};
#endif // SIGNALCANVAS_H
