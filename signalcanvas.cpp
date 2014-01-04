#include "signalcanvas.h"

SignalCanvas::SignalCanvas(QQuickItem *parent) :
    QQuickPaintedItem(parent)
{
    LmSensors = new QLmSensors();

    QTimer *timer = new QTimer(this);
    connect(timer, SIGNAL(timeout()), this, SLOT(timerevt()));
    timer->start(100);
}

void SignalCanvas::paint(QPainter *painter)
{
    QColor color = QColor((const QString)"orange");
    QPen pen = QPen(QBrush(color), 2.);
//    color.setAlphaF(float(qrand())/RAND_MAX);
    painter->setRenderHint(QPainter::Antialiasing);
//    painter->setBrush(QBrush(color));

    qint64 pcnt=0;
    int s=0;

    QVector<QPointF> points;// = new QVector<QPointF>();

    for(int x=0; x<LmSensors->items().count(); x++)
        {
//        color.setHslF(float(x)/float(LmSensors->items().count()),1.,0.5);
        painter->setPen(pen);
        for(s=0; s<LmSensors->items().at(x)->samples().count(); s++)
            points.append(QPointF(s, LmSensors->items().at(x)->samples().at(s)->value()));
        painter->drawPolyline(points.data()+pcnt, points.length()-pcnt);
        pcnt+=s;
//        points.clear();
        }

//    painter->drawRoundedRect(0, 0, boundingRect().width(), boundingRect().height(), 20, 20);
}


void SignalCanvas::setinterval(int val)
{
//    qDebug() << val;
//    timer->setInterval(1000);
}

void SignalCanvas::timerevt()
{
    LmSensors->do_sampleValues();
    update();

//    qDebug() << val;
//    timer->setInterval(1000);
}
