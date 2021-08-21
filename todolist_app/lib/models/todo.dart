class Todo {
  int id;
  String title;
  bool completed;

  Todo({this.id, this.title, this.completed = false});

  Todo.copy(Todo from) : this(title: from.title, completed: from.completed);

  Todo.fromJson(Map<String, dynamic> json)
      : this(
            id: json['id'], title: json['title'], completed: json['completed']);

  Map<String, dynamic> toJson() => {'title': title, 'completed': completed};
}
