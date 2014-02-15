#include "signalcanvas.h"

#define MAX(a,b) (((a)>(b))?(a):(b))

SignalCanvas::SignalCanvas(QQuickItem *parent) :
    QQuickItem(parent)
{
    LmSensors = new QLmSensors();


    setFlag(ItemHasContents);

    m_samplerate = 100;
    m_refreshrate = 100;

    timerinterval = 100;
    timer = new QTimer(this);
    connect(timer, SIGNAL(timeout()), this, SLOT(timerevt()));
    timer->start(timerinterval);
}


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
//        qDebug() << rect;

        root->grid = new GridNode();
        root->appendChildNode(root->grid);
        root->grid->updateGeometry(rect);

        for(int i=0; i<LmSensors->items().count();i++)
            {
            root->lines.append(new LineNode(LmSensors->items().at(i)));

            root->appendChildNode(root->lines.at(i));
            root->lines.at(i)->setTimestamp(LmSensors->timestamp());
            root->lines.at(i)->updateGeometry(rect);
            }

    }
    else {
//        qint64 timestamp=LmSensors->timestamp();

        if(rect != old_rect)
            root->grid->updateGeometry(rect);

        for(int i=0; i<LmSensors->items().count();i++)
            {
            root->lines.at(i)->setTimestamp(m_timestamp);
            LmSensors->items().at(i)->tmin = m_tmin*1000;
            root->lines.at(i)->updateGeometry(rect);
            }
        }

    old_rect = rect;
    return root;
}


void SignalCanvas::timerevt()
{
    m_timestamp=LmSensors->timestamp();

    if(!(counter%(m_samplerate/timerinterval))) LmSensors->do_sampleValues();

    if(!(counter%(m_refreshrate/timerinterval))) update();

//    if(!(counter%50)) qDebug() << LmSensors->items().at(0)->samples().count();
    counter++;
}


GridNode::GridNode()
{
    m_geometry = new QSGGeometry(QSGGeometry::defaultAttributes_Point2D(), 0);
    m_geometry->setDrawingMode(GL_LINES);
    setGeometry(m_geometry);
    setFlag(QSGNode::OwnsGeometry);

    m_material = new QSGFlatColorMaterial();
    m_color.setNamedColor("#424a51");
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

//    qDebug() << bounds;


    for(int x=0; x<=nx;x++)
        {
        vertices[cnt++].set(int(bounds.topLeft().x()+(bounds.width()-1)/nx*x)+0.5, int(bounds.topLeft().y())+0.5);
        vertices[cnt++].set(int(bounds.bottomLeft().x()+(bounds.width()-1)/nx*x)+0.5, int(bounds.bottomLeft().y())+0.5);
        }

    for(int y=0; y<=ny;y++)
        {
        vertices[cnt++].set(int(bounds.topRight().x())+0.5, int(bounds.topRight().y()+(bounds.height()-1)/ny*y)+0.5);
        vertices[cnt++].set(int(bounds.topLeft().x())+0.5, int(bounds.topLeft().y()+(bounds.height()-1)/ny*y)+0.5);
        }
    markDirty(QSGNode::DirtyGeometry);
}



LineNode::LineNode(QSensorItem *sensor)
    :m_sensor(sensor)
{
    m_geometry = new QSGGeometry(QSGGeometry::defaultAttributes_Point2D(), m_sensor->samples().count());
//    m_geometry = new QSGGeometry(QSGGeometry::defaultAttributes_ColoredPoint2D(), m_sensor->samples().count());

    m_geometry->setDrawingMode(GL_TRIANGLE_STRIP);
//    m_geometry->setDrawingMode(GL_POINTS);

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
        int first_sample,last_sample;

//        int dx = MAX(1, float(m_sensor->tmin)/float(bounds.width())/1000.*(1000./(float(m_sensor->samples().at(1)->time()-m_sensor->samples().at(0)->time())))/2.);
//        qDebug() << dx;

        for(int x=1;x<m_sensor->samples().count();x++)
            {
            if(m_sensor->samples().at(x)->time() >= (m_timestamp-m_sensor->tmin))
                {
                first_sample = x-1;
                break;
                }
            }

        last_sample = m_sensor->samples().count()-1;
        first_sample = 0;

        m_geometry->allocate(MAX(last_sample-first_sample, 0)*4);
        QSGGeometry::Point2D *vertices = m_geometry->vertexDataAsPoint2D();
//        QSGGeometry::ColoredPoint2D  *vertices = m_geometry->vertexDataAsColoredPoint2D();

        m_color.setNamedColor(m_sensor->color);
        if(m_material->color() != m_color)
            {
//            m_color.setAlphaF(0.5);
            m_material->setColor(m_color);
            markDirty(QSGNode::DirtyMaterial);
            }

        qint64 tmin = m_sensor->tmin;
        float scale_y = bounds.height() / (m_sensor->ymax - m_sensor->ymin);
        float scale_x = -bounds.width() / tmin;
        float offset = m_sensor->linewidth/2.;

        QVector2D start = QVector2D(bounds.left()+(m_timestamp - m_sensor->samples().at(first_sample)->time() - tmin) * scale_x,
                                    bounds.top()+bounds.height()-(m_sensor->samples().at(first_sample)->value() - m_sensor->ymin) * scale_y
                                    );
        QVector2D end, a,b,c,d;

        for(int s=first_sample+1, v=0; s<=last_sample; s++)
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

            vertices[v++].set(a.x(),int(a.y()));
            vertices[v++].set(b.x(),int(b.y()));
            vertices[v++].set(c.x(),int(c.y()));
            vertices[v++].set(d.x(),int(d.y()));

            start = end;
            }
        }
    else
        {
        m_geometry->allocate(0);
        }

    markDirty(QSGNode::DirtyGeometry);
}
