import 'package:arie/controller/login.dart';
import 'package:arie/view/form/form.dart';
import 'package:arie/view/login/login_screen.dart';
import 'package:arie/view/overview/overview.dart';
import 'package:arie/view/search/search.dart';
import 'package:flutter/material.dart';

// TODO: [High] Sign the app
// https://flutter.dev/docs/deployment/android

// TODO: [Medium] i18n

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
          accentColor: Colors.lightBlueAccent),
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  context: context,
                  builder: (context) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
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
                        // Credit
                        ListTile(
                          title: Text('About'),
                          onTap: () {
                            showAboutDialog(
                              context: context,
                              applicationName: 'Arie',
                              applicationVersion: '1.0.0',
                              applicationLegalese: 'Copyright 2019, Kori Team',
                              applicationIcon: Image.asset(
                                'images/icon.png',
                                width: 48,
                                height: 48,
                              ),
                              children: [
                                ListTile(
                                  title: Text('Team name'),
                                  subtitle: Text('Kori'),
                                ),
                                ListTile(
                                  title: Text('Email'),
                                  subtitle: Text('kori.eicon9@gmail.com'),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
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
