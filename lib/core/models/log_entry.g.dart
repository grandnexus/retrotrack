// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'log_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LogEntryAdapter extends TypeAdapter<LogEntry> {
  @override
  final typeId = 3;

  @override
  LogEntry read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LogEntry(
      fields[0] as CustomPaint,
      (fields[1] as List)?.cast<Image>(),
      (fields[2] as List)?.cast<Person>(),
    );
  }

  @override
  void write(BinaryWriter writer, LogEntry obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.photo)
      ..writeByte(1)
      ..write(obj.detectedFaces)
      ..writeByte(2)
      ..write(obj.people);
  }
}
