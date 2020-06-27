import 'package:flutter/material.dart';

class Person {
  const Person(this.id, this.timestamp, this.photo,
      {this.temperate, this.additionalInformation});

  final int id;
  final DateTime timestamp;
  final Image photo;
  final Temperature temperate;
  final String additionalInformation;
}

class LogEntry {
  const LogEntry(
    this.photo,
    this.detectedFaces,
    this.people,
  );

  final CustomPaint photo;
  final List<Image> detectedFaces;
  final List<Person> people;
}

class Temperature {
  const Temperature(
    this.photo,
    this.originalPhoto,
    this.translatedText,
    this.temperature,
    this.boundingBox,
  );
  final Image photo;
  final CustomPaint originalPhoto;
  final String translatedText;
  final double temperature;
  final Rect boundingBox;
}
