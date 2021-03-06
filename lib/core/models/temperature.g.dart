// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'temperature.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TemperatureAdapter extends TypeAdapter<Temperature> {
  @override
  final typeId = 0;

  @override
  Temperature read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Temperature(
      photoUrl: fields[0] as String,
      originalPhotoUrl: fields[1] as String,
      translatedText: fields[2] as String,
      temperature: fields[3] as double,
      boundingBox: fields[4] as Rect,
    );
  }

  @override
  void write(BinaryWriter writer, Temperature obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.photoUrl)
      ..writeByte(1)
      ..write(obj.originalPhotoUrl)
      ..writeByte(2)
      ..write(obj.translatedText)
      ..writeByte(3)
      ..write(obj.temperature)
      ..writeByte(4)
      ..write(obj.boundingBox);
  }
}
