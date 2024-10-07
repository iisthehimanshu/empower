// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ScheduleApiModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScheduleApiModelAdapter extends TypeAdapter<ScheduleApiModel> {
  @override
  final int typeId = 18;

  @override
  ScheduleApiModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ScheduleApiModel(
      responseBody: (fields[0] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, ScheduleApiModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.responseBody);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScheduleApiModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
