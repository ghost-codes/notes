class Note {
  String title;
  String message;
  String noteId;
  bool pinned;
  String label;
  List otherUsers;
  int timeStamp;

  Note({
    this.title,
    this.noteId,
    this.message,
    this.pinned,
    this.label,
    this.otherUsers,
    this.timeStamp,
  });

  factory Note.fromDocument(doc) {
    return Note(
      otherUsers: doc["otherUsers"],
      title: doc["title"],
      message: doc["note"],
      noteId: doc["noteId"],
      pinned: doc["pinned"],
      timeStamp: doc["timeStamp"],
      label: doc["label"],
    );
  }
}
