import 'package:flutter/material.dart';

class Note {
  final String id;
  final bool pinned;
  final String title;
  final String content;
  final DateTime edited;
  final String? folderID;
  final DateTime created;
  final Color? titleColor;
  final DateTime? reminder;
  final int notificationID;
  final Color? contentColor;
  final int? backgroundIndex;
  final List<String> labelIDs;

  const Note({
    this.folderID,
    this.reminder,
    this.titleColor,
    this.contentColor,
    this.pinned = false,
    this.backgroundIndex,
    required this.id,
    required this.title,
    required this.edited,
    required this.content,
    required this.created,
    required this.labelIDs,
    required this.notificationID,
  });

  @override
  bool operator ==(other) {
    return (other is Note) && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  Note addLabel(String id) => copyWith(labelIDs: labelIDs..add(id));

  Note removeLabel(String id) => copyWith(labelIDs: labelIDs..remove(id));

  factory Note.fromMap(Map map) {
    final id = map['id'];
    final title = map['title'];
    final pinned = map['pinned'];
    final content = map['content'];
    final folderID = map['folderID'];
    final labelIDs = List<String>.from(map['labelIDS'] ?? []);
    final notificationID = map['notificationID'];
    final edited = DateTime.parse(map['edited']);
    final created = DateTime.parse(map['created']);
    final backgroundIndex = map['backgroundIndex'];
    final reminder = DateTime.tryParse(map['reminder'] ?? '');
    final titleColor = map['titleColor'] != null ? Color(map['titleColor']) : null;
    final contentColor = map['contentColor'] != null ? Color(map['contentColor']) : null;

    return Note(
      id: id,
      title: title,
      edited: edited,
      pinned: pinned,
      created: created,
      content: content,
      reminder: reminder,
      folderID: folderID,
      labelIDs: labelIDs,
      titleColor: titleColor,
      contentColor: contentColor,
      notificationID: notificationID,
      backgroundIndex: backgroundIndex,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};

    map['id'] = this.id;
    map['title'] = this.title;
    map['pinned'] = this.pinned;
    map['content'] = this.content;
    map['labelIDS'] = this.labelIDs;
    map['folderID'] = this.folderID;
    map['titleColor'] = this.titleColor?.value;
    map['notificationID'] = this.notificationID;
    map['backgroundIndex'] = this.backgroundIndex;
    map['contentColor'] = this.contentColor?.value;
    map['edited'] = this.edited.toIso8601String();
    map['created'] = this.created.toIso8601String();
    map['reminder'] = this.reminder?.toIso8601String();

    return map;
  }

  Note copyWith({
    bool? pinned,
    String? password,
    String? folderID,
    DateTime? edited,
    int? notificationID,
    List<String>? labelIDs,
    bool acceptNullFolderID = false,
  }) {
    return Note(
      id: this.id,
      title: this.title,
      created: this.created,
      content: this.content,
      reminder: this.reminder,
      titleColor: this.titleColor,
      edited: edited ?? this.edited,
      pinned: pinned ?? this.pinned,
      contentColor: this.contentColor,
      labelIDs: labelIDs ?? this.labelIDs,
      backgroundIndex: this.backgroundIndex,
      notificationID: notificationID ?? this.notificationID,
      folderID: acceptNullFolderID ? null : folderID ?? this.folderID,
    );
  }
}
