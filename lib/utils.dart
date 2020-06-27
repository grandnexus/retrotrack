import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as dart_image;
import 'package:retrotrack/models.dart';
import 'package:retrotrack/paints.dart';

bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}

double convertRawTextToTemperature(String rawText) {
  double digits = 0.0;
  final String numberText =
      rawText.replaceAll(RegExp(r'([a-zA-Z])\w+'), '').trim();

  if (numberText.isNotEmpty) {
    if (isNumeric(numberText)) {
      digits = double.parse(numberText) / 10;
    }
  }

  return digits;
}

Future<LogEntry> processCropFaceImage(File imageFile) async {
  final DateTime now = DateTime.now();
  final List<Image> images = <Image>[];
  final List<Rect> boundingBoxes = <Rect>[];
  final List<Person> people = <Person>[];

  final Uint8List uImage = await imageFile.readAsBytes();

  final ui.Image image = await decodeImageFromList(uImage);
  final dart_image.Image dImage = dart_image.decodeJpg(uImage);
  final FirebaseVisionImage visionImage =
      FirebaseVisionImage.fromFile(imageFile);
  final FaceDetector faceDetector = FirebaseVision.instance.faceDetector();
  final List<Face> detectedFaces = await faceDetector.processImage(visionImage);

  for (final Face face in detectedFaces) {
    boundingBoxes.add(face.boundingBox);

    final List<int> jpgInt = dart_image.encodeJpg(
      dart_image.copyCrop(
        dImage,
        face.boundingBox.topLeft.dx.toInt(),
        face.boundingBox.topLeft.dy.toInt(),
        face.boundingBox.width.toInt(),
        face.boundingBox.height.toInt(),
      ),
    );
    final Image croppedImage = Image.memory(jpgInt as Uint8List);

    images.add(croppedImage);
    people.add(Person(1, now, croppedImage));
  }

  final LogEntry logEntry = LogEntry(
    CustomPaint(
      painter: BoundingBoxPainter(
        rect: boundingBoxes,
        imageFile: image,
      ),
    ),
    images,
    people,
  );

  faceDetector.close();

  return logEntry;
}

Future<Temperature> processThermometerImage(File imageFile) async {
  Rect boundingBox;
  Image croppedImage;
  String temperatureString;
  double temperatureValue;
  bool isTemperatureFound = false;
  Temperature temperature;

  final Uint8List uImage = await imageFile.readAsBytes();
  final ui.Image image = await decodeImageFromList(uImage);
  final dart_image.Image dImage = dart_image.decodeJpg(uImage);
  final FirebaseVisionImage visionImage =
      FirebaseVisionImage.fromFile(imageFile);
  final TextRecognizer textRecognizer =
      FirebaseVision.instance.textRecognizer();
  final VisionText visionText = await textRecognizer.processImage(visionImage);

  for (final TextBlock block in visionText.blocks) {
    boundingBox = block.boundingBox;

    final double tempCandidate = convertRawTextToTemperature(block.text);

    // if temperature is within valid range.
    if (tempCandidate > 20 && tempCandidate < 50) {
      isTemperatureFound = true;
      temperatureString = block.text;
      temperatureValue = tempCandidate;

      final List<int> jpgInt = dart_image.encodeJpg(
        dart_image.copyCrop(
          dImage,
          block.boundingBox.topLeft.dx.toInt(),
          block.boundingBox.topLeft.dy.toInt(),
          block.boundingBox.width.toInt(),
          block.boundingBox.height.toInt(),
        ),
      );
      croppedImage = Image.memory(jpgInt as Uint8List);
    }
  }

  if (isTemperatureFound) {
    temperature = Temperature(
      croppedImage,
      CustomPaint(
        painter: BoundingBoxPainter(
          rect: <Rect>[boundingBox],
          imageFile: image,
        ),
      ),
      temperatureString,
      temperatureValue,
      boundingBox,
    );
  }

  textRecognizer.close();

  return temperature;
}
