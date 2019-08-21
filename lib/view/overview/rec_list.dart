import 'package:arie/controller/task_fetch.dart';
import 'package:arie/model/task.dart';
import 'package:arie/view/content/task_view.dart';
import 'package:flutter/material.dart';

class RecList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final futureTasks = TaskFetch.instance.fetchTrending();
    return FutureBuilder(
      future: futureTasks,
      builder: (context, AsyncSnapshot<List<Task>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final formatList = snapshot.data
              .map(
                (Task x) => ListTile(
                  key: Key(x.id),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                  title: Text(x.name),
                  subtitle: Text(
                    x.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskView(x, isAssigned: true),
                      ),
                    );
                  },
                  trailing: Icon(Icons.star),
                ),
              )
              .toList();
          return Card(child: Column(children: formatList));
        } else
          return CircularProgressIndicator();
      },
    );
  }
}
