import 'dart:convert';

import 'package:arie/model/user.dart';
import 'package:http/http.dart' as http;
import 'package:arie/model/task.dart';

class _TaskFetchInternal {
  final _serverHost = 'arie-backend.herokuapp.com';
  final request = http.Client();

  Future<List<Task>> fetchAll(
    String query, {
    int index = 0,
    int count = 10,
  }) async {
    final Uri url = Uri.https(
      _serverHost,
      '/api/tasks/',
      {
        'count': count.toString(),
        'idx': index.toString(),
        'q': jsonEncode({'name': query})
      },
    );

    try {
      final rawResult = await request.get(url);
      final List<Task> output = (jsonDecode(rawResult.body) as Iterable)
          .map((x) => Task.fromJson(x))
          .toList();
      return output;
    } catch (e) {
      return Future.error('Failed to get data from server');
    }
  }

  Future<Task> fetch(String id) async {
    final Uri url = Uri.https(
      _serverHost,
      '/api/tasks/$id/',
    );
    try {
      final rawResult = await request.get(url);
      final output = Task.fromJson(jsonDecode(rawResult.body));
      return output;
    } catch (e) {
      return Future.error('Failed to get data from server');
    }
  }

  Future<bool> send(SubmitTask task) async {
    final Uri url = Uri.https(
      _serverHost,
      '/api/tasks/',
    );
    final content = json.encode(task.toJson(), toEncodable: (dynamic item) {
      if (item is DateTime)
        return item.toIso8601String();
      else
        return item.toJson();
    });
    try {
      final respond = await request.post(
        url,
        body: content,
        headers: {'Content-Type': 'application/json'},
      );
      return respond.statusCode == 200;
    } catch (e) {
      return Future.error('Failed to send data to server');
    }
  }

  Future<bool> login(User user) async {
    final Uri url = Uri.https(_serverHost, '/api/tasks/user/');
    final content = json.encode(user.toJson());
    try {
      final respond = await request.post(
        url,
        body: content,
        headers: {'Content-Type': 'application/json'},
      );
      return respond.statusCode == 200;
    } catch (e) {
      return Future.error('Failed to login');
    }
  }

  Future<bool> logout() async {
    final Uri url = Uri.https(_serverHost, '/api/tasks/user/');
    try {
      final respond = await request.delete(url);
      return respond.statusCode == 200;
    } catch (e) {
      return Future.error('Failed to logout');
    }
  }
}

class TaskFetch {
  static final instance = _TaskFetchInternal();
}
