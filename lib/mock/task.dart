import 'package:arie/model/checkpoint.dart';
import 'package:arie/model/task.dart';

class TaskMock {
  Future<List<Task>> fetch(String query) {
    final List<Task> _taskList = [
      Task(
          createTime: DateTime.now(),
          creator: 'admin',
          name: 'Hello World',
          id: '10',
          checkpoints: [Checkpoint(title: 'VN, Earth')],
          description:
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
          startTime: DateTime.parse('2019-08-01T06:36:27.259Z'),
          endTime: DateTime.parse('2019-08-03T06:36:27.259Z'),
          doneSubtask: 3),
      Task(
        createTime: DateTime.now(),
        creator: 'admin',
        name: 'Second Attempt',
        id: '10',
        checkpoints: [Checkpoint(title: 'Thanh Hoa')],
        description:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
        startTime: DateTime.parse('2019-08-01T06:36:27.259Z'),
        endTime: DateTime.parse('2019-08-20T06:36:27.259Z'),
      ),
    ].where((Task x) => x.name.startsWith(query)).toList();

    return Future.sync(
      () => _taskList,
    );
  }
}
