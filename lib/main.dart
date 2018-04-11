import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:share/share.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => new MyAppState();
}

class MyAppState extends State<MyApp> {
  static final FacebookLogin facebookSignin = new FacebookLogin();
  String _message = 'Login/out by pressing ther button belows';
  String text = '';

  Future<Null> _login() async {
    final FacebookLoginResult _result =
        await facebookSignin.logInWithReadPermissions(['email']);
    switch (_result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = _result.accessToken;
        _showMessage('''
         Logged in!
         
         Token: ${accessToken.token}
         User Name: ${_result.toString()}
         User id: ${accessToken.userId}
         Expires: ${accessToken.expires}
         Permissions: ${accessToken.permissions}
         Declined permissions: ${accessToken.declinedPermissions}
         ''');
        break;

      case FacebookLoginStatus.cancelledByUser:
        _showMessage('Login cancelled by the user.');
        break;

      case FacebookLoginStatus.error:
        _showMessage('Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${_result.errorMessage}');
        break;
    }
  }

  Future<Null> _logout() async {
    await facebookSignin.logOut();
    _showMessage('Logged out');
  }

  void _showMessage(String value) {
    setState(() {
      _message = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Facebook Login'),
        ),
        body: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(_message),
              new RaisedButton(child: new Text('Login'), onPressed: _login),
              new RaisedButton(child: new Text('logout'), onPressed: _logout),
              new TextField(
                decoration: const InputDecoration(
                    labelText: 'Share:',
                    hintText: 'Enter some text and/or link to share'),
                maxLines: 4,
                onChanged: (String value) => setState(() {
                      text = value;
                    }),
              ),
              new RaisedButton(
                  child: new Text('Share'),
                  onPressed: text.isNotEmpty
                      ? () {
                          share(text);
                        }
                      : null)
            ],
          ),
        ),
      ),
    );
  }
}
