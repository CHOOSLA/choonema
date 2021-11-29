import 'package:choocinema/screens/accountPage.dart';
import 'package:choocinema/screens/resultPage.dart';
import 'package:choocinema/screens/sheetPage.dart';
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
const String ACCOUNT_PAGE = '/account';
const String MAIN_PAGE = '/main';
const String SHEAT_PAGE = '/main/';
const String RESULT_PAGE = '/result';

class choocinema extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CHOOCINEMA',
      initialRoute: ROOT_PAGE,
      debugShowCheckedModeBanner: false,
      routes: {
        ROOT_PAGE: (context) => LoginPage(),
        ACCOUNT_PAGE: (context) => AccountPage(),
        MAIN_PAGE: (context) => MainPage(),
        SHEAT_PAGE: (context) => SheetPage(),
        RESULT_PAGE: (context) => ResultPage()
      },
      theme: new ThemeData(primarySwatch: Colors.deepPurple),
    );
  }
}
