import QtQuick
import QtQuick.Controls
// uusi import-komento
import QtQuick.Layouts

import org.qfield
import Theme

Item {
  id: examplePlugin

  property var mainWindow: iface.mainWindow()

  // tallennetaan muutama olio, joita
  // tarvitaan myöhemmin
  property var layerTree: iface.findItemByObjectName('dashBoard').layerTree
  property var mapSettings: iface.mapCanvas().mapSettings

  Dialog {
	id: dialog
	parent: mainWindow.contentItem

	title: "Example plugin"

	visible: false
	modal: true
	focus: true

	font: Theme.defaultFont

	x: (parent.width - width) / 2
	y: (parent.height - height) / 2

	width: 300
	height: 400

	standardButtons: Dialog.Close

	// käytetään Column- ja RowLayouteja
	// järjestelemään eri käyttöliittymän
	// komponentit
	ColumnLayout {
  	spacing: 10

  	RowLayout {
    	Layout.fillWidth: true

    	// lisätään toimintoa kuvaava
    	// tekstikenttä (Label)
    	Label {
      	text: "Text Input:"
      	font: Theme.defaultFont
      	color: Theme.mainTextColor

      	Layout.fillWidth: true
    	}

    	// lisätään teksikenttä, johon käyttäjä
    	// voi kirjoittaa tekstiä
    	QfTextField {
      	id: textField
      	text: "Hello"

      	Layout.fillWidth: true
      	Layout.preferredWidth: 100
      	Layout.preferredHeight: font.height + 20

      	horizontalAlignment: TextInput.AlignHCenter

      	font: Theme.defaultFont

      	enabled: true
      	visible: true
    	}

    	// lisätään painike
    	QfToolButton {
      	id: textFieldButton

      	bgcolor: Theme.darkGraySemiOpaque
      	round: true

      	Text {
        	anchors.centerIn: parent
        	text: "Toast"
        	color: Theme.light
      	}

      	onClicked: {
        	// näytetään tekstikentän teksti
        	mainWindow.displayToast(textField.text);
      	}
    	}
  	}

  	RowLayout {
    	Layout.fillWidth: true

    	Label {
      	text: "List layers"
      	font: Theme.defaultFont
      	color: Theme.mainTextColor

      	Layout.fillWidth: true
    	}

    	QfToolButton {
      	id: listLayersButton

      	bgcolor: Theme.darkGraySemiOpaque
      	round: true

      	Text {
        	anchors.centerIn: parent
        	text: "List"
        	color: Theme.light
      	}

      	onClicked: {
        	let list = "Layers:";

        	// iteroidaan layerTree-olion rivejä
        	for (let i = 0; i < layerTree.rowCount(); i++) {
          	let index = layerTree.index(i, 0);
          	// haetaan tason nimi
          	let name = layerTree.data(index, FlatLayerTreeModel.Name);
          	list = list.concat("\n", name);
        	}

        	mainWindow.displayToast(list);
      	}
    	}
  	}

  	Label {
    	text: "Jump To Coordinates (WGS 84)"
    	font: Theme.defaultFont
    	color: Theme.mainTextColor
  	}

  	RowLayout {
    	Layout.fillWidth: true

    	Label {
      	text: "X"
      	font: Theme.defaultFont
      	color: Theme.mainTextColor

      	Layout.fillWidth: true
    	}

    	QfTextField {
      	id: xField
      	text: "0"

      	Layout.fillWidth: true
      	Layout.preferredWidth: 30
      	Layout.preferredHeight: font.height + 20

      	horizontalAlignment: TextInput.AlignHCenter

      	font: Theme.defaultFont

      	enabled: true
      	visible: true

      	inputMethodHints: Qt.ImhFormattedNumbersOnly
    	}

    	Label {
      	text: "Y"
      	font: Theme.defaultFont
      	color: Theme.mainTextColor

      	Layout.fillWidth: true
    	}

    	QfTextField {
      	id: yField
      	text: "0"

      	Layout.fillWidth: true
      	Layout.preferredWidth: 30
      	Layout.preferredHeight: font.height + 20

      	horizontalAlignment: TextInput.AlignHCenter

      	font: Theme.defaultFont

      	enabled: true
      	visible: true

      	inputMethodHints: Qt.ImhFormattedNumbersOnly
    	}

    	QfToolButton {
      	id: addFeatureButton

      	bgcolor: Theme.darkGraySemiOpaque
      	round: true

      	Text {
        	anchors.centerIn: parent
        	text: "Jump"
        	color: Theme.light
      	}

      	onClicked: {
        	let x = Number(xField.text);
        	let y = Number(yField.text);

        	if (isNaN(x) || isNaN(y))
        	{
          	mainWindow.displayToast('Invalid input!', 'error');
          	return;
        	}
        	mainWindow.displayToast('Jumping to (x: ' + xField.text + ', y: ' + yField.text + ')');

        	// luodaan piste käyttäjän antamista koordinaateista
        	let point = GeometryUtils.point(x, y);

        	// muunnetaan piste projektin koordinaattijärjestelmään
        	let reprojected_point = GeometryUtils.reprojectPoint(point, CoordinateReferenceSystemUtils.wgs84Crs(), mapSettings.destinationCrs);

        	// siirretään karttanäkymän keskikohta projisoituun pisteeseen
        	mapSettings.setCenter(reprojected_point);
      	}
    	}
  	}
	}
  }


  QfToolButton {
	id: pluginButton

	bgcolor: Theme.darkGraySemiOpaque
	round: true

	Text {
  	anchors.centerIn: parent
  	text: "Dialog"
  	color: Theme.light
	}

	onClicked: {
  	dialog.open();
	}
  }

  Component.onCompleted: {
	iface.addItemToPluginsToolbar(pluginButton)
  }
}