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
            title: i18n.tr("Imported Content")
            visible: false

            property var activeTransfer

            Column {
                anchors.fill: parent
                spacing: units.gu(2)

                Label {
                    id: label
                    width: parent.width
                    text: "Push pictures to this app from any other"
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

            /* Listen to the ContentHub to find out if another apps wants us to import content. */
            Connections {
                target: ContentHub
                onImportRequested: {
                    root.activeTransfer = transfer;
                    if (root.activeTransfer.state === ContentTransfer.Charged)
                        root.importItems(root.activeTransfer.items);
                }
            }
        }
    }
}
