class AnimatableCardEntranceController {
  static final _instance = AnimatableCardEntranceController._internal();

  static AnimatableCardEntranceController get instance => _instance;

  AnimatableCardEntranceController._internal();

  final _elements = <String>[];

  void add(String id) => _elements.add(id);
  void remove(String id) => _elements.remove(id);
  bool contains(String id) => _elements.contains(id);
}
