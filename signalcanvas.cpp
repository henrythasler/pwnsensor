#include "signalcanvas.h"

#define MAX(a,b) (((a)>(b))?(a):(b))

SignalCanvas::SignalCanvas(QQuickItem *parent) :
    QQuickPaintedItem(parent)
{
    LmSensors = new QLmSensors();

    // 20%-30%, but no AA
//    setRenderTarget(FramebufferObject);
//    setPerformanceHint(FastFBOResizing);

    timer = new QTimer(this);
    connect(timer, SIGNAL(timeout()), this, SLOT(timerevt()));
    timer->start(100);
}

void SignalCanvas::paint(QPainter *painter)
{
    QColor color = QColor((const QString)"white");
    QPen pen = QPen(/*QBrush(color), 2.*/);
    int point_cnt=0, samples=0;
    int s=0;
    int dx=1;
    QVector<QPointF> points;


//    return;

    qint64 current_timestamp = LmSensors->timestamp();


    painter->setRenderHint(QPainter::Antialiasing);
    painter->setPen(pen);

//    int inter = timer->interval();


    dx = MAX(1, float(LmSensors->items().at(0)->tmin)/float(boundingRect().width())/1000.*(1000./(float(timer->interval())))/2.);
//    dx = 1;
//    qDebug() << dx;

    for(int x=0; x<LmSensors->items().count(); x++)
        {
        if(LmSensors->items().at(x)->checked)
            {
            qint64 tmin = LmSensors->items().at(x)->tmin;
            float scale_y = boundingRect().height() / (LmSensors->items().at(x)->ymax - LmSensors->items().at(x)->ymin);
            float scale_x = -boundingRect().width() / tmin;

            color.setNamedColor(LmSensors->items().at(x)->color);
            pen.setColor(color);
            pen.setWidthF(LmSensors->items().at(x)->linewidth);
            painter->setPen(pen);

            samples=0;

            for(s=0; s<LmSensors->items().at(x)->samples().count(); s+=dx)
                {
                if(LmSensors->items().at(x)->samples().at(s)->time() >= (current_timestamp-tmin))
                    {
                    points.append(QPointF((current_timestamp - LmSensors->items().at(x)->samples().at(s)->time() - tmin) * scale_x,
                                          boundingRect().height()-(LmSensors->items().at(x)->samples().at(s)->value() - LmSensors->items().at(x)->ymin) * scale_y )
                                         );
                    samples++;
                    }
                }
            painter->drawPolyline(points.data()+point_cnt, points.length()-point_cnt);

            point_cnt+=samples;
            }
//        points.clear();
        }

//    painter->drawRoundedRect(0, 0, boundingRect().width(), boundingRect().height(), 20, 20);
}


void SignalCanvas::setinterval(int val)
{
    qDebug() << val;
    timer->setInterval(val);
}

void SignalCanvas::timerevt()
{
    LmSensors->do_sampleValues();

    if(!(counter%10))
        qDebug() << LmSensors->items().at(0)->samples().count();

    update();
    counter++;

}
