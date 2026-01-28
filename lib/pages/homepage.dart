import 'package:flutter/material.dart';
import 'package:sqlite_course/services/database_service.dart';
import 'package:sqlite_course/models/task.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final DatabaseService _databaseService = DatabaseService.instance;
  String? _task ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tasksList(),
      floatingActionButton: _addTaskButton(),
    );
  }

  Widget _addTaskButton() {
    return FloatingActionButton(
      onPressed: (){
        showDialog(context: context, builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(10)
          ),
          title: const Text("Add Task"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Task..."
                ),
                onChanged: (value) {
                  setState(() {
                    _task = value;
                  });
                },
              ),
              MaterialButton(
                color: Theme.of(context).colorScheme.primary,
                onPressed: (){
                  if(_task == "" || _task == null) return;
                  _databaseService.addTask(_task!);
                  setState(() {
                    _task = null;
                  });
                  Navigator.pop(context);
                },
                child: Text("Submit", style: TextStyle(color: Colors.white),),
              )
            ],
          ),
        ));
      },
      child: const Icon(Icons.add),
    );
  }

  Widget _tasksList() {
    return FutureBuilder(
      future: _databaseService.getTasks(),
      builder: (context, snapshot) {
        return ListView.builder(
          itemCount: snapshot.data?.length ?? 0,
          itemBuilder: (context, index) {
            Task task =  snapshot.data![index];
            return ListTile(
              onLongPress: (){
                _databaseService.deleteTask(task.id);
                setState(() {});
              },
              title: Text(task.content),
              trailing: Checkbox(
                value: task.status == 1,
                onChanged: (value){
                  _databaseService.updateTaskStatus(task.id, value == true? 1 : 0);
                  setState(() {});
                }),
            );
          });
      }
    );
  }

}
