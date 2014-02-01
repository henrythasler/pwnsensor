#ifndef SETTINGS_H
#define SETTINGS_H

#include <QObject>
//#include <QDebug>
#include <QSettings>
#include <QCoreApplication>

class appSettings : public QSettings
{
    Q_OBJECT
public:
    explicit appSettings(QObject *parent = 0) :
        QSettings(QSettings::UserScope,
        "pwnsensor",
        "settings",
        parent)
        {}

    Q_INVOKABLE inline void setValue(const QString &key, const QVariant &value) { QSettings::setValue(key, value); }
    Q_INVOKABLE inline QVariant value(const QString &key, const QVariant &defaultValue = QVariant()) const { return QSettings::value(key, defaultValue); }
    Q_INVOKABLE inline void clear(void) { QSettings::clear(); }
    Q_INVOKABLE inline void beginGroup(const QString & prefix) { QSettings::beginGroup(prefix); }
    Q_INVOKABLE inline QStringList childKeys(void) const { return QSettings::childKeys(); }
};

#endif // SETTINGS_H
