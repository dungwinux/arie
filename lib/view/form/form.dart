import 'package:arie/model/checkpoint.dart';
import 'package:arie/model/task.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  final _task = SubmitTask();

  Widget _renderCheckpoints() {
    // TODO: Convert to Stepper
    final tileList = _task.checkpoints
        .map((Checkpoint x) => ListTile(
              title: Text(x.title),
              subtitle: Text(x.description),
              onTap: () {
                // Open Editor
              },
            ))
        .toList();
    return Column(
      children: tileList,
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Add all field
    // TODO: Add submit button

    final _dateTimeFormat = DateFormat('EE, MMM d, y hh:mm');
    final Future<DateTime> Function(BuildContext, DateTime) _onShowPicker =
        (context, currentValue) async {
      final newDate = await showDatePicker(
        context: context,
        initialDate: currentValue ?? DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
      );
      if (newDate != null) {
        final newTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
        );
        return DateTimeField.combine(newDate, newTime);
      } else {
        return currentValue;
      }
    };

    return Form(
      key: _formKey,
      child: ListView(
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
              onSaved: (String res) {
                setState(() {
                  _task.name = res;
                });
              },
            ),
            padding: EdgeInsets.all(16),
          ),
          Padding(
            child: DateTimeField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(width: 2),
                ),
                labelText: 'Start time',
              ),
              onChanged: (DateTime time) {
                setState(() {
                  _task.startTime = time;
                });
              },
              validator: (DateTime time) {
                if (time == null) return 'Start time is required';
                return null;
              },
              format: _dateTimeFormat,
              readOnly: true,
              onShowPicker: _onShowPicker,
            ),
            padding: EdgeInsets.all(16),
          ),
          Padding(
            child: DateTimeField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(width: 2),
                ),
                labelText: 'End time',
              ),
              enabled: (_task.startTime != null),
              onChanged: (DateTime time) {
                setState(() {
                  _task.endTime = time;
                });
              },
              validator: (DateTime time) {
                if (time == null) return 'End time is required';
                DateTime startTime = _task.startTime;
                if (startTime != null && startTime.isBefore(time))
                  return null;
                else
                  return 'End time must be after startTime';
              },
              format: _dateTimeFormat,
              readOnly: true,
              onShowPicker: _onShowPicker,
            ),
            padding: EdgeInsets.all(16),
          ),
          Padding(
            child: TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(width: 2),
                ),
                hintText: 'Description goes here',
                labelText: 'Description',
              ),
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              maxLengthEnforced: true,
              maxLength: 150,
              validator: (value) {
                if (value.isEmpty) return 'Description required';
                return null;
              },
              onSaved: (String res) {
                setState(() {
                  _task.description = res;
                });
              },
            ),
            padding: EdgeInsets.all(16),
          ),
          _renderCheckpoints(),
          FlatButton(
            child: Text('Add checkpoint'),
            onPressed: () {
              // Call add checkpoint
            },
          ),
          Padding(
            child: RaisedButton(
              child: Text('Submit'),
              onPressed: () {
                // TODO: Add alert
                if (_formKey.currentState.validate()) {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text('Success'),
                  ));
                }
              },
            ),
            padding: EdgeInsets.all(16),
          ),
        ],
      ),
    );
  }
}
