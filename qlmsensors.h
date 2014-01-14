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
    Q_PROPERTY(QString label READ getlabel)
    Q_PROPERTY(float value READ getvalue)
    Q_PROPERTY(float minval READ getminval)
    Q_PROPERTY(float maxval READ getmaxval)
    Q_PROPERTY(qint64 tmin READ gettmin)
    Q_PROPERTY(qint64 tmax READ gettmax)
    Q_PROPERTY(float ymin READ getymin)
    Q_PROPERTY(float ymax READ getymax)
    Q_PROPERTY(QString color READ getcolor WRITE setcolor NOTIFY colorChanged)
    Q_PROPERTY(bool checked READ getchecked WRITE setchecked NOTIFY checkChanged)
    Q_PROPERTY(QQmlListProperty<QSensorSample> samples READ getSamples NOTIFY updateSamples)

public:
    explicit QSensorItem(QObject *parent = 0);

    QString getlabel(){return label;};
    float getvalue();
    qint64 gettmin(){return tmin;};
    qint64 gettmax(){return tmax;};
    float getymin(){return ymin;};
    float getymax(){return ymax;};
    QString getcolor(){return color;};
    void setcolor(const QString &newcol){color=newcol;};
    bool getchecked(){return checked;};
    void setchecked(const bool &newcheck){checked=newcheck;};
    float getminval(){return minval;};
    float getmaxval(){return maxval;};


    QQmlListProperty<QSensorSample> getSamples();
    QList<QSensorSample*> samples(){return m_samples;};


    bool do_sample(const qint64 &timestamp);

    int index;
    const sensors_chip_name *chip;
    const sensors_feature *feature;
    const sensors_subfeature *sub;
    qint64 tmin, tmax;    // visible range in ms
    float ymin, ymax;   // min/max value y-axis
    float minval, maxval;   // min/max values of the signal
    QString label;
    QString adapter;
    QString color;
    QString unit;
    float linewidth;
    float offset, scale;
    qint32 max_samples;
    bool checked;

signals:
    void updateSamples();
    void checkChanged();
    void colorChanged();

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
    Q_PROPERTY(QQmlListProperty<QSensorItem> items READ getItems NOTIFY updateItems)

public:
    explicit QLmSensors(QObject *parent = 0);

    Q_INVOKABLE bool do_sampleValues();

    qint64 timestamp(){return(QDateTime().currentDateTime().toMSecsSinceEpoch());};
    bool initialized(){return m_initialized;};
    QString errorMessage(){return m_errorMessage;};

    QList<QSensorItem*> items(){return m_sensorItems;};

    QQmlListProperty<QSensorItem> getItems();

    QStringList palette;


signals:
    void updateItems();

public slots:

private:
    bool Init();

    QList<QSensorItem*> m_sensorItems;

    QString m_errorMessage;
    bool m_initialized;

};

#endif // QLMSENSORS_H
