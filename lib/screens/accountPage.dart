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

class AccountPage extends StatefulWidget {
  AccountPage({Key key}) : super(key: key);

  @override
  AccountPageState createState() => AccountPageState();
}

class AccountPageState extends State<AccountPage> {
  String tmp;
  bool _isLoading = false;

  String id;
  String password;
  String username;
  String phone;
  String card;

  _onCreate() async {
    setState(() {});
    Dio dio = new Dio();

    var formData = FormData.fromMap(
      {
        "id": id,
        "password": password,
        'username': username,
        'phone': phone,
        'card': card
      },
    );
    try {
      var responseWithDio =
          await dio.post('${Env.URL_PREFIX}/createaccount.php', data: formData);
    } catch (e) {
      print(e);
    }
    Navigator.pop(context);
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
                        '회원가입',
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
                          id = value;
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
                              password = value;
                            },
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextFieldWidget(
                            hintText: '이름',
                            obscureText: false,
                            prefixIconData: Icons.phone_android_outlined,
                            //suffixIconData: model.isValid ? Icons.check : null,
                            onChanged: (value) {
                              username = value;
                            },
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextFieldWidget(
                            hintText: '휴대전화',
                            obscureText: false,
                            prefixIconData: Icons.phone_android_outlined,
                            //suffixIconData: model.isValid ? Icons.check : null,
                            onChanged: (value) {
                              phone = value;
                            },
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextFieldWidget(
                            hintText: '카드번호',
                            obscureText: false,
                            prefixIconData: Icons.credit_card,
                            //suffixIconData: model.isValid ? Icons.check : null,
                            onChanged: (value) {
                              card = value;
                            },
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      ButtonWidget(
                        title: '확인',
                        hasBorder: true,
                        onPressed: _onCreate,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
