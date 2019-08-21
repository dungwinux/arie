import 'package:arie/controller/task_fetch.dart';
import 'package:arie/model/user.dart';
import 'package:flutter/material.dart';
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
  bool isSigning = false;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount account) async {
      setState(() {
        isSigning = true;
      });
      if (account == null) {
        await TaskFetch.instance.logout();
        setState(() {
          // Update account
          user = null;
          isSignedIn = false;
          isSigning = false;
        });
      } else {
        final _auth = await account.authentication;
        final res = User(
          accessToken: _auth.accessToken,
          name: account.displayName,
          email: account.email,
          imageUri: account.photoUrl,
        );
        await TaskFetch.instance.login(res);
        setState(() {
          user = res;
          isSignedIn = true;
          isSigning = false;
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
