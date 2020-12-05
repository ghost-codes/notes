import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notez/constants/constants.dart';
import 'package:notez/models/label_model.dart';

class LabelsProvider with ChangeNotifier {
  final Map<String, Label> _userLabelsMap = {};

  void _notifyMap([Function(Map<String, Label> data) modify]) {
    if (modify != null) modify(_userLabelsMap);
    notifyListeners();
  }

  List getLabels() {
    return _userLabelsMap.values.toList();
  }

  Label getLabelById(String labelId) {
    return _userLabelsMap[labelId];
  }

  Future<void> fetchUserLabels(String userId) async {
    try {
      // final _userLabels =
      QuerySnapshot snapshot =
          await labelsRef.doc(userId).collection('userLabels').get();

      final _userLabels = snapshot.docs;

      final _labelsModel =
          _userLabels.map((e) => Label.fromDocument(e)).toList();

      for (final doc in _labelsModel) {
        _notifyMap((map) => map[doc.labelId] = doc);
      }
    } catch (_) {}
  }
}
