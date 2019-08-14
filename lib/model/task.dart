import 'dart:convert';

import 'package:arie/model/checkpoint.dart';
import 'package:arie/model/database.dart';
import 'package:flutter/foundation.dart';

class Task {
  String id;
  String name;
  String description;
  List<Checkpoint> checkpoints;
  int doneSubtask;
  String creator;
  DateTime startTime;
  DateTime endTime;
  DateTime createTime;

  Task(
      {@required this.name,
      @required this.id,
      @required this.checkpoints,
      @required this.creator,
      @required this.createTime,
      @required this.startTime,
      @required this.endTime,
      this.description: '',
      this.doneSubtask: 0})
      : assert(checkpoints.length > 0);

  Task.fromJson(Map<String, dynamic> res)
      : name = res['name'],
        id = res['_id'],
        creator = res['creator'],
        description = res['description'],
        createTime = DateTime.parse(res['createTime']),
        startTime = DateTime.parse(res['startTime']),
        endTime = DateTime.parse(res['endTime']),
        checkpoints = (res['checkpoints'] as Iterable)
            .map((x) => Checkpoint.fromJson(x))
            .toList(),
        doneSubtask = 0;

  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
        'creator': creator,
        'description': description,
        'createTime': createTime.toIso8601String(),
        'startTime': startTime.toIso8601String(),
        'endTime': endTime.toIso8601String(),
        'checkpoints': checkpoints.map((Checkpoint x) => x.toJson()),
      };

  Task.fromBasicTask(BasicTask task)
      : name = task.name,
        id = task.id,
        creator = task.creator,
        description = task.description,
        createTime = task.createTime,
        startTime = task.startTime,
        endTime = task.endTime,
        doneSubtask = task.doneSubtask,
        checkpoints = (jsonDecode(task.checkpointList) as Iterable)
            .map((x) => Checkpoint.fromJson(x))
            .toList();

  BasicTask toBasicTask() => BasicTask(
        name: name,
        id: id,
        creator: creator,
        description: description,
        createTime: createTime,
        startTime: startTime,
        endTime: endTime,
        doneSubtask: doneSubtask,
        checkpointList: jsonEncode(checkpoints),
      );

  double get percent => (doneSubtask / checkpoints.length);
}

class SubmitTask {
  String name;
  String description;
  String creator;
  DateTime startTime;
  DateTime endTime;
  List<Checkpoint> checkpoints = <Checkpoint>[];

  SubmitTask({
    this.name,
    this.description,
    this.creator,
    this.startTime,
    this.endTime,
    this.checkpoints,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'creator': creator,
        'description': description,
        'startTime': startTime.toIso8601String(),
        'endTime': endTime.toIso8601String(),
        'checkpoints': checkpoints,
      };
}
