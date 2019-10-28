import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:todo_list/helpers/task_helper.dart';
import 'package:todo_list/models/task.dart';
import 'package:todo_list/views/task_dialog.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Task> _taskList = [];
  TaskHelper _helper = TaskHelper();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _helper.getAll().then((list) {
      setState(() {
        _taskList = list;
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
        
        Text("Lista de tarefas"),
        //precisa adicionar nas dependencias e importar aqui no arquivo documentação: https://pub.dev/packages/percent_indicator
        new CircularPercentIndicator(
          radius: 45.0,
          lineWidth: 5.0,
          percent: getProgress(_taskList),
          center: new Text((getProgress(_taskList) * 100).toInt().toString() + '%'),
          progressColor: Colors.lightBlue,
        )
          
        ]),
      ),
        
        
      floatingActionButton:
          FloatingActionButton(child: Icon(Icons.add), onPressed: _addNewTask),
      body:  _buildTaskList(),
    );
  }

  Widget _buildTaskList() {

    if (_taskList.isEmpty) {
      return Center(
        child: _loading ? CircularProgressIndicator() : Text("Sem tarefas!"),
      );
    } else {
      return ListView.separated(
        separatorBuilder: (context, index) => Divider(
        color: Colors.black38,
        ),
        itemBuilder: _buildTaskItemSlidable,
        itemCount: _taskList.length,
      );
    }
  }

  Widget _buildTaskItem(BuildContext context, int index) {
    final task = _taskList[index];
    return CheckboxListTile(
      value: task.isDone,
      title: Text(task.title),
      subtitle: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text('prioridade: ' + task.priority.toString(), style: TextStyle(color: Colors.teal),),              
            ]
          ),
          Row(
            children: <Widget>[
              Text(task.description),              
            ]
          ),
        ],
      ),
      onChanged: (bool isChecked) {
        setState(() {
          task.isDone = isChecked;
        });

        _helper.update(task);
      },
    );
  }

  Widget _buildTaskItemSlidable(BuildContext context, int index) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: _buildTaskItem(context, index),
      actions: <Widget>[
        IconSlideAction(
          caption: 'Editar',
          color: Colors.blue,
          icon: Icons.edit,
          onTap: () {
            _addNewTask(editedTask: _taskList[index], index: index);
          },
        ),
        IconSlideAction(
          caption: 'Excluir',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {
            _deleteTask(deletedTask: _taskList[index], index: index);
          },
        ),
      ],
    );
  }

  Future _addNewTask({Task editedTask, int index}) async {
    final task = await showDialog<Task>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return TaskDialog(task: editedTask);
      },
    );

    if (task != null) {
      setState(() {
        if (index == null) {
          _taskList.add(task);
          _helper.save(task);
        } else {
          _taskList[index] = task;
          _helper.update(task);
        }
      });
    }
  }

  getProgress(list){
    int i;
    double percent = 0;
    double contDone = 0;

    for(i = 0; i < list.length; i++){
      print(list[i].isDone);
      if(list[i].isDone == true){
        contDone ++;
      }
    }

    // list.length == 0 ? percent = 0 : percent = (contDone / list.length);
    percent  = list.length == 0 ? 0 : (contDone / list.length);

    return percent;
  }

  void _deleteTask({Task deletedTask, int index}) {
    setState(() {
      _taskList.removeAt(index);
    });

    _helper.delete(deletedTask.id);

    Flushbar(
      title: "Exclusão de tarefas",
      message: "Tarefa \"${deletedTask.title}\" removida.",
      margin: EdgeInsets.all(8),
      borderRadius: 8,
      duration: Duration(seconds: 3),
      mainButton: FlatButton(
        child: Text(
          "Desfazer",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          setState(() {
            _taskList.insert(index, deletedTask);
            _helper.update(deletedTask);
          });
        },
      ),
    )..show(context);
  }
}
