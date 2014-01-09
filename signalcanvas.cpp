#include "signalcanvas.h"

#define MAX(a,b) (((a)>(b))?(a):(b))

SignalCanvas::SignalCanvas(QQuickItem *parent) :
    QQuickItem(parent)
{
    LmSensors = new QLmSensors();


    setFlag(ItemHasContents);
//    setAntialiasing(true);


    // 20%-30%, but no AA
//    setRenderTarget(FramebufferObject);
//    setPerformanceHint(FastFBOResizing);

    timer = new QTimer(this);
    connect(timer, SIGNAL(timeout()), this, SLOT(timerevt()));
    timer->start(100);
}

/*
void SignalCanvas::paint(QPainter *painter)
{
    QColor color = QColor((const QString)"white");
    QPen pen = QPen();
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
*/


QSGNode *SignalCanvas::updatePaintNode(QSGNode *oldNode, UpdatePaintNodeData *)
{

    RootNode *root= static_cast<RootNode *>(oldNode);

    QRectF rect = boundingRect();

    if (rect.isEmpty()) {
        delete root;
        return 0;
    }

    if (!root) {
        root = new RootNode();
//        LineNode *line = new LineNode(LmSensors->items().at(0));
        root->lines.append(new LineNode(LmSensors->items().at(2)));
        root->appendChildNode(root->lines.at(0));
    }
    else {
        root->lines.at(0)->updateGeometry(rect);
        }

    return root;

//    QSGGeometryNode *node = 0;
//    QSGGeometry *geometry = 0;

//    int m_segmentCount = LmSensors->items().at(27)->samples().count();

//    if (!oldNode) {
//        node = new QSGGeometryNode;
//        geometry = new QSGGeometry(QSGGeometry::defaultAttributes_Point2D(), m_segmentCount);
//        geometry->setLineWidth(1);
//        geometry->setDrawingMode(GL_LINE_STRIP);
//        node->setGeometry(geometry);
//        node->setFlag(QSGNode::OwnsGeometry);
//        QSGFlatColorMaterial *material = new QSGFlatColorMaterial;
//        material->setColor(QColor(255, 0, 0));
//        node->setMaterial(material);
//        node->setFlag(QSGNode::OwnsMaterial);
//    } else {
//        node = static_cast<QSGGeometryNode *>(oldNode);
//        geometry = node->geometry();
//        geometry->allocate(m_segmentCount);
//    }

//    QRectF bounds = boundingRect();
//    QSGGeometry::Point2D *vertices = geometry->vertexDataAsPoint2D();
//    for (int i = 0; i < m_segmentCount; ++i)
//        {
//        vertices[i].set(float(i), LmSensors->items().at(27)->samples().at(i)->value()*4.);
//        }
//    node->markDirty(QSGNode::DirtyGeometry);

//    return node;




//    QSGSimpleRectNode *n = static_cast<QSGSimpleRectNode *>(oldNode);
//    if (!n) {
//        n = new QSGSimpleRectNode();
//    }
//    QColor color = QColor();
//    color.setHslF(float(counter%500)/500.,1.,0.5);
//    n->setColor(color);
//    n->setRect(boundingRect());
//    return n;

}

void SignalCanvas::setinterval(int val)
{
    qDebug() << val;
    timer->setInterval(val);
}

void SignalCanvas::timerevt()
{
    LmSensors->do_sampleValues();

    if(!(counter%10)) qDebug() << LmSensors->items().at(0)->samples().count();

    update();
    counter++;

}



LineNode::LineNode(QSensorItem *sensor)
    :m_sensor(sensor)
{
    m_geometry = new QSGGeometry(QSGGeometry::defaultAttributes_Point2D(), m_sensor->samples().count());
    m_geometry->setLineWidth(10.);
    m_geometry->setDrawingMode(GL_LINE_STRIP);
    setGeometry(m_geometry);
    setFlag(QSGNode::OwnsGeometry);
    QSGFlatColorMaterial *material = new QSGFlatColorMaterial;
    material->setColor(QColor(255, 0, 0));
    setMaterial(material);
    setFlag(QSGNode::OwnsMaterial);
}


void LineNode::updateGeometry(const QRectF &bounds)
{
        m_geometry->allocate(m_sensor->samples().count());
        QSGGeometry::Point2D *vertices = m_geometry->vertexDataAsPoint2D();

        for (int i = 0; i < m_sensor->samples().count(); ++i)
            {
            vertices[i].set(float(i), m_sensor->samples().at(i)->value()+0.5);
//            vertices[i].set(float(i*10), sin(float(i))*100+150);
            }
    markDirty(QSGNode::DirtyGeometry);
}
