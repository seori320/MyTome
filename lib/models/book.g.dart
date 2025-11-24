// GENERATED CODE - MANUALLY WRITTEN FOR OFFLINE USE
// ignore_for_file: type=lint

import 'package:hive/hive.dart';
import 'book.dart';

class BookAdapter extends TypeAdapter<Book> {
  @override
  final int typeId = 1;

  @override
  Book read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return Book(
      id: fields[0] as String,
      title: fields[1] as String,
      content: fields[2] as String,
      updatedAt: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Book obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.content)
      ..writeByte(3)
      ..write(obj.updatedAt);
  }
}
