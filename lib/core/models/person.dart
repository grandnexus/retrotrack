import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:retrotrack/core/models/index.dart' show Temperature;

part 'person.g.dart';

@HiveType(typeId: 1)
class Person extends HiveObject {
  Person(
    this.id,
    this.timestamp,
    this.photo, {
    this.temperature,
    this.additionalInformation,
  });

  @HiveField(0)
  final int id;

  @HiveField(1)
  final DateTime timestamp;

  @HiveField(2)
  final Image photo;

  @HiveField(3)
  final Temperature temperature;

  @HiveField(4)
  final String additionalInformation;
}
