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

        root->grid = new GridNode();
        root->appendChildNode(root->grid);
        root->grid->updateGeometry(rect.adjusted(10,10,-10,-10));

        for(int i=0; i<LmSensors->items().count();i++)
            {
            root->lines.append(new LineNode(LmSensors->items().at(i)));

            root->appendChildNode(root->lines.at(i));
            root->lines.at(i)->setTimestamp(LmSensors->timestamp());
            root->lines.at(i)->updateGeometry(rect.adjusted(10,10,-10,-10));
            }

    }
    else {

        qint64 timestamp=LmSensors->timestamp();

        root->grid->updateGeometry(rect.adjusted(10,10,-10,-10));

        for(int i=0; i<LmSensors->items().count();i++)
            {
            root->lines.at(i)->setTimestamp(timestamp);
            root->lines.at(i)->updateGeometry(rect.adjusted(10,10,-10,-10));
            }
        }

    return root;
}

void SignalCanvas::setinterval(int val)
{
//    qDebug() << val;
    timer->setInterval(val);
}

void SignalCanvas::timerevt()
{
    counter++;
    LmSensors->do_sampleValues();
    if(!(counter%20)) qDebug() << LmSensors->items().at(0)->samples().count();
    update();

}


GridNode::GridNode()
{
    m_geometry = new QSGGeometry(QSGGeometry::defaultAttributes_Point2D(), 0);
    m_geometry->setDrawingMode(GL_LINES);
    setGeometry(m_geometry);
    setFlag(QSGNode::OwnsGeometry);

    m_material = new QSGFlatColorMaterial();
    m_color.setNamedColor("red");
    m_material->setColor(m_color);

    setMaterial(m_material);
    setFlag(QSGNode::OwnsMaterial);
}


void GridNode::updateGeometry(const QRectF &bounds)
{
    int cnt=0;
    int nx=16;
    int ny=12;

    m_geometry->allocate((nx+1)*(ny+1)*2);
    QSGGeometry::Point2D *vertices = m_geometry->vertexDataAsPoint2D();

    for(int x=0; x<=nx;x++)
        {
        vertices[cnt++].set(int(bounds.topLeft().x()+bounds.width()/nx*x)+0.5, int(bounds.topLeft().y())+0.5);
        vertices[cnt++].set(int(bounds.bottomLeft().x()+bounds.width()/nx*x)+0.5, int(bounds.bottomLeft().y())+0.5);
        }

    for(int y=0; y<=ny;y++)
        {
        vertices[cnt++].set(int(bounds.topRight().x())+0.5, int(bounds.topRight().y()+bounds.height()/ny*y)+0.5);
        vertices[cnt++].set(int(bounds.topLeft().x())+0.5, int(bounds.topLeft().y()+bounds.height()/ny*y)+0.5);
        }
    markDirty(QSGNode::DirtyGeometry);
}



LineNode::LineNode(QSensorItem *sensor)
    :m_sensor(sensor)
{
    m_geometry = new QSGGeometry(QSGGeometry::defaultAttributes_Point2D(), m_sensor->samples().count());
    m_geometry->setDrawingMode(GL_TRIANGLE_STRIP);
    setGeometry(m_geometry);
    setFlag(QSGNode::OwnsGeometry);

    m_material = new QSGFlatColorMaterial();
    m_color.setNamedColor(m_sensor->color);
    m_material->setColor(m_color);

    setMaterial(m_material);
    setFlag(QSGNode::OwnsMaterial);
}


void LineNode::updateGeometry(const QRectF &bounds)
{
    if(m_sensor->checked && m_sensor->samples().count()>1)
        {
        m_geometry->allocate((m_sensor->samples().count()-1)*4);
        QSGGeometry::Point2D *vertices = m_geometry->vertexDataAsPoint2D();

        m_color.setNamedColor(m_sensor->color);
        if(m_material->color() != m_color)
            {
            m_material->setColor(m_color);
            markDirty(QSGNode::DirtyMaterial);
            }

        qint64 tmin = m_sensor->tmin;
        float scale_y = bounds.height() / (m_sensor->ymax - m_sensor->ymin);
        float scale_x = -bounds.width() / tmin;
        float offset = m_sensor->linewidth/2.;

        QVector2D start = QVector2D(bounds.left()+(m_timestamp - m_sensor->samples().at(0)->time() - tmin) * scale_x,
                                    bounds.top()+bounds.height()-(m_sensor->samples().at(0)->value() - m_sensor->ymin) * scale_y
                                    );
        QVector2D end, a,b,c,d;

        for(int s=1; s<m_sensor->samples().count(); s++)
            {
            end.setX(bounds.left()+(m_timestamp - m_sensor->samples().at(s)->time() - tmin) * scale_x);
            end.setY(bounds.top()+bounds.height()-(m_sensor->samples().at(s)->value() - m_sensor->ymin) * scale_y);

            QVector2D normal(-(end.y()-start.y()), (end.x()-start.x()));
            normal.normalize();

            // GL_QUADS
//            a = start+(offset*normal);
//            b = end+(offset*normal);
//            c = end-(offset*normal);
//            d = start-(offset*normal);

            // GL_TRIANGLE_STRIP
            a = start+(offset*normal);
            c = end+(offset*normal);
            d = end-(offset*normal);
            b = start-(offset*normal);

            vertices[(s-1)*4].set(a.x(),a.y());
            vertices[(s-1)*4+1].set(b.x(),b.y());
            vertices[(s-1)*4+2].set(c.x(),c.y());
            vertices[(s-1)*4+3].set(d.x(),d.y());

            start = end;
            }
        }
    else
        {
        m_geometry->allocate(0);
        }

    markDirty(QSGNode::DirtyGeometry);
}
