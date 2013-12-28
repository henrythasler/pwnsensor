#ifndef QLMSENSORS_H
#define QLMSENSORS_H

#include <QObject>

// LM-Sensors Library Header
#include <sensors/sensors.h>/* Library initialization and clean-up */
#include <sensors/error.h>/* Library initialization and clean-up */

class QLmSensors : public QObject
{
    Q_OBJECT
public:
    explicit QLmSensors(QObject *parent = 0);

signals:

public slots:

private:
    bool Init();
};

#endif // QLMSENSORS_H
