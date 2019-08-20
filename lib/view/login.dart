import 'package:arie/model/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';

class _InheritedLogin extends InheritedWidget {
  final LoginState data;
  _InheritedLogin({@required this.data, @required Widget child, Key key})
      : super(child: child, key: key);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}

GoogleSignIn _googleSignIn =
    GoogleSignIn(scopes: ['email', 'profile', 'openid']);

class Login extends StatefulWidget {
  final Widget child;

  Login({@required this.child});
  static LoginState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_InheritedLogin)
            as _InheritedLogin)
        .data;
  }

  @override
  State<StatefulWidget> createState() => LoginState();
}

class LoginState extends State<Login> {
  User user;
  bool isSignedIn = false;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount account) async {
      if (account == null) {
        setState(() {
          // Update account
          user = null;
          isSignedIn = false;
        });
      } else {
        final _auth = await account.authentication;
        setState(() {
          user = User(
            accessToken: _auth.accessToken,
            name: account.displayName,
            email: account.email,
            imageUri: account.photoUrl,
          );
          isSignedIn = true;
        });
      }
    });
    _googleSignIn.signInSilently(suppressErrors: true);
  }

  Future<void> signIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (e) {
      throw 'Cannot sign in. Try again later.';
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedLogin(data: this, child: widget.child);
  }
}

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
        return (Login.of(context).isSignedIn)
            ? widget.child
            : Scaffold(
                body: ConstrainedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset('images/icon.png', height: 256, width: 256),
                    SignInButton(
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
                    )
                  ],
                ),
                constraints: BoxConstraints.expand(),
              ));
      },
    ));
  }
}
