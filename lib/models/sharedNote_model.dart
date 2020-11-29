class SharedNote {
  // List<String> otherUsers;
  String ownerId;
  String noteId;

  SharedNote({
    this.noteId,
    this.ownerId,

  });

  factory SharedNote.fromDocument(doc) {
    return SharedNote(
      // otherUsers: doc["otherUsers"],
      noteId: doc["noteId"],
      ownerId: doc["ownerId"],
    );
  }
}
