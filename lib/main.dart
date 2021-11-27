import 'package:flutter/material.dart';
import './screens/mainpage.dart';
import 'package:provider/provider.dart';
import './states/user.dart';
import './screens/test.dart';

void main() => runApp(loginFormApp);

var loginFormApp = ChangeNotifierProvider(
  create: (context) => UserState(),
  child: choocinema(),
);

const String ROOT_PAGE = '/';
const String MAIN_PAGE = '/main';

class choocinema extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CHOOCINEMA',
      initialRoute: ROOT_PAGE,
      debugShowCheckedModeBanner: false,
      routes: {
        ROOT_PAGE: (context) => LoginPage(),
        MAIN_PAGE: (context) => MainPage()
      },
      theme: new ThemeData(primarySwatch: Colors.deepPurple),
    );
  }
}
