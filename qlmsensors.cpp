#include "qlmsensors.h"

QLmSensors::QLmSensors(QObject *parent) :
    QObject(parent)
{
}

bool QLmSensors::Init()
{
#define BUF_SIZE 200
static char buf[BUF_SIZE];

int chip_nr, a, b;
const sensors_chip_name *chip;
const sensors_subfeature *sub;
const sensors_feature *feature;
const char *adap=NULL;
char *label;

if(int err = sensors_init(NULL))
    {
    m_errorMessage = sensors_strerror(err);
    return false;
    }
else
    {
    chip_nr=0;

    while ((chip = sensors_get_detected_chips(NULL, &chip_nr)))
        {
        if (sensors_snprintf_chip_name(buf, BUF_SIZE, chip) >= 0)
//                qDebug() << buf;

        adap = sensors_get_adapter_name(&chip->bus);
//            if(adap) qDebug() << " " << adap;
        a = 0;
        while ((feature = sensors_get_features(chip, &a)))
            {
//                qDebug() << "  " << sensors_get_label(chip, feature);
            QSensorItem *new_item = new QSensorItem();

            sub = sensors_get_subfeature(chip, feature, (sensors_subfeature_type)(((int)feature->type) << 8));

            new_item->index = sensorItems.count();
            new_item->label = sensors_get_label(chip, feature);
            if(adap) new_item->adapter = adap;
            new_item->chip = chip;
            new_item->feature = feature;
            new_item->sub = sub;
            new_item->max_samples = 1201;
            new_item->tmin = 6 * 60 * 1000;    // now is 0

            switch(new_item->feature->type)
                {
                case SENSORS_FEATURE_FAN:
                        new_item->ymin=300;
                        new_item->ymax=1200;
                        break;
                default:
                        new_item->ymin=0;
                        new_item->ymax=100;
                        break;
                }
            m_sensorItems.append(new_item);
            }
        }
    }

return true;
}


