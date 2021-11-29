import 'dart:convert';

import 'package:choocinema/globals/globals.dart';
import 'package:choocinema/main.dart';
import 'package:choocinema/states/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../env.dart';

class SheetPage extends StatefulWidget {
  SheetPage({Key key}) : super(key: key);

  @override
  _SheetPageState createState() => _SheetPageState();
}

class _SheetPageState extends State<SheetPage> {
  List<int> array_a = [];
  List<int> array_b = [];

  @override
  void initState() {
    super.initState();
  }

  addSheetA(int index) {
    print(index);

    if (array_a.contains(index)) {
      array_a.remove(index);
    } else {
      array_a.add(index);
    }
    setState(() {});
  }

  addSheetB(int index) {
    if (array_b.contains(index)) {
      array_b.remove(index);
    } else {
      array_b.add(index);
    }
    setState(() {});
  }

  makeReservation() async {
    final UserState state = Provider.of<UserState>(context, listen: false);

    Dio dio = new Dio();
    for (int i in array_a) {
      int row = (i / 3).round();
      int col = i % 3;
      print(state.movietime);
      String test = state.cinemanum;

      state.setRowNum(row.toString());
      state.setColNum(col.toString());

      //상영관별 자리 예매 저장
      var responseWithDio = await dio.get(
          '${Env.URL_PREFIX}/setsheet.php?cinemaNumber=' +
              state.cinemanum +
              '&row=' +
              row.toString() +
              '&col=' +
              col.toString() +
              '&ab=a' +
              '&time=' +
              state.movietime);

      //할인율 가져오기
      var gradeAndrate =
          await dio.get('${Env.URL_PREFIX}/getgrade.php?userid=' + state.id);

      final Map rate = json.decode(gradeAndrate.data);

      state.setFee(state.fee);
      //할인율 기반 가격계산하기
      int evaluate = (double.parse(state.fee) *
              (1 - (double.parse(rate['discountrate']) / 100)))
          .round();

      var now = DateTime.now().toString();

      state.setEvaluate(evaluate.toString());
      state.setReservatioDate(now);

      Map<String, String> tmp = {
        "movieNumber": state.movienum,
        "time": state.movietime,
        "cinemaNumber": state.cinemanum,
        "row": row.toString(),
        "col": col.toString(),
        "ab": "b",
        "userid": state.id,
        "reservationDate": now,
        "fee": evaluate.toString()
      };

      var formdata = FormData.fromMap(tmp);
      state.setReserv(tmp);

      var makeReservation = await dio
          .post('${Env.URL_PREFIX}/makereservation.php', data: formdata);
      print(makeReservation);
    }

    for (int i in array_b) {
      int row = (i / 3).round();
      int col = i % 3;
      print(state.cinemanum);
      String test = state.cinemanum;

      var responseWithDio = await dio.get(
          '${Env.URL_PREFIX}/setsheet.php?cinemaNumber=' +
              state.cinemanum +
              '&row=' +
              row.toString() +
              '&col=' +
              col.toString() +
              '&ab=b' +
              '&time=' +
              state.movietime);

      //할인율 가져오기
      var gradeAndrate =
          await dio.get('${Env.URL_PREFIX}/getgrade.php?userid=' + state.id);

      final rate = json.decode(gradeAndrate.data);

      //할인율 기반 가격계산하기
      var evaluate = double.parse(state.fee) *
          (1 - (double.parse(rate['discountrate']) / 100));

      var now = DateTime.now().toString();

      state.setEvaluate(evaluate.toString());
      state.setReservatioDate(now);

      Map<String, String> tmp = {
        "movieNumber": state.movienum,
        "time": state.movietime,
        "cinemaNumber": state.cinemanum,
        "row": row.toString(),
        "col": col.toString(),
        "ab": "b",
        "userid": state.id,
        "reservationDate": now,
        "fee": evaluate.toString()
      };

      var formdata = FormData.fromMap(tmp);
      state.setReserv(tmp);

      var makeReservation = await dio
          .post('${Env.URL_PREFIX}/makereservation.php', data: formdata);
      print(makeReservation);
    }

    Navigator.popAndPushNamed(context, RESULT_PAGE);
  }

  resultdialog(String result) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('로그인 실패'),
            content: SingleChildScrollView(child: Text('아이디 또는 비밀번호를 확인하세요')),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('확인')),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Global.megaboxBack,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          automaticallyImplyLeading: false,
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.account_circle_outlined),
              tooltip: 'Account Inform',
              onPressed: () => {print('test')}, //계정정보로 빠짐
            )
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
                child: Container(
              child: Row(
                children: <Widget>[
                  Container(
                    color: Colors.black,
                    width: 200,
                    child: Center(
                      child: Container(
                          width: 180,
                          height: 500,
                          padding: EdgeInsets.all(10),
                          color: Colors.blue,
                          child: GridView.count(
                            // Create a grid with 2 columns. If you change the scrollDirection to
                            // horizontal, this produces 2 rows.
                            crossAxisCount: 3,
                            mainAxisSpacing: 10,
                            // Generate 100 widgets that display their index in the List.
                            children: List.generate(30, (index) {
                              return GestureDetector(
                                onTap: () => {addSheetA(index)},
                                child: Center(
                                  child: Container(
                                    child: Center(
                                      child: Text(
                                        '$index',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    width: 50,
                                    height: 50,
                                    color: array_a.contains(index)
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              );
                            }),
                          )),
                    ),
                  ),
                  Expanded(
                      child: Container(
                    color: Colors.black,
                    child: Center(
                      child: Container(
                          width: 180,
                          height: 500,
                          color: Colors.redAccent,
                          child: GridView.count(
                            // Create a grid with 2 columns. If you change the scrollDirection to
                            // horizontal, this produces 2 rows.
                            crossAxisCount: 3,
                            mainAxisSpacing: 10,
                            // Generate 100 widgets that display their index in the List.
                            children: List.generate(30, (index) {
                              return GestureDetector(
                                onTap: () => {addSheetB(index)},
                                child: Center(
                                  child: Container(
                                    child: Center(
                                      child: Text(
                                        '$index',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    width: 50,
                                    height: 50,
                                    color: array_b.contains(index)
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              );
                            }),
                          )),
                    ),
                  ))
                ],
              ),
              color: Colors.blue,
            )),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: makeReservation,
                child: Text(
                  '예약하기',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                )),
            SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}
