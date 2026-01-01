import '../../data/model/note.dart';
import '../../data/repository/note_repo.dart';

class NoteViewModel {
  final NoteRepository _repo = NoteRepository();

  List<Note> get notes => _repo.notes;

  // Initialize data
  Future<void> loadNotes() async {
    await _repo.loadNotes();
  }

  void addNote(String title, String content) {
    if (title.isEmpty && content.isEmpty) return;

    final newNote = Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      content: content,
      createdAt: DateTime.now(),
    );

    _repo.addNote(newNote);
  }

  void updateNote(String id, String title, String content) {
    final noteIndex = _repo.notes.indexWhere((n) => n.id == id);
    if (noteIndex != -1) {
      final note = _repo.notes[noteIndex];
      note.title = title;
      note.content = content;
      _repo.saveNotes();
    }
  }

  void deleteNote(String id) {
    _repo.removeNote(id);
  }
}
