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
      photoUrl: fields[0] as String,
      people: (fields[1] as List)?.cast<Person>(),
    );
  }

  @override
  void write(BinaryWriter writer, LogEntry obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.photoUrl)
      ..writeByte(1)
      ..write(obj.people);
  }
}
