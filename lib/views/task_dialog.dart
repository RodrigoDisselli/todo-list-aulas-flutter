import 'package:flutter/material.dart';
import 'package:todo_list/models/task.dart';

GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class TaskDialog extends StatefulWidget {
  final Task task;

  TaskDialog({this.task});

  @override
  _TaskDialogState createState() => _TaskDialogState();
}

class _TaskDialogState extends State<TaskDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _currentPriority;

  Task _currentTask = Task();

  @override
  void initState() {
    super.initState();

    if (widget.task != null) {
      _currentTask = Task.fromMap(widget.task.toMap());
    }

    _titleController.text = _currentTask.title;
    _descriptionController.text = _currentTask.description;
    _dropDownMenuItems = getDropDownMenuItems();
    _currentPriority = _dropDownMenuItems[0].value;
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
          buildForm()
        ]
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
            if (_formKey.currentState.validate()) {
              _currentTask.title = _titleController.value.text;
              _currentTask.description = _descriptionController.text;
              _currentTask.priority = int.parse(_currentPriority);
              Navigator.of(context).pop(_currentTask);
            }
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
            controller: _titleController,
            hasFocus: true
          ),
          Padding(padding:  EdgeInsets.only(top: 24.0),),
          DropdownButton(
            value: _currentPriority,
            items: _dropDownMenuItems,
            onChanged: changedDropDownItem,
          ),
          Padding(padding:  EdgeInsets.only(top: 24.0),),
          buildTextFormField(
            type: "multiline",
            maxLines: 2,
            label: "Descrição",
            error: "Adicione uma descrição para sua tarefa",
            controller: _descriptionController
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    int i = 1;
    while (i<6) {
      items.add(new DropdownMenuItem(
          value: i.toString(),
          child: new Text(i.toString())
      ));
      i++;
    }
    return items;
  }
  
  void changedDropDownItem(String selectedPriority) {
    setState(() {
      _currentPriority = selectedPriority;
    });
  }

  Widget buildTextFormField(
      {TextEditingController controller, String error, String label, bool hasFocus = false,  String type = "", int maxLines = 1}) {
    return TextFormField(
      keyboardType: type == "multiline" ? TextInputType.multiline : type == "number" ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
      decoration: InputDecoration(border: OutlineInputBorder(), labelText: label),
      controller: controller,
      autofocus: hasFocus,
      validator: (text) {
        return text.isEmpty ? error : null;
      },
    );
  }
}