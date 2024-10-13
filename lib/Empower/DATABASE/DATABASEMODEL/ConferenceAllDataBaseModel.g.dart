// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ConferenceAllDataBaseModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ConferenceAllDataBaseModelAdapter
    extends TypeAdapter<ConferenceAllDataBaseModel> {
  @override
  final int typeId = 19;

  @override
  ConferenceAllDataBaseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ConferenceAllDataBaseModel(
      responseBody: (fields[0] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, ConferenceAllDataBaseModel obj) {
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
      other is ConferenceAllDataBaseModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
