import 'package:arie/view/form/form.dart';
import 'package:arie/view/overview/overview.dart';
import 'package:arie/view/search/search.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arie',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Overview(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () async {
          await showSearch(context: context, delegate: SearchMenuDelegate());
        },
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                // Open drawer, or show up BottomSheet
              },
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FormPage()),
                );
              },
            )
          ],
        ),
      ),
      drawer: Drawer(
          child: ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/landscape.jpg'), fit: BoxFit.cover),
            ),
            child: Align(
              child: Text(
                'Arie',
                style: TextStyle(
                    fontSize: 36, color: Color.fromRGBO(255, 255, 255, 32)),
              ),
              alignment: Alignment.bottomLeft,
            ),
          ),
          ListTile(
            title: Text('About'),
            onTap: () {
              showAboutDialog(context: context);
            },
          ),
        ],
      )),
    );
  }
}
