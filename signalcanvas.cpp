#include "signalcanvas.h"

SignalCanvas::SignalCanvas(QQuickItem *parent) :
    QQuickPaintedItem(parent)
{
    LmSensors = new QLmSensors();

    QTimer *timer = new QTimer(this);
    connect(timer, SIGNAL(timeout()), this, SLOT(update()));
    timer->start(100);
}

void SignalCanvas::paint(QPainter *painter)
{
    QColor color = QColor((const QString)"red");
    color.setAlphaF(float(qrand())/RAND_MAX);
    painter->setRenderHint(QPainter::Antialiasing);
    painter->setBrush(QBrush(color));
    painter->setPen(Qt::NoPen);


    painter->drawRoundedRect(0, 0, boundingRect().width(), boundingRect().height(), 20, 20);
}


void SignalCanvas::setinterval(int val)
{
//    qDebug() << val;
//    timer->setInterval(1000);
}
