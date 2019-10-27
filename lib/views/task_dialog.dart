import 'package:flutter/material.dart';
import 'package:todo_list/models/task.dart';

GlobalKey<FormState> _formKey = GlobalKey<FormState>();

TextEditingController _itemNameController = TextEditingController();
TextEditingController _itemDescriptionController = TextEditingController();

class TaskDialog extends StatefulWidget {
  final Task task;

  TaskDialog({this.task});

  @override
  _TaskDialogState createState() => _TaskDialogState();
}

class _TaskDialogState extends State<TaskDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  Task _currentTask = Task();

  @override
  void initState() {
    super.initState();

    if (widget.task != null) {
      _currentTask = Task.fromMap(widget.task.toMap());
    }

    _titleController.text = _currentTask.title;
    _descriptionController.text = _currentTask.description;
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.clear();
    _descriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.task == null ? 'Nova tarefa' : 'Editar tarefas'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
              controller: _titleController,
              decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Título'),
              autofocus: true),
          Padding(padding:  EdgeInsets.only(top: 24.0),),
          TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: 2,
              controller: _descriptionController,
              decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Descrição')),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Cancelar'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text('Salvar'),
          onPressed: () {
            _currentTask.title = _titleController.value.text;
            _currentTask.description = _descriptionController.text;

            Navigator.of(context).pop(_currentTask);
          },
        ),
      ],
    );
  }


  Form buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          buildTextFormField(
              label: "Nome",
              error: "Dê um nome para sua tarefa",
              controller: _itemNameController),
          buildTextFormField(
              label: "Descrição",
              error: "Adicione uma descrição para sua tarefa",
              controller: _itemDescriptionController),
        ],
      ),
    );
  }

  Widget buildTextFormField(
      {TextEditingController controller, String error, String label}) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      controller: controller,
      validator: (text) {
        return text.isEmpty ? error : null;
      },
    );
  }
}
