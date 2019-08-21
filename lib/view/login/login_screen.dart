import 'package:arie/controller/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class LoginScreen extends StatefulWidget {
  final Widget child;

  LoginScreen({this.child});
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Login(child: Builder(
      builder: (context) {
        // TODO: [Medium] Add loading when signing in
        return (Login.of(context).isSignedIn)
            ? widget.child
            : Scaffold(
                body: ConstrainedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                      flex: 6,
                      child: Image.asset('images/icon.png',
                          height: 256, width: 256),
                    ),
                    Flexible(
                      flex: 1,
                      child: Text('Arie',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.w200,
                          )),
                    ),
                    Spacer(flex: 1),
                    Flexible(
                      flex: 1,
                      child: SignInButton(
                        Buttons.Google,
                        text: 'Sign up with Google',
                        onPressed: () async {
                          try {
                            Login.of(context).signIn();
                          } catch (e) {
                            // TODO: [Medium] Add error detail
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text(e),
                              behavior: SnackBarBehavior.floating,
                            ));
                          }
                        },
                      ),
                    )
                  ],
                ),
                constraints: BoxConstraints.expand(),
              ));
      },
    ));
  }
}
