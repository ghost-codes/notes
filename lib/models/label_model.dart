import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Label {
  String labelName;
  String labelId;
  Color labelColor;
  List labelNotesIds;
  int timeCreated;

  Label({
    this.labelColor,
    this.labelName,
    this.labelNotesIds,
    this.labelId,
    this.timeCreated,
  });

  factory Label.fromDocument(doc) {
    // String color = doc["labelColor"];

    return Label(
      labelColor: Color(doc["labelColor"]),
      labelName: doc["labelName"],
      labelId: doc["labelId"],
      labelNotesIds: doc["labelNoteIds"],
      timeCreated: doc["timeCreated"],
    );
  }
}
