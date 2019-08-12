import 'package:flutter/material.dart';

class FormPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create new task'),
      ),
      body: TaskForm(),
    );
  }
}

class TaskForm extends StatefulWidget {
  @override
  _TaskFormState createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    // TODO: Add all field
    // TODO: Add DateTime field
    // TODO: Add submit button
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Padding(
            child: TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(width: 2),
                ),
                hintText: 'Task title',
                labelText: 'Name',
              ),
              autofocus: true,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value.isEmpty) return 'Name required';
                return null;
              },
            ),
            padding: EdgeInsets.all(16),
          ),
          Padding(
            child: Row(
              children: <Widget>[],
            ),
            padding: EdgeInsets.all(16),
          ),
        ],
      ),
    );
  }
}
