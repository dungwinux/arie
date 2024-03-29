import 'package:arie/controller/login.dart';
import 'package:arie/controller/task_fetch.dart';
import 'package:arie/model/checkpoint.dart';
import 'package:arie/model/task.dart';
import 'package:arie/view/form/checkpoint_form.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

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
  final _task = SubmitTask(checkpoints: []);
  bool _isSubmitting = false;

  Widget _renderCheckpoints() {
    List<Widget> tileList =
        List.generate(_task.checkpoints.length, (int index) {
      final x = _task.checkpoints[index];
      return Dismissible(
        key: Key(x.hashCode.toString()),
        onDismissed: (direction) {
          _task.checkpoints.removeAt(index);
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('Deleted ${x.title}'),
            behavior: SnackBarBehavior.floating,
          ));
        },
        child: Card(
          child: ListTile(
            title: Text(x.title),
            subtitle: Text(x.description),
            onTap: () async {
              final Checkpoint result =
                  await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CheckpointForm(checkpoint: x),
              ));
              if (result != null)
                setState(() {
                  _task.checkpoints[index] = result;
                });
            },
          ),
        ),
      );
    });
    return Column(
      children: tileList,
    );
  }

  @override
  Widget build(BuildContext context) {
    final _dateTimeFormat = DateFormat('EE, MMM d, y HH:mm');
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

    return ModalProgressHUD(
      opacity: 0.5,
      color: Colors.black,
      inAsyncCall: _isSubmitting,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
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
                  onSaved: (String res) {
                    setState(() {
                      _task.name = res;
                    });
                  },
                ),
                padding: EdgeInsets.all(16),
              ),
              Padding(
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 2),
                    ),
                    labelText: 'Creator',
                  ),
                  initialValue: Login.of(context).user.name,
                  keyboardType: TextInputType.text,
                  enabled: false,
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
                    if (time == null)
                      return 'Start time is required';
                    else if (time.isBefore(DateTime.now()))
                      return 'Start time must be after now';
                    else
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
                    if (startTime.isAfter(time))
                      return 'End time must be after start time';
                    else if (time.isBefore(DateTime.now()))
                      return 'End time must be after now';
                    else
                      return null;
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
                onPressed: () async {
                  final Checkpoint result =
                      await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CheckpointForm(),
                  ));
                  if (result != null) {
                    setState(() {
                      _task.checkpoints.add(result);
                    });
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text('Added ${result.title}'),
                      behavior: SnackBarBehavior.floating,
                    ));
                  }
                },
              ),
              Padding(
                child: RaisedButton(
                  color: Theme.of(context).accentColor,
                  child: Text('Submit'),
                  onPressed: () async {
                    setState(() {
                      _isSubmitting = true;
                    });
                    final form = _formKey.currentState;
                    if (form.validate()) {
                      form.save();
                      if (_task.checkpoints.length == 0) {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text('At least one checkpoint is required'),
                          behavior: SnackBarBehavior.floating,
                        ));
                        return;
                      }
                      bool confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Are you sure ?'),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                            ),
                            FlatButton(
                              child: Text('Send'),
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                            ),
                          ],
                        ),
                      );
                      if (!confirm) return;
                      try {
                        final sendSuccess =
                            await TaskFetch.instance.send(_task);
                        if (sendSuccess) {
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text('Success'),
                            behavior: SnackBarBehavior.floating,
                          ));
                        } else {
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text(
                                'Unable to send task. Wait a moment before trying again'),
                            behavior: SnackBarBehavior.floating,
                          ));
                        }
                      } catch (e) {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text('Error: $e'),
                          behavior: SnackBarBehavior.floating,
                        ));
                      }
                    } else {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text('Please fill in correctly'),
                        behavior: SnackBarBehavior.floating,
                      ));
                    }
                    setState(() {
                      _isSubmitting = false;
                    });
                  },
                ),
                padding: EdgeInsets.all(16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
