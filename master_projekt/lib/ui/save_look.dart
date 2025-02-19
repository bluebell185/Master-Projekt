import 'dart:io';
import 'package:gal/gal.dart';
import 'package:master_projekt/main.dart';

saveLook() async {
  File currentLookImage = await deepArController.takeScreenshot();
  saveImageToGallery(currentLookImage);
}

Future<void> saveImageToGallery(File currentLookImage) async {
  await Gal.putImage(currentLookImage.path, album: "aissistant");
}
