# Add more folders to ship with the application, here
folder_01.source = qml/pwnsensor
folder_01.target = qml
DEPLOYMENTFOLDERS = folder_01

#deploy.files = deployapp.sh
#deploy.path = $$OUT_PWD
#INSTALLS += deploy

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp \
    signalcanvas.cpp \
    qlmsensors.cpp

# Installation path
# target.path =

# Please do not modify the following two lines. Required for deployment.
include(qtquick2applicationviewer/qtquick2applicationviewer.pri)
qtcAddDeployment()

HEADERS += \
    signalcanvas.h \
    qlmsensors.h \
    settings.h

LIBS += -lsensors

OTHER_FILES += \
    qml/pwnsensor/SignalList.qml \
    qml/pwnsensor/Scrollbar.qml \
    qml/pwnsensor/SettingsDlg.qml \
#    deployapp.sh \
    qml/pwnsensor/CheckBox.qml \
    qml/pwnsensor/Button.qml \
    qml/pwnsensor/Assets/utils.js \
    qml/pwnsensor/Assets/Tooltip.qml

RESOURCES += \
    gfx.qrc

VERSION = $$system(head -1 $${PWD}/debian/changelog | awk \'{print $2}\')
DEFINES += VER=\\\"\"$${VERSION}\"\\\"

#    for(FILE, OTHER_FILES){
#        QMAKE_POST_LINK += $$quote(cp -n $${PWD}/$${FILE} $${OUT_PWD}$$escape_expand(\\n\\t))
#        }
