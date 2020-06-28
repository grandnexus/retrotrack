import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:retrotrack/core/models/index.dart' show Person;

part 'log_entry.g.dart';

@HiveType(typeId: 3)
class LogEntry extends HiveObject {
  LogEntry({
    this.photoUrl,
    this.people,
    this.photo,
    this.detectedFaces,
  });

  @HiveField(0)
  final String photoUrl;

  @HiveField(1)
  final List<Person> people;

  final CustomPaint photo;

  final List<Image> detectedFaces;
}
