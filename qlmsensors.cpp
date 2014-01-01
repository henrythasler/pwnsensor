#include "qlmsensors.h"

QLmSensors::QLmSensors(QObject *parent) :
    QObject(parent)
{
    m_initialized = Init();
}


void appendItems(QQmlListProperty<QSensorItem> *property, QSensorItem *item)
{
Q_UNUSED(property);
Q_UNUSED(item);
//Do nothing. can't add to a directory using this method
}

int itemSize(QQmlListProperty<QSensorItem> *property)
{
return static_cast< QList<QSensorItem *> *>(property->data)->size();
}

QSensorItem *itemAt(QQmlListProperty<QSensorItem> *property, int index)
{
return static_cast< QList<QSensorItem *> *>(property->data)->at(index);
}

void clearitemPtr(QQmlListProperty<QSensorItem> *property)
{
return static_cast< QList<QSensorItem *> *>(property->data)->clear();
}

QQmlListProperty<QSensorItem> QLmSensors::getItems()
{
    return QQmlListProperty<QSensorItem>(this, &m_sensorItems, &appendItems, &itemSize, &itemAt, &clearitemPtr);
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
            QSensorItem *new_item = new QSensorItem;

            sub = sensors_get_subfeature(chip, feature, (sensors_subfeature_type)(((int)feature->type) << 8));

            new_item->index = m_sensorItems.count();
            new_item->label = sensors_get_label(chip, feature);
            if(adap) new_item->adapter = adap;
            new_item->chip = chip;
            new_item->feature = feature;
            new_item->sub = sub;
            new_item->max_samples = 1800;
            new_item->tmin = 3 * 60 * 1000;    // now is 0

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


bool QLmSensors::do_sampleValues()
{
double val;
    foreach (QSensorItem* item, m_sensorItems)
        {
        item->do_sample();
/*
        sensors_get_value(item->chip, item->sub->number,&val);
//        item->samples.insert(QDateTime().currentDateTime().toMSecsSinceEpoch(), (val>32000)?0:val);
        item->m_samples.append(QSensorSample(0, QDateTime().currentDateTime().toMSecsSinceEpoch(), (val>32000)?0:(float)val));
        if(item->samples.size() > item->max_samples)
            {
            int i=0;

            for (int j = 0; j < item->samples.size(); ++j)
                {
                if(i < (item->samples.size() - item->max_samples)) item->samples.removeFirst();
                else break;
                i++;

                }
/*
            foreach (qint64 key, item->samples.keys())
                {
                if(i < (item->samples.size() - item->max_samples)) item->samples.remove(key);
                else break;
                i++;
                }

            }
*/
        }
    return true;
}


bool QSensorItem::do_sample()
{
double val;
    sensors_get_value(chip, sub->number,&val);
    m_samples.append(new QSensorSample(QDateTime().currentDateTime().toMSecsSinceEpoch(), (val>32000)?0:(float)val));
    if(m_samples.size() > max_samples)
        {
        int i=0;

        for (int j = 0; j < m_samples.size(); ++j)
            {
            if(i < (m_samples.size() - max_samples))  delete m_samples.takeFirst();
            else break;
            i++;
            }
        }
    return true;
}


float QSensorItem::getvalue()
{
double val;
    sensors_get_value(chip, sub->number,&val);
    return (float) val;
}


void appendSample(QQmlListProperty<QSensorSample> *property, QSensorSample *item)
{
Q_UNUSED(property);
Q_UNUSED(item);
}

int sampleSize(QQmlListProperty<QSensorSample> *property)
{
return static_cast< QList<QSensorSample *> *>(property->data)->size();
}

QSensorSample *sampleAt(QQmlListProperty<QSensorSample> *property, int index)
{
return static_cast< QList<QSensorSample *> *>(property->data)->at(index);
}

void clearSamplePtr(QQmlListProperty<QSensorSample> *property)
{
return static_cast< QList<QSensorSample *> *>(property->data)->clear();
}

QQmlListProperty<QSensorSample> QSensorItem::getSamples()
{
    return QQmlListProperty<QSensorSample>(this, &m_samples, &appendSample, &sampleSize, &sampleAt, &clearSamplePtr);
}
