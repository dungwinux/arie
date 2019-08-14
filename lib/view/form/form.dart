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
            child: DateTimeField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(width: 2),
                ),
                labelText: 'Start time',
              ),
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
              format: _dateTimeFormat,
              readOnly: true,
              onShowPicker: _onShowPicker,
            ),
            padding: EdgeInsets.all(16),
          ),
        ],
      ),
    );
  }
}
