import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:arie/model/task.dart';

class TaskFetch {
  static final _serverHost = 'arie-backend.herokuapp.com';

  static Future<List<Task>> fetchAll(String query) async {
    final Uri url = Uri.https(
      _serverHost,
      '/api/tasks/',
      {
        'count': '10',
        'idx': '0',
        'q': jsonEncode({'name': query})
      },
    );

    try {
      final rawResult = await http.get(url);
      // TODO: Error handling
      final List<Task> output = (jsonDecode(rawResult.body) as Iterable)
          .map((x) => Task.fromJson(x))
          .toList();
      return output;
    } catch (e) {
      return Future.error('Failed to get data from server');
    }
  }

  static Future<Task> fetch(String id) async {
    final Uri url = Uri.https(
      _serverHost,
      '/api/tasks/$id',
    );
    try {
      final rawResult = await http.get(url);
      final output = Task.fromJson(jsonDecode(rawResult.body));
      return output;
    } catch (e) {
      return Future.error('Failed to get data from server');
    }
  }

  static Future<bool> send(SubmitTask task) async {
    final Uri url = Uri.https(
      _serverHost,
      '/api/tasks/',
    );
    try {
      final respond = await http.post(url, body: task.toJson());
      return respond.statusCode == 200;
    } catch (e) {
      return Future.error('Failed to send data to server');
    }
  }
}
