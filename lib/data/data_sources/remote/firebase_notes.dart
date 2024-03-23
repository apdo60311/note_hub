import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:note_hub/data/data_sources/remote/remote_notes_source.dart';
import 'package:note_hub/data/data_sources/user/source/firebase_source_service.dart';
import 'package:note_hub/data/models/note/note.dart';
import 'package:note_hub/data/models/note/textual_note.dart';

class FirebaseNotesSource extends RemoteNotesSource {
  final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
  final _usersCollection = FirebaseFirestore.instance.collection('users');

  final _notesLimit = 8;

  @override
  Future addNewNote(Note newNote) async {
    newNote.creationTime = DateTime.timestamp().toString();
    _usersCollection
        .doc(currentUserId)
        .collection('notes')
        .add((newNote.toMap()))
        .then((noteRef) async {
      // update notes count
      var user = await UserFirebaseSourceService().getUserData(currentUserId);
      user.userProfile.notesCount++;

      // update bookmarked notes count
      if ((await noteRef.get()).data()!['isPinned'] == true) {
        user.userProfile.pinnedNotesCount++;
      }

      UserFirebaseSourceService().setUserData(currentUserId!, user.toMap());
      await noteRef.update({'id': noteRef.id});
    });
  }

  @override
  Future getNote(String noteId) {
    return _usersCollection
        .doc(currentUserId)
        .collection('notes')
        .doc(noteId)
        .get();
  }

  @override
  Future deleteNote(String noteId) async {
    var note =
        _usersCollection.doc(currentUserId).collection('notes').doc(noteId);

    return note.delete().then((value) async {
      // update notes count after deletion
      var user = await UserFirebaseSourceService().getUserData(currentUserId);
      user.userProfile.notesCount--;

      // update bookmarked notes count after deletion
      if ((await note.get()).data()!['isPinned'] == true) {
        user.userProfile.pinnedNotesCount--;
      }

      UserFirebaseSourceService().setUserData(currentUserId!, user.toMap());
    });
  }

  @override
  Future<List<Note>> getAllNotes() async {
    return _usersCollection.doc(currentUserId).collection('notes').get().then(
        (notes) =>
            notes.docs.map((e) => TextualNote.fromMap(e.data())).toList());
  }

  @override
  Future updateNote(String noteId, Note newData) async {
    var oldNote =
        _usersCollection.doc(currentUserId).collection('notes').doc(noteId);
    var oldNoteData = await oldNote.get();

    return oldNote.update(newData.toMap()).then((value) async {
      var user = await UserFirebaseSourceService().getUserData(currentUserId);

      if (oldNoteData.data()!['isPinned'] == true &&
          newData.isPinned == false) {
        user.userProfile.pinnedNotesCount--;
      } else if (oldNoteData.data()!['isPinned'] == false &&
          newData.isPinned == true) {
        user.userProfile.pinnedNotesCount++;
      }
      UserFirebaseSourceService().setUserData(currentUserId!, user.toMap());
    });
  }

  @override
  Future<List<Note>> getNotes([int? limit]) async {
    return _usersCollection
        .doc(currentUserId)
        .collection('notes')
        .orderBy("creationTime", descending: true)
        .limit(limit ?? _notesLimit)
        .get()
        .then((notes) =>
            notes.docs.map((e) => TextualNote.fromMap(e.data())).toList());
  }

  @override
  Future searchNotes(String text) {
    return _usersCollection
        .doc(currentUserId)
        .collection('notes')
        .where(Filter.and(Filter('title', isGreaterThanOrEqualTo: text),
            Filter('title', isLessThan: '${text}z')))
        .get()
        .then((notes) =>
            notes.docs.map((e) => TextualNote.fromMap(e.data())).toList());
  }

  @override
  Future getSavedNotes() {
    return _usersCollection
        .doc(currentUserId)
        .collection('notes')
        .where('isPinned', isEqualTo: true)
        .get()
        .then((notes) =>
            notes.docs.map((e) => TextualNote.fromMap(e.data())).toList());
  }
}
