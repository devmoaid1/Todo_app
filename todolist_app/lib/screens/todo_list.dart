import 'package:flutter/material.dart';
import '../services/data_service.dart';
import '../models/todo.dart';

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  Future<List<Todo>> _futureData;
  List<Todo> todos;

  @override
  void initState() {
    super.initState();
    _futureData = dataService.getTodoList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Todo>>(
        future: _futureData,
        // ignore: missing_return
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            todos = snapshot.data;
            return Scaffold(
              appBar: AppBar(
                title: Text('My Todo List'),
              ),
              body: ListView.separated(
                itemCount: todos.length,
                separatorBuilder: (context, index) => Divider(
                  color: Colors.blueGrey,
                ),
                itemBuilder: (context, index) {
                  final Todo _todo = todos[index];
                  return ListTile(
                    title: Text(_todo.title,
                        style: TextStyle(
                            decoration: _todo.completed
                                ? TextDecoration.lineThrough
                                : TextDecoration.none)),
                    subtitle: Text('id: ${_todo.id}'),
                    onTap: () async {
                      setState(() {
                        todos[index].completed = !todos[index].completed;
                      });
                      Todo updatedTodo = await dataService.updateTodoStatus(
                          id: todos[index].id, status: todos[index].completed);
                      print(updatedTodo.completed);
                    },
                    onLongPress: () async {
                      Todo deletedTodo =
                          await dataService.deleteTodo(id: todos[index].id);
                      setState(() {
                        todos.removeAt(index);
                      });
                    },
                  );
                },
              ),
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () async {
                  Todo newTodo = await dataService.createTodo(
                      todo: new Todo(title: 'new task', completed: false));
                  setState(() {
                    todos.add(newTodo);
                  });
                },
              ),
            );
          }
        });
  }
}
