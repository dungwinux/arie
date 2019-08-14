import 'package:arie/model/checkpoint.dart';
import 'package:flutter/foundation.dart';

class Task {
  final String id;
  final String name;
  final String description;
  final List<Checkpoint> checkpoints;
  int doneSubtask;
  final String creator;
  final DateTime startTime;
  final DateTime endTime;
  final DateTime createTime;

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

  double get percent => (doneSubtask / checkpoints.length);

  // TODO: Implement isCompletedToday
  // bool get isCompletedToday
}

class SubmitTask {
  String name;
  String description;
  String creator;
  DateTime startTime;
  DateTime endTime;
  List<Checkpoint> checkpoints = <Checkpoint>[];
  Map<String, dynamic> toJson() => {
        'name': name,
        'creator': creator,
        'description': description,
        'startTime': startTime.toIso8601String(),
        'endTime': endTime.toIso8601String(),
        'checkpoints': checkpoints.map((Checkpoint x) => x.toJson()),
      };
}
