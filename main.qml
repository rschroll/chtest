import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import Ubuntu.Components.Popups 0.1
import Ubuntu.Content 0.1

MainView {
    id: mainView
    applicationName: "chtest.rschroll"

    width: units.gu(100)
    height: units.gu(75)

    PageStack {
        id: pageStack
        Component.onCompleted: pageStack.push(root)

        Page {
            id: root
            title: i18n.tr("Import Content...")
            visible: false

            property var activeTransfer

            Column {
                anchors.fill: parent
                spacing: units.gu(2)
                Row {
                    height: units.gu(6)
                    anchors {
                        left: parent.left
                        right: parent.right
                        horizontalCenter: parent.horizontalCenter
                    }
                    spacing: units.gu(3)
                    Button {
                        text: i18n.tr("... From default provider")
                        onClicked: {
                            root.activeTransfer = peer.request();
                        }
                    }
                    Button {
                        text: i18n.tr("... From choosen provider")
                        onClicked: {
                            pageStack.push(picker);
                        }
                    }
                }

                Label {
                    id: label
                    width: parent.width
                }

                Image {
                    id: image
                    width: parent.width
                }
            }

            function importItems(items) {
                var string = "";
                for (var i = 0; i < items.length; i++) {
                    string += i + ") " + items[i].url + "\n";
                    image.source = items[i].url;
                    /* You may want to use items[i].move() to put the content somewhere permanent. */
                }
                label.text = string;
            }

            /* The ContentPeer sets the kinds of content that can be imported.  For some reason,
               handler must be set to Source to indicate that the app is importing.  This seems
               backwards to me. */
            ContentPeer {
                id: peer
                contentType: ContentType.Pictures
                handler: ContentHandler.Source
                selectionType: ContentTransfer.Multiple
            }

            /* This is a GUI element that blocks the rest of the UI when a transfer is ongoing. */
            ContentTransferHint {
                anchors.fill: root
                activeTransfer: root.activeTransfer
            }

            /* Watch root.activeTransfer to find out when content is ready for our use. */
            Connections {
                target: root.activeTransfer
                onStateChanged: {
                    if (root.activeTransfer.state === ContentTransfer.Charged)
                        root.importItems(root.activeTransfer.items);
                }
            }
        }

        Page {
            id: picker
            visible: false
            /* This presents a grid of icons for apps that can give you content of the
               specified type. */
            ContentPeerPicker {
                id: peerPicker
                visible: parent.visible

                handler: ContentHandler.Source  // Source to get content, for some reason
                contentType: ContentType.Pictures

                onPeerSelected: {
                    peer.selectionType = ContentTransfer.Multiple;
                    root.activeTransfer = peer.request();
                    pageStack.pop();
                }
            }
        }
    }
}
