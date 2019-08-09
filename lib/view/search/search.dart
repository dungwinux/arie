import 'package:arie/controller/task_fetch.dart';
import 'package:arie/controller/task_local.dart';
import 'package:arie/model/database.dart';
import 'package:arie/model/task.dart';
import 'package:arie/view/task_view.dart';
import 'package:flutter/material.dart';

// class SearchMenu extends StatefulWidget {
//   @override
//   _SearchMenuState createState() => _SearchMenuState();
// }

// class _SearchMenuState extends State<SearchMenu> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Browse Tasks'),
//         actions: <Widget>[
//           IconButton(
//             icon: Icon(Icons.search),
//             tooltip: 'Search',
//             onPressed: () {
//               showSearch(context: context, delegate: SearchMenuDelegate());
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

class SearchMenuDelegate extends SearchDelegate<Task> {
  // TODO: Add History
  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
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
    // TODO: implement buildLeading
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
    return FutureBuilder(
      future: TaskFetch().fetchAll(query),
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
              itemBuilder: (context, index) => ListTile(
                leading: Icon(Icons.assignment, size: 40),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TaskView(_tasks[index]),
                    ),
                  );
                },
                trailing: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    taskDB.insertTask(
                        BasicTask(id: _tasks[index].id, progress: 0));
                    Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text('${_tasks[index].name} Added')));
                  },
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
