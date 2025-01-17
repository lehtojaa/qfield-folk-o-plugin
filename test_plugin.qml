import QtQuick 
import org.qfield


Item { // osa QtQuickia
  id: examplePlugin1 // määritellään tunniste lisäosalle

  // samoin kuin QGIS-lisäosissa käytössä on "iface"-muuttuja,
  // joka antaa pääsyn QFieldin eri komponentteihin
  // tallennetaan muuttujaan viittaus sovelluksen ikkunaan
  property var mainWindow: iface.mainWindow()

  // kun lisäosa on luotu se lähettää "completed()"
  // signaalin. Tässä määritellään ns. signal handler
  // johon kirjoitetaan JavaScriptillä mitä
  // halutaan tapahtuvan kun lisäosa on ladattu
  Component.onCompleted: {
	// tässä tapauksessa mainWindow-muuttujaa
	// hyödyntäen lähetetään viesti, joka
	// näkyy käyttöliittymässä hetken ajan
	mainWindow.displayToast('Hello world!');
  }
}