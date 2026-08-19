import 'package:hive/hive.dart';

part 'note.g.dart';

@HiveType(typeId: 0)

class Note{
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String content;
  @HiveField(2)
   bool isFav;

  Note({
    required this.content,
    required this.title,
    this.isFav=false
  });
  
}