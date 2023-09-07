import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Task> tasks = [];
  int id = 0;
  bool taskValid = false;
  bool darkMode = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  FocusNode nameFocusNode = FocusNode();
  FocusNode descriptionFocusNode = FocusNode();

  void createTask() {
    if (nameController.text.isEmpty || descriptionController.text.isEmpty) {
      setState(() {
        taskValid = true;
      });
    } else {
      setState(() {
        tasks.add(Task(
          id: id,
          name: nameController.text,
          description: descriptionController.text,
        ));
        id++;
        nameController.clear();
        descriptionController.clear();
        taskValid = false;
      });

      nameFocusNode.unfocus();
      descriptionFocusNode.unfocus();
    }
  }

  void deleteTask(int id) {
    setState(() {
      tasks.removeWhere((task) => task.id == id);
    });
  }

  void completeTask(int id) {
    setState(() {
      tasks.forEach((task) {
        if (task.id == id) {
          task.isComplete = true;
        }
      });
    });
  }

  @override
  void dispose() {
    nameFocusNode.dispose();
    descriptionFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskZord',
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: Scaffold(
          backgroundColor: darkMode ? Colors.black : Colors.white,
          appBar: AppBar(
            title: Text('TaskZord'),
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  Switch(
                    value: darkMode,
                    onChanged: (value) {
                      setState(() {
                        darkMode = value;
                      });
                    },
                  ),
                  Container(
                    width: 150,
                    height: 150,
                    padding: EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: darkMode
                            ? AssetImage('assets/logoTaskZord.png')
                            : AssetImage('assets/taskzord.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Tarefa...',
                        hintText: 'Digite algo aqui',
                      ),
                      controller: nameController,
                      focusNode: nameFocusNode,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Descrição da tarefa...',
                        hintText: 'Digite algo aqui',
                      ),
                      controller: descriptionController,
                      focusNode: descriptionFocusNode,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      createTask();
                    },
                    child: Text('Adicionar Tarefa'),
                  ),
                  if (taskValid)
                    Container(
                      alignment: Alignment.topCenter,
                      child: AlertDialog(
                        title: Text(
                            "Não é possível criar uma tarefa com um campo vazio"),
                        content: Text("Task não enviada"),
                        actions: <Widget>[
                          TextButton(
                            child: Text("Fechar"),
                            onPressed: () {
                              setState(() {
                                taskValid = false;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  Expanded(
                    child: Tasks(
                      tasks: tasks,
                      deleteTask: deleteTask,
                      completeTask: completeTask,
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}

class Task {
  int id;
  String name;
  String description;
  bool isComplete;

  Task({
    required this.id,
    required this.name,
    required this.description,
    this.isComplete = false,
  });
}

class Tasks extends StatelessWidget {
  final List<Task> tasks;
  final void Function(int) deleteTask;
  final void Function(int) completeTask;

  Tasks({
    required this.tasks,
    required this.deleteTask,
    required this.completeTask,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        Task task = tasks[index];
        return ListTile(
          title: Text(task.name),
          subtitle: Text(task.description),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  completeTask(task.id);
                },
                icon: Icon(Icons.check),
              ),
              IconButton(
                onPressed: () {
                  deleteTask(task.id);
                },
                icon: Icon(Icons.delete),
              ),
            ],
          ),
          tileColor: task.isComplete ? Colors.green : Colors.white,
        );
      },
    );
  }
}
