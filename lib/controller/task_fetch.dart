import 'dart:convert';

import 'package:arie/model/user.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:arie/model/task.dart';

class _TaskFetchInternal {
  final _serverHost = 'arie-backend.herokuapp.com';
  final request = Dio()..interceptors.add(CookieManager(CookieJar()));

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
      final rawResult = await request.getUri(url);
      final List<Task> output =
          (rawResult.data as Iterable).map((x) => Task.fromJson(x)).toList();
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
      final rawResult = await request.getUri(url);
      final output = Task.fromJson(rawResult.data);
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
      final respond = await request.postUri(url, data: content);
      return respond.statusCode == 200;
    } catch (e) {
      return Future.error('Failed to send data to server');
    }
  }

  Future<void> login(User user) async {
    final Uri url = Uri.https(_serverHost, '/api/tasks/user/');
    final content = json.encode(user.toJson());
    try {
      final respond = await request.postUri(url, data: content);
      if (respond.statusCode != 200) throw 'Server cannot receive request';
    } catch (e) {
      return Future.error('Failed to login');
    }
  }

  Future<void> logout() async {
    final Uri url = Uri.https(_serverHost, '/api/tasks/user/');
    try {
      final respond = await request.deleteUri(url);
      if (respond.statusCode != 200) throw 'Server cannot receive request';
    } catch (e) {
      return Future.error('Failed to logout');
    }
  }

  Future<List<Task>> fetchTrending() async {
    final Uri url = Uri.https(_serverHost, '/api/tasks/trending/');
    try {
      final rawResult = await request.getUri(url);
      final List<Task> output =
          (rawResult.data as Iterable).map((x) => Task.fromJson(x)).toList();
      return output;
    } catch (e) {
      return Future.error('Failed to get data from server');
    }
  }

  Future<void> subscribe(String id) async {
    final Uri url = Uri.https(_serverHost, '/api/tasks/$id/');
    try {
      final respond = await request.postUri(url);
      if (respond.statusCode != 200) throw 'Server cannot receive request';
    } catch (e) {
      return Future.error('Failed to logout');
    }
  }

  Future<void> unsubscribe(String id) async {
    final Uri url = Uri.https(_serverHost, '/api/tasks/unsubscribe/$id/');
    try {
      final respond = await request.deleteUri(url);
      if (respond.statusCode != 200) throw 'Server cannot receive request';
    } catch (e) {
      return Future.error('Failed to logout');
    }
  }
}

class TaskFetch {
  static final instance = _TaskFetchInternal();
}
