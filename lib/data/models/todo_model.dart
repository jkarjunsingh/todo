class TodoModel {
  final String id;
  final String title;
  final String note;
  final DateTime dateTime;
  final bool isDone;

  TodoModel({
    required this.id,
    required this.title,
    required this.note,
    required this.dateTime,
    this.isDone = false,
  });

  factory TodoModel.fromFirestore(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'],
      title: json['title'],
      note: json['note'],
      dateTime: DateTime.fromMillisecondsSinceEpoch(json['dateTime']),
      isDone: json['isDone'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'title': title,
      'note': note,
      'dateTime': dateTime.millisecondsSinceEpoch,
      'isDone': isDone,
    };
  }
}
