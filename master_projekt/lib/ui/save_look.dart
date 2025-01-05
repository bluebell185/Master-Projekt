import 'dart:io';

import 'package:master_projekt/main.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

saveLook() {
  Future<File> currentLookImage = deepArController.takeScreenshot();
  saveImageToGallery(currentLookImage);
}

// Future<void> saveToGalleryOld(Future<File> currentLookImage) async {
//   try {
//     // Datei in Uint8List konvertieren
//     final File imageFile = await currentLookImage;
//     final Uint8List bytes = await imageFile.readAsBytes();

//     // Bild in Galerie speichern
//     final result = await ImageGallerySaver.saveImage(bytes);
//     if (result["isSuccess"] == true) {
//       print("Image saved to gallery.");
//     } else {
//       print("Failed to save image to gallery.");
//     }
//   } catch (e) {
//     print("Error saving image: $e");
//   }
// }

// Future<bool> requestStoragePermission() async {
//   // Berechtigungen anfragen (auf Android, ignoriert auf iOS)
//   final status = await Permission.storage.request();
//   return status.isGranted;
// }

// Future<void> saveImageToGalleryOld(Future<File> currentLookImage) async {
//   if (Platform.isAndroid) {
//     // Berechtigungen nur für Android erforderlich
//     if (await requestStoragePermission()) {
//       await saveToGallery(currentLookImage);
//     } else {
//       print("Storage permission denied.");
//     }
//   } else if (Platform.isIOS) {
//     // Auf iOS keine explizite Berechtigung erforderlich
//     await saveToGallery(currentLookImage);
//   }
// }

Future<void> saveImageToGallery(Future<File> currentLookImage) async {
  try {
    // Datei aus der Variable erhalten
    final File imageFile = await currentLookImage;

    // Berechtigungen für Android anfragen
    if (Platform.isAndroid) {
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        print("Storage permission denied.");
        return;
      }
    }

// TODO: internal??
final directory = await getApplicationDocumentsDirectory();

    // Zielverzeichnis ermitteln
    final Directory? externalDir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();

    if (externalDir == null) {
      print("Failed to get external directory.");
      return;
    }

    final String targetDirPath = Platform.isAndroid
        ? "${externalDir.parent.parent.parent.parent.path}/Aissistant-Looks"
        : "${externalDir.path}/Aissistant-Looks"; // Für iOS bleibt das im App-Sandbox-Ordner.

    // Verzeichnis erstellen, falls es nicht existiert
    final Directory targetDir = Directory(targetDirPath);
    if (!targetDir.existsSync()) {
      targetDir.createSync(recursive: true);
    }

    // Bild in das Zielverzeichnis kopieren
    final String targetPath = "${targetDir.path}/Aissistant-Look-${DateTime.now().millisecondsSinceEpoch}.png";
    final File savedImage = await imageFile.copy(targetPath);

    print("Image saved at: $targetPath");

    // Für Android: Bild in der Galerie anzeigen
    if (Platform.isAndroid) {
      final result = await Process.run('am', ['broadcast', '-a', 'android.intent.action.MEDIA_SCANNER_SCAN_FILE', '-d', 'file://$targetPath']);
      print("Gallery refresh result: $result");
    }
  } catch (e) {
    print("Error saving image: $e");
  }
}



