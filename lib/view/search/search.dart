import 'package:arie/controller/task_fetch.dart';
import 'package:arie/controller/task_local.dart';
import 'package:arie/model/database.dart';
import 'package:arie/model/task.dart';
import 'package:arie/view/task_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';

class SearchMenuDelegate extends SearchDelegate<Task> {
  // TODO: [Low] Add History
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        //Take control back to previous page
        this.close(context, null);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.search,
            size: 100,
            color: Colors.black38,
          ),
          Text(
            'Search something',
            style: TextStyle(color: Colors.black38),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return PagewiseListView(
      pageSize: 10,
      pageFuture: (int pageIndex) {
        return TaskFetch.fetchAll(query, index: 1 + pageIndex * 10);
      },
      retryBuilder: (context, callback) {
        // TODO: [Low] Change RaisedButton
        return RaisedButton(child: Text('Retry'), onPressed: () => callback());
      },
      noItemsFoundBuilder: (context) {
        return Column(
          children: <Widget>[
            Icon(
              Icons.sentiment_dissatisfied,
              size: 100,
              color: Colors.black38,
            ),
            Text(
              'No result found',
              style: TextStyle(color: Colors.black38),
            ),
          ],
        );
      },
      itemBuilder: (context, Task _task, int index) {
        return Card(
          child: ListTile(
            title: Text(
              _task.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              'by ${_task.creator}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () {
              showBottomSheet(
                context: context,
                builder: (context) => TaskView(_task),
              );
            },
            trailing: IconButton(
              icon: Icon(Icons.send),
              onPressed: () async {
                if (await taskDB.isTaskExist(BasicTask(id: _task.id)))
                  Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text('${_task.name} was already added')));
                else
                  try {
                    await taskDB.insertTask(_task.toBasicTask());
                    Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text('Added ${_task.name}')));
                  } catch (e) {
                    Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text('Something is not right: $e')));
                  }
              },
            ),
          ),
        );
      },
    );
  }
}
