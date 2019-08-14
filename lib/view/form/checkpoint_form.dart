import 'package:arie/model/checkpoint.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';

class CheckpointForm extends StatefulWidget {
  final Checkpoint checkpoint;
  CheckpointForm({this.checkpoint});

  @override
  _CheckpointFormState createState() => _CheckpointFormState();
}

class _CheckpointFormState extends State<CheckpointForm> {
  Checkpoint checkpoint;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    checkpoint = widget.checkpoint ??
        Checkpoint(
          location: LatLng(0, 0),
          type: 'barcode',
        );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Add support for other type of label
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkpoint editor'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                Navigator.of(context).pop(checkpoint);
              }
            },
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Padding(
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 2),
                  ),
                  hintText: 'Checkpoint title',
                  labelText: 'Title',
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value.isEmpty) return 'Title required';
                  return null;
                },
                initialValue: checkpoint.title,
                onSaved: (String res) {
                  setState(() {
                    checkpoint.title = res;
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
                  hintText: 'Description goes here',
                  labelText: 'Description',
                ),
                keyboardType: TextInputType.text,
                maxLengthEnforced: true,
                maxLength: 40,
                initialValue: checkpoint.description,
                validator: (value) {
                  if (value.isEmpty) return 'Description required';
                  return null;
                },
                onSaved: (String res) {
                  setState(() {
                    checkpoint.description = res;
                  });
                },
              ),
              padding: EdgeInsets.all(16),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(16),
                  width: 200,
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 2),
                      ),
                      labelText: 'Latitude',
                    ),
                    initialValue: checkpoint.location.latitude.toString(),
                    keyboardType: TextInputType.numberWithOptions(
                        decimal: true, signed: true),
                    validator: (value) {
                      if (value.isEmpty) return 'Longitude required';
                      return null;
                    },
                    onSaved: (String res) {
                      setState(() {
                        checkpoint.location.latitude = double.tryParse(res);
                      });
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  width: 200,
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 2),
                      ),
                      labelText: 'Longitude',
                    ),
                    initialValue: checkpoint.location.longitude.toString(),
                    keyboardType: TextInputType.numberWithOptions(
                        decimal: true, signed: true),
                    validator: (value) {
                      if (value.isEmpty) return 'Longitude required';
                      return null;
                    },
                    onSaved: (String res) {
                      setState(() {
                        checkpoint.location.longitude = double.tryParse(res);
                      });
                    },
                  ),
                ),
              ],
            ),
            Padding(
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 2),
                  ),
                  labelText: 'Label',
                ),
                initialValue: checkpoint.label,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value.isEmpty) return 'Title required';
                  return null;
                },
                onSaved: (String res) {
                  setState(() {
                    checkpoint.label = res;
                  });
                },
              ),
              padding: EdgeInsets.all(16),
            ),
          ],
        ),
      ),
    );
  }
}
