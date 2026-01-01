import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:to_do_app/data/model/note.dart';

class NoteRepository {
  List<Note> _notes = [];
  List<Note> get notes => _notes;

  Future<void> loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedNotes = prefs.getString('notes');
    if (savedNotes != null) {
      final List<dynamic> noteList = json.decode(savedNotes);
      _notes = noteList.map((n) => Note.fromMap(n)).toList();
    }
  }

  Future<void> saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = json.encode(_notes.map((n) => n.toMap()).toList());
    await prefs.setString('notes', encoded);
  }

  void addNote(Note note) {
    _notes.insert(0, note); // Newest first
    saveNotes();
  }

  void removeNote(String id) {
    _notes.removeWhere((n) => n.id == id);
    saveNotes();
  }
}
