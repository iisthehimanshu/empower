// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SavedCardsModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SavedCardsModelAdapter extends TypeAdapter<SavedCardsModel> {
  @override
  final int typeId = 20;

  @override
  SavedCardsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SavedCardsModel(
      cardData: (fields[0] as Map).cast<String, Data>(),
    );
  }

  @override
  void write(BinaryWriter writer, SavedCardsModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.cardData);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavedCardsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
