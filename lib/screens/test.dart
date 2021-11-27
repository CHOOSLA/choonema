import 'package:choocinema/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../states/user.dart';
import '../globals/globals.dart';
import '../wigets/button_widget.dart';
import '../wigets/textfield_widget.dart';
import '../wigets/wave_widget.dart';
import 'package:dio/dio.dart';

import 'package:provider/provider.dart';
import '../env.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  String tmp;
  bool _isLoading = false;

  Future _login() async {
    setState(() {
      _isLoading = true;
      tmp = null;
    });

    final model = Provider.of<UserState>(context, listen: false);

    var formData = FormData.fromMap(
      {"id": model.id, "pwd": model.password},
    );

    var responseWithDio;
    Map<String, dynamic> list;
    Dio dio = Dio();
    //Dio 이용하여 통신
    try {
      responseWithDio =
          await dio.post('${Env.URL_PREFIX}/login.php', data: formData);
      tmp = responseWithDio.data;
      if (tmp == "[]") {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('로그인 실패'),
                content:
                    SingleChildScrollView(child: Text('아이디 또는 비밀번호를 확인하세요')),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('확인')),
                ],
              );
            });
      } else {
        Navigator.pushNamed(context, MAIN_PAGE);
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    final model = Provider.of<UserState>(context);

    return Scaffold(
      backgroundColor: Global.white,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: <Widget>[
                Container(
                  height: size.height - 200,
                  color: Global.megabox,
                ),
                AnimatedPositioned(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeOutQuad,
                  top: keyboardOpen ? -size.height / 3.7 : 0.0,
                  child: WaveWidget(
                    size: size,
                    yOffset: size.height / 3.0,
                    color: Global.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 100.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '시네마',
                        style: TextStyle(
                          color: Global.white,
                          fontSize: 40.0,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      TextFieldWidget(
                        hintText: '아이디',
                        obscureText: false,
                        prefixIconData: Icons.mail_outline,
                        //suffixIconData: model.isValid ? Icons.check : null,
                        onChanged: (value) {
                          model.setId(value);
                        },
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          TextFieldWidget(
                            hintText: '패스워드',
                            obscureText: model.isVisible ? false : true,
                            prefixIconData: Icons.lock_outline,
                            suffixIconData: model.isVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            onChanged: (value) {
                              model.setPasswrod(value);
                            },
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            '비밀번호 찾기',
                            style: TextStyle(
                              color: Global.megabox,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      ButtonWidget(
                        title: '로그인',
                        hasBorder: false,
                        onPressed: _login,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      ButtonWidget(
                        title: '회원가입',
                        hasBorder: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
