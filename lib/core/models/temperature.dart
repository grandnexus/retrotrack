import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'temperature.g.dart';

@HiveType(typeId: 0)
class Temperature extends HiveObject {
  Temperature({
    this.photo,
    this.originalPhoto,
    this.translatedText,
    this.temperature,
    this.boundingBox,
  });

  @HiveField(0)
  Image photo;

  @HiveField(1)
  final CustomPaint originalPhoto;

  @HiveField(2)
  final String translatedText;

  @HiveField(3)
  final double temperature;

  @HiveField(4)
  final Rect boundingBox;
}
