import 'package:arie/view/form/form.dart';
import 'package:arie/view/login.dart';
import 'package:arie/view/overview/overview.dart';
import 'package:arie/view/search/search.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: [Low] Dark theme
    return MaterialApp(
      title: 'Arie',
      theme: ThemeData(
        // TODO: [Medium] Change theme
        primarySwatch: Colors.amber,
      ),
      home: MyHomePage(),
      builder: (context, widget) {
        return LoginScreen(
          child: widget,
        );
      },
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
        tooltip: 'Search',
        onPressed: () async {
          await showSearch(context: context, delegate: SearchMenuDelegate());
        },
      ),
      extendBody: true,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Scaffold(
                      body: Column(
                        children: <Widget>[
                          ListTile(
                            leading: CircleAvatar(
                              child: Builder(
                                builder: (context) {
                                  final loc = Login.of(context).user.imageUri;
                                  // TODO: [Low] Handle onNetworkFailed
                                  if (loc != null)
                                    return Image.network(loc);
                                  else
                                    return Icon(Icons.account_circle);
                                },
                              ),
                            ),
                            title: Text(Login.of(context).user.name),
                            subtitle: Text(Login.of(context).user.email),
                            trailing: FlatButton(
                              child: Text('Sign out'),
                              onPressed: () {
                                Login.of(context).signOut();
                              },
                            ),
                          ),
                          Divider(),
                          ListTile(
                            title: Text('About'),
                            onTap: () {
                              showAboutDialog(
                                context: context,
                                applicationName: 'Arie',
                                applicationVersion: 'Beta',
                                applicationLegalese: 'Made by Kori Team',
                                applicationIcon: Image.asset(
                                  'images/icon.png',
                                  width: 48,
                                  height: 48,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            Container(
              height: 52,
            ),
            IconButton(
              icon: Icon(Icons.add),
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
    );
  }
}
