// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class favoriteModelAdapter extends TypeAdapter<favoriteModel> {
  @override
  final int typeId = 0;

  @override
  favoriteModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return favoriteModel(
      image: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      rating: fields[3] as String,
      price: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, favoriteModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.image)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.rating)
      ..writeByte(4)
      ..write(obj.price);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is favoriteModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
