import 'package:arie/controller/task_fetch.dart';
import 'package:arie/model/task.dart';
import 'package:arie/view/content/task_view.dart';
import 'package:arie/view/search/rec_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';

class SearchMenuDelegate extends SearchDelegate<Task> {
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
        close(context, null);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return RecList(
      onErrorWidget: Center(
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
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return PagewiseListView(
      physics: BouncingScrollPhysics(),
      pageSize: 10,
      pageFuture: (int pageIndex) {
        return TaskFetch.instance.fetchAll(query, index: 1 + pageIndex * 10);
      },
      retryBuilder: (context, callback) {
        return RaisedButton(
          child: Text('Retry'),
          onPressed: () => callback(),
          color: Theme.of(context).accentColor,
        );
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
              'by ${_task.creatorName}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () {
              showBottomSheet(
                context: context,
                builder: (context) => TaskView(_task),
              );
            },
          ),
        );
      },
    );
  }
}
