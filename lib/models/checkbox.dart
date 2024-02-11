// class Checkbox {
//   final String id;
//   final bool checked;
//   final String index;
//   final String noteID;
//   final String content;

//   const Checkbox({
//     this.checked = false,
//     required this.id,
//     required this.index,
//     required this.noteID,
//     required this.content,
//   });

//   factory Checkbox.fromMap(Map map) {
//     final id = map['id'];
//     final index = map['index'];
//     final noteID = map['noteID'];
//     final content = map['content'];
//     final checked = map['checked'];

//     return Checkbox(
//       id: id,
//       index: index,
//       noteID: noteID,
//       checked: checked,
//       content: content,
//     );
//   }

//   Map<String, dynamic> toMap(Checkbox checkbox) {
//     final map = <String, dynamic>{};

//     map['id'] = checkbox.id;
//     map['index'] = checkbox.index;
//     map['noteID'] = checkbox.noteID;
//     map['content'] = checkbox.content;
//     map['checked'] = checkbox.checked;

//     return map;
//   }

//   Checkbox copyWith({String? content, bool? checked, String? index}) {
//     return Checkbox(
//       id: this.id,
//       noteID: this.noteID,
//       index: index ?? this.index,
//       content: content ?? this.content,
//       checked: checked ?? this.checked,
//     );
//   }
// }
