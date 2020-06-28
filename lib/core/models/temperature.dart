import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'temperature.g.dart';

@HiveType(typeId: 0)
class Temperature extends HiveObject {
  Temperature({
    this.photoUrl,
    this.originalPhotoUrl,
    this.translatedText,
    this.temperature,
    this.boundingBox,
    this.photo,
    this.originalPhoto,
  });

  @HiveField(0)
  final String photoUrl;

  @HiveField(1)
  final String originalPhotoUrl;

  @HiveField(2)
  final String translatedText;

  @HiveField(3)
  double temperature;

  @HiveField(4)
  final Rect boundingBox;

  final CustomPaint originalPhoto;

  Image photo;
}
