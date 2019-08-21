import 'package:arie/controller/task_fetch.dart';
import 'package:arie/model/task.dart';
import 'package:arie/view/content/task_view.dart';
import 'package:flutter/material.dart';

class RecList extends StatelessWidget {
  final Widget onErrorWidget;
  RecList({this.onErrorWidget});

  @override
  Widget build(BuildContext context) {
    final futureTasks = TaskFetch.instance.fetchTrending();
    return FutureBuilder(
      future: futureTasks,
      builder: (context, AsyncSnapshot<List<Task>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError ||
              (!snapshot.hasData) ||
              snapshot.data.isEmpty) {
            return onErrorWidget;
          }
          final formatList = snapshot.data
              .map(
                (Task x) => ListTile(
                  title: Text(
                    x.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    'by ${x.creatorName}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => TaskView(x),
                    ));
                  },
                  trailing: Icon(Icons.star),
                ),
              )
              .toList();
          return Card(child: Column(children: formatList));
        } else
          return Center(
            child: CircularProgressIndicator(),
          );
      },
    );
  }
}
