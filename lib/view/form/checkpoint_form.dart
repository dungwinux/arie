import 'package:arie/controller/img_process.dart';
import 'package:arie/model/checkpoint.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong/latlong.dart';
import 'package:progress_dialog/progress_dialog.dart';

class CheckpointForm extends StatefulWidget {
  final Checkpoint checkpoint;
  CheckpointForm({this.checkpoint});

  @override
  _CheckpointFormState createState() => _CheckpointFormState();
}

class _CheckpointFormState extends State<CheckpointForm> {
  Checkpoint checkpoint;
  final _formKey = GlobalKey<FormState>();
  ProgressDialog pw;
  TextEditingController _labelController;

  @override
  void initState() {
    super.initState();
    checkpoint = widget.checkpoint ??
        Checkpoint(
          location: LatLng(0, 0),
          type: 'barcode',
        );
    pw = ProgressDialog(context, ProgressDialogType.Normal);
    _labelController = TextEditingController(text: checkpoint.label);
  }

  Future<String> imageSetter(ImageSource source) async {
    try {
      final image = await ImagePicker.pickImage(source: source);
      final processImage = await imgProcess(image.path, mode: checkpoint.type);
      return processImage.first;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: [Low] Consider changing to dialog
    // TODO: [Low] Constraint Field Position
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkpoint editor'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
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
            Container(
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
            Container(
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
            Container(
              padding: EdgeInsets.all(16),
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
                  if (value.isEmpty) return 'Latitude required';
                  double lat = double.tryParse(value);
                  if (lat > 90 || lat < -90)
                    return 'Latitude must be between -90 and 90';
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
                  double long = double.tryParse(value);
                  if (long > 180 || long < -180)
                    return 'Longitude must be between -180 and 180';
                  return null;
                },
                onSaved: (String res) {
                  setState(() {
                    checkpoint.location.longitude = double.tryParse(res);
                  });
                },
              ),
            ),
            Container(
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 2),
                  ),
                  labelText: 'Label type',
                ),
                value: checkpoint.type,
                items: supportType
                    .map((String type) => DropdownMenuItem<String>(
                          child: Text(type),
                          value: type,
                        ))
                    .toList(),
                onChanged: (String res) {
                  setState(() {
                    checkpoint.type = res;
                  });
                },
              ),
              padding: EdgeInsets.all(16),
            ),
            Container(
              child: TextFormField(
                controller: _labelController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 2),
                  ),
                  labelText: 'Label',
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value.isEmpty) return 'Label required';
                  return null;
                },
                onSaved: (String res) {
                  setState(() {
                    // TODO: [Medium] Hash label
                    checkpoint.label = res;
                  });
                },
              ),
              padding: EdgeInsets.all(16),
            ),
            FlatButton(
              child: Text('Set label'),
              onPressed: () async {
                final ImageSource source = await showModalBottomSheet(
                  context: context,
                  isScrollControlled: false,
                  builder: (context) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.image),
                        title: Text('From gallery'),
                        onTap: () async {
                          Navigator.of(context).pop(ImageSource.gallery);
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.camera_alt),
                        title: Text('Take a picture'),
                        onTap: () async {
                          Navigator.of(context).pop(ImageSource.camera);
                        },
                      ),
                    ],
                  ),
                );
                if (source == null) return;
                pw.show();
                final result = await imageSetter(source);
                if (result != null) {
                  setState(() {
                    _labelController.text = result;
                  });
                }
                pw.hide();
              },
            ),
          ],
        ),
      ),
    );
  }
}
