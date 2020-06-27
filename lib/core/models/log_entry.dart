import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:retrotrack/core/models/index.dart' show Person;

part 'log_entry.g.dart';

@HiveType(typeId: 3)
class LogEntry extends HiveObject {
  LogEntry(
    this.photo,
    this.detectedFaces,
    this.people,
  );

  @HiveField(0)
  final CustomPaint photo;

  @HiveField(1)
  final List<Image> detectedFaces;

  @HiveField(2)
  final List<Person> people;
}
