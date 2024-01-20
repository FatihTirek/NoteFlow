class Folder {
  final String id;
  final String name;
  final DateTime created;
  final int numberOfNotes;

  const Folder({
    this.numberOfNotes = 0,
    required this.id,
    required this.name,
    required this.created,
  });

  Folder increaseNumber() => copyWith(numberOfNotes: this.numberOfNotes + 1);

  Folder decreaseNumber() => copyWith(numberOfNotes: this.numberOfNotes - 1);

  factory Folder.fromMap(Map map) {
    final id = map['id'];
    final name = map['name'];
    final created = DateTime.parse(map['created']);
    final numberOfNotes = map['numberOfNotes'] ?? 0;

    return Folder(
      id: id,
      name: name,
      created: created,
      numberOfNotes: numberOfNotes,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};

    map['id'] = this.id;
    map['name'] = this.name;
    map['numberOfNotes'] = this.numberOfNotes;
    map['created'] = this.created.toIso8601String();

    return map;
  }

  Folder copyWith({String? name, int? numberOfNotes}) {
    return Folder(
      id: this.id,
      created: this.created,
      name: name ?? this.name,
      numberOfNotes: numberOfNotes ?? this.numberOfNotes,
    );
  }
}
