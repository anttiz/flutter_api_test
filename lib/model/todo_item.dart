class TodoItem {
  final String name;
  final String todoId;
  TodoItem({required this.todoId, required this.name});

  factory TodoItem.fromJson(json) {
    return TodoItem(name: json['name'], todoId: json['todoId']);
  }

  static List<String> columns = ['name', 'todoId'];

  Map<String, dynamic> _toMap() {
    return {
      'name': name,
      'todoId': todoId,
    };
  }

  dynamic get(String propertyName) {
    var mapRep = _toMap();
    if (mapRep.containsKey(propertyName)) {
      return mapRep[propertyName];
    }
    throw ArgumentError('property not found');
  }
}
