TEMPLATE = lib
TARGET = Mqttbackend
QT += qml quick
CONFIG += qt plugin

load(ubuntu-click)

TARGET = $$qtLibraryTarget($$TARGET)

# Input
SOURCES += \
    backend.cpp \
    mytype.cpp \
    qmqtt_client.cpp \
    qmqtt_network.cpp \
    qmqtt_frame.cpp \
    qmqtt_client_p.cpp \
    qmqtt_message.cpp \
    qmqtt_will.cpp \
    mqtt.cpp

HEADERS += \
    backend.h \
    mytype.h \
    qmqtt_client.h\
    qmqtt_global.h \
    qmqtt_network.h \
    qmqtt_frame.h \
    qmqtt_client_p.h \
    qmqtt_message.h \
    qmqtt_will.h \
    qmqtt.h \
    mqtt.h

OTHER_FILES = qmldir

!equals(_PRO_FILE_PWD_, $$OUT_PWD) {
    copy_qmldir.target = $$OUT_PWD/qmldir
    copy_qmldir.depends = $$_PRO_FILE_PWD_/qmldir
    copy_qmldir.commands = $(COPY_FILE) \"$$replace(copy_qmldir.depends, /, $$QMAKE_DIR_SEP)\" \"$$replace(copy_qmldir.target, /, $$QMAKE_DIR_SEP)\"
    QMAKE_EXTRA_TARGETS += copy_qmldir
    PRE_TARGETDEPS += $$copy_qmldir.target
}

qmldir.files = qmldir
installPath = $${UBUNTU_CLICK_PLUGIN_PATH}/Mqtt
qmldir.path = $$installPath
target.path = $$installPath
INSTALLS += target qmldir


