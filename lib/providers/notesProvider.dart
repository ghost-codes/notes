import 'package:flutter/material.dart';
import 'package:notez/constants/constants.dart';
import 'package:notez/models/models.dart';
import 'package:notez/models/note_model.dart';
// import 'package:provider/provider.dart';

class NotesProvider with ChangeNotifier {
  PageController pageController = PageController(initialPage: 0);
  String searchController;
  String userId = "hope";
  // String message ;
  String title = "Untitled Note";
  int _pageIndex = 0;
  List<Userr> selectedUsers = [];

  addToSelectedUsers(Userr user) {
    selectedUsers.add(user);
    notifyListeners();
  }

  removeFromSelectedUsers(Userr user) {
    selectedUsers.remove(user);
    notifyListeners();
  }

  setSearchController(String value) {
    searchController = value;
    notifyListeners();
  }

  addNote(Note note, Userr currentUser) async {
    await notesRef
        .doc(currentUser.uid)
        .collection("userNotes")
        .doc(note.noteId)
        .set({
      "note": note.message,
      "otherUsers": note.otherUsers,
      "title": note.title,
      "noteId": note.noteId,
      "pinned": note.pinned,
      "label": note.label,
      "timeStamp": note.timeStamp,
    });

    notifyListeners();
  }

  int getPageIndex() {
    return _pageIndex;
  }

  setPageIndex(int page) {
    _pageIndex = page;
    pageController.jumpToPage(
      page,
    );
    // duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
    notifyListeners();
  }

  setTtile(String text) {
    if (text.trim().length > 0) {
      title = text;
    } else {
      title = "Untitled Note";
    }
    notifyListeners();
  }
}
