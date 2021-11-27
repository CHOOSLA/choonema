import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dart:io';

import '../states/user.dart';
import '../main.dart';

class LoginPage extends StatefulWidget {
  @override
  State createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _idController = TextEditingController(
    text: 'your_name@gmail.com',
  );
  final TextEditingController _passwordController =
      TextEditingController(text: 'input password');

  void _onLogin(BuildContext context) {
    final String id = _idController.text;
    final String password = _passwordController.text;
    final UserState state = Provider.of<UserState>(context, listen: false);
    state.setId(id);
    state.setPasswrod(password);

    Navigator.pushNamed(context, MAIN_PAGE);
  }

  void _onCancel() => exit(0);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            padding: EdgeInsets.fromLTRB(20, 120, 20, 120),
            child: Column(
              children: <Widget>[
                Hero(
                    tag: 'heoro',
                    child: CircleAvatar(
                      child: Image.asset('assets/logo.jpg'),
                      backgroundColor: Colors.transparent,
                      radius: 58.0, //unit: logical pixel?
                    )),
                SizedBox(height: 45.0),
                TextFormField(
                  key: Key('ID'),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(border: OutlineInputBorder()),
                  controller: _idController,
                ),
                SizedBox(height: 15.0),
                TextFormField(
                  key: Key('password'),
                  obscureText: true,
                  decoration: InputDecoration(border: OutlineInputBorder()),
                  controller: _passwordController,
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      key: Key('login'),
                      child: Text('로그인'),
                      onPressed: () => _onLogin(context),
                    ),
                    SizedBox(width: 10.0),
                    RaisedButton(
                      key: Key('sign'),
                      child: Text('회원가입'),
                      onPressed: _onCancel,
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
