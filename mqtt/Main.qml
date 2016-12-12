import QtQuick 2.0
import Ubuntu.Components 1.1
import Mqtt 1.0
/*!
    \brief MainView with a Label and Button elements.
*/

MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "mqtt.liu-xiao-guo"

//    anchorToKeyboard: true

    width: units.gu(60)
    height: units.gu(85)

    MQTT {
        id: _MQTT
        //            host: "mqtt.thingstud.io"
        //            host: "iot.eclipse.org"
        //            host: "192.168.1.107"
        host: ipaddress.text
        port: 1883
        topic: "hello"
        username: "guest"
        password: "guest"
        onMessageReceived: {;
            _ListModel_Messages.append({"message":message});
        }
        onDisconnected: {
            _MQTT.connect();
        }
    }

    ListModel {
        id: _ListModel_Messages
    }

    Page {
        id: page
        title: i18n.tr("mqtt")

        Rectangle {
            radius: 5
            color: "#ffffff"
            anchors.fill: _ListView
        }

        TextField {
            id: ipaddress
            anchors.left: parent.left
            anchors.right: parent.right
            text: "192.168.1.107"
        }

        ListView {
            id: _ListView
            clip: true
            anchors.top: ipaddress.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 20; anchors.rightMargin: 20
            anchors.bottom: _TextArea.top
            highlightMoveDuration: 450
            cacheBuffer: 10000
            model: _ListModel_Messages
            onCountChanged: if(count>1) currentIndex=count-1; else currentIndex = 0;
            delegate: Rectangle {
                height: 60
                width: ListView.view.width
                radius: 5
                Text {
                    anchors.fill: parent
                    anchors.margins: 15
                    color: "#000000"
                    text: model.message
                    wrapMode: Text.WordWrap
                }
                Rectangle {
                    width: parent.width
                    height: 1
                    color: "#f1f1f1"
                    anchors.bottom: parent.bottom
                }
            }
        }

        Rectangle {
            anchors.fill: _TextArea
            color: "grey"
            radius: 5
            anchors.margins: -15
        }

        TextEdit {
            id: _TextArea
            anchors.bottom: control.top
            anchors.bottomMargin: 20
            anchors.leftMargin: 35
            anchors.rightMargin: 35
            anchors.left: parent.left
            anchors.right: parent.right
            height: 140
            font.pixelSize: 50

            Keys.onReturnPressed: {
                console.log("enter is pressed!")
                Qt.inputMethod.hide();
             }
        }

        Row {
            id: control
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 20

            Button {
                id: sendMessage
                text: "Send Message"
                onClicked: {
                    console.log("Going to publish message: " + _TextArea.text)
                    _MQTT.publishMessage(_TextArea.text);
                    _TextArea.text = "";
                    Qt.inputMethod.hide();
                }
            }
        }
    }
}

