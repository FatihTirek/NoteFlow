class Label {
  final String id;
  final String name;
  final DateTime created;

  const Label({
    required this.id,
    required this.name,
    required this.created,
  });

  factory Label.fromMap(Map map) {
    final id = map['id'];
    final name = map['name'];
    final created = DateTime.parse(map['created']);

    return Label(
      id: id,
      name: name,
      created: created,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};

    map['id'] = this.id;
    map['name'] = this.name;
    map['created'] = this.created.toIso8601String();

    return map;
  }

  Label copyWith({String? name}) {
    return Label(
      id: this.id,
      created: this.created,
      name: name ?? this.name,
    );
  }
}
