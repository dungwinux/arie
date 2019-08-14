import 'package:arie/controller/task_fetch.dart';
import 'package:arie/controller/task_local.dart';
import 'package:arie/model/database.dart';
import 'package:arie/model/task.dart';
import 'package:arie/view/task_view.dart';
import 'package:flutter/material.dart';

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
    final _searchResult = TaskFetch.fetchAll(query);
    // TODO: [High] Convert to flutter_pagewise (pub_get)
    return FutureBuilder(
      future: _searchResult,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.sentiment_dissatisfied,
                    size: 100,
                    color: Colors.black38,
                  ),
                  Text(
                    'Something is not right: ${snapshot.error}',
                    style: TextStyle(color: Colors.black38),
                  ),
                ],
              ),
            );
          } else {
            List<Task> _tasks = snapshot.data;
            if (_tasks.isEmpty)
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                ),
              );
            return ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) => Card(
                child: ListTile(
                  title: Text(
                    _tasks[index].name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    'by ${_tasks[index].creator}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    showBottomSheet(
                      context: context,
                      builder: (context) => TaskView(_tasks[index]),
                    );
                  },
                  trailing: IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () async {
                      if (await taskDB
                          .isTaskExist(BasicTask(id: _tasks[index].id)))
                        Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text(
                                '${_tasks[index].name} was already added')));
                      else
                        try {
                          await taskDB.insertTask(_tasks[index].toBasicTask());
                          Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text('Added ${_tasks[index].name}')));
                        } catch (e) {
                          Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text('Something is not right: $e')));
                        }
                    },
                  ),
                ),
              ),
            );
          }
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
