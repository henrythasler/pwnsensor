#ifndef QLMSENSORS_H
#define QLMSENSORS_H

#include <QObject>

#include <QTime>
#include <QDebug>
#include <QQmlListProperty>

// LM-Sensors Library Header
#include <sensors/sensors.h>/* Library initialization and clean-up */
#include <sensors/error.h>/* Library initialization and clean-up */



class QSensorSample : public QObject
{
    Q_OBJECT
    Q_PROPERTY(qint64 time READ time CONSTANT)
    Q_PROPERTY(float value READ value CONSTANT)
public:
    explicit QSensorSample(QObject *parent = 0):QObject(parent){m_time=0;m_value=0;};
    explicit QSensorSample(qint64 t, float v, QObject *parent = 0):QObject(parent){m_time=t;m_value=v;};

    qint64 time() {return(m_time);}
    float value() {return(m_value);}

signals:

public slots:

private:
    qint64 m_time;
    float m_value;
};



class QSensorItem : public QObject
{
    Q_OBJECT
public:
    explicit QSensorItem(QObject *parent = 0):QObject(parent)
        {
        index=-1;
        chip=0;
        feature=0;
        sub=0;
        tmin = tmax = 0;    // visible range in ms
        ymin = ymax = 0;   // min/max value y-axis
        label = "none";
        adapter = "none";
        color = "white";
        unit = "none";
        linewidth = 2;
        offset = 0.;
        scale = 1.;
        max_samples = 32;
        };

    bool do_sample();

    int index;
    const sensors_chip_name *chip;
    const sensors_feature *feature;
    const sensors_subfeature *sub;
    qint64 tmin, tmax;    // visible range in ms
    float ymin, ymax;   // min/max value y-axis
    QString label;
    QString adapter;
    QString color;
    QString unit;
    float linewidth;
    float offset, scale;
    qint32 max_samples;

signals:

public slots:

private:
    QList<QSensorSample*> m_samples;
};



class QLmSensors : public QObject
{
    Q_OBJECT
    Q_PROPERTY(qint64 timestamp READ timestamp)
    Q_PROPERTY(bool initialized READ initialized)
    Q_PROPERTY(QString errorMessage READ errorMessage)
public:
    explicit QLmSensors(QObject *parent = 0);

    Q_INVOKABLE bool do_sampleValues();

    qint64 timestamp(){return(QDateTime().currentDateTime().toMSecsSinceEpoch());};
    bool initialized(){return m_initialized;};
    QString errorMessage(){return m_errorMessage;};

signals:

public slots:

private:
    bool Init();


    QList<QSensorItem*> m_sensorItems;

    QString m_errorMessage;
    bool m_initialized;

};

#endif // QLMSENSORS_H
