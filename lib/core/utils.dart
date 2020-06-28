import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart' as dart_image;

import 'package:path_provider/path_provider.dart';
import 'package:retrotrack/core/models/index.dart';

import 'package:retrotrack/core/paints.dart';

String generateId() {
  const int min = 1000000;
  const int max = 9999999;
  String random7Digits() => (min + Random().nextInt(max - min)).toString();

  final DateTime now = DateTime.now();
  final String year = (now.year % 100).toString();
  final String month = (now.month).toString().padLeft(2, '0');
  final String day = (now.day).toString().padLeft(2, '0');
  final String hour = (now.hour).toString().padLeft(2, '0');
  final String minute = (now.minute).toString().padLeft(2, '0');
  final String second = (now.second).toString().padLeft(2, '0');
  final String randomSequence = random7Digits().toString();
  return '$year$month$day$hour$minute$second$randomSequence';
}

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
      digits = double.parse(numberText);
      if (digits > 100) {
        digits /= 10;
      }
    }
  }

  return digits;
}

Future<ui.Image> convertCustomPaintToImage(
    BoundingBoxPainter customPaint, Size size) async {
  final ui.PictureRecorder recorder = ui.PictureRecorder();
  final Canvas canvas = Canvas(recorder);

  customPaint.paint(canvas, size);
  return await recorder
      .endRecording()
      .toImage(size.width.floor(), size.height.floor());
}

Future<String> saveImageToPath(ui.Image image) async {
  final ByteData pngBytes =
      await image.toByteData(format: ui.ImageByteFormat.png);
  final String imageName = generateId();
  final Directory directory = await getExternalStorageDirectory();
  final String path = directory.path;
  final String imagePath = '$path/images/$imageName.png';

  await Directory('$path/images').create(recursive: true);
  File('$path/images/$imageName.png')
      .writeAsBytesSync(pngBytes.buffer.asInt8List());

  return imagePath;
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

    final Directory directory = await getExternalStorageDirectory();
    final String path = directory.path;
    final String imagePath = '$path/images/${generateId()}.png';
    File(imagePath).writeAsBytesSync(jpgInt);

    images.add(croppedImage);

    people.add(
      Person(
        1,
        now,
        imagePath,
        temperature: Temperature(temperature: 0.0),
        photo: croppedImage,
      ),
    );
  }

  final BoundingBoxPainter painter = BoundingBoxPainter(
    rect: boundingBoxes,
    imageFile: image,
  );

  final CustomPaint paint = CustomPaint(painter: painter);

  final ui.Image customImage = await convertCustomPaintToImage(
      painter, Size(image.width.toDouble(), image.height.toDouble()));

  final String imagePath = await saveImageToPath(customImage);

  final LogEntry logEntry = LogEntry(
    photoUrl: imagePath,
    photo: paint,
    detectedFaces: images,
    people: people,
  );

  faceDetector.close();

  return logEntry;
}

Future<Temperature> processThermometerImage(File imageFile) async {
  Rect boundingBox;
  Image croppedImage;
  String croppedImagePath;
  String temperatureString;
  double temperatureValue = 0.0;
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
      final Directory directory = await getExternalStorageDirectory();
      final String path = directory.path;
      croppedImagePath = '$path/images/${generateId()}.png';
      File(croppedImagePath).writeAsBytesSync(jpgInt);
    }
  }

  if (isTemperatureFound) {
    final BoundingBoxPainter painter = BoundingBoxPainter(
      rect: <Rect>[boundingBox],
      imageFile: image,
    );

    final CustomPaint paint = CustomPaint(painter: painter);

    final ui.Image customImage = await convertCustomPaintToImage(
        painter, Size(image.width.toDouble(), image.height.toDouble()));

    final String imagePath = await saveImageToPath(customImage);

    temperature = Temperature(
      photo: croppedImage,
      photoUrl: croppedImagePath,
      originalPhoto: paint,
      originalPhotoUrl: imagePath,
      translatedText: temperatureString,
      temperature: temperatureValue,
      boundingBox: boundingBox,
    );
  }

  textRecognizer.close();

  return temperature;
}

Future<File> compressImageFile(File file, String targetPath) async {
  final File result = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path,
    targetPath,
    quality: 100,
  );

  return result;
}
