class Task {
  int id;
  String title;
  String description;
  int priority;
  bool isDone;

  Task({
    this.id,
    this.title,
    this.description,
    this.priority,
    this.isDone = false,
  });

  factory Task.fromMap(Map<String, dynamic> json) => Task(
        id: json["id"],
        title: json["title"],
        priority: json["priority"],
        description: json["description"],
        isDone: json["isDone"] == 1,
      );

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id": id,
      "title": title,
      "priority": priority,
      "description": description,
      "isDone": isDone ? 1 : 0
    };

    if (id != null) map["id"] = id;

    return map;
  }
}