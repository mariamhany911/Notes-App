import 'package:sec_app/models/note.dart';
import 'package:hive_flutter/adapters.dart';

class HiveService {
  //CRUD
  HiveService._privateConstructor();
  static final HiveService instance = 
               HiveService._privateConstructor();

  final String _notesDatabaseName = 'db';
  late final Box<Note> _box;
   
  
  Future<void> initializeDatabase() async{
    await Hive.initFlutter();
    Hive.registerAdapter(NoteAdapter());
    _box = await Hive.openBox<Note>(_notesDatabaseName);
  }

  //create
  Future<void> addNote(Note note) async{
    await _box.put(note.title,note);
  }

  //read
  List<Note> getAll(){
    return _box.values.toList();
  }

  Note? getNote(String title){
    return _box.get(title);
  }

  //update
  Future<Note> updateNote(String title , Note newNote) async{
          await _box.put(newNote.title, newNote);
          return newNote;
  }

  //delete
  Future<void> deleteNote(String title) async{
    await _box.delete(title);
  }

}