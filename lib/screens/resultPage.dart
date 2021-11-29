import 'package:choocinema/globals/globals.dart';
import 'package:choocinema/states/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResultPage extends StatefulWidget {
  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
    final UserState state = Provider.of<UserState>(context, listen: false);

    return Scaffold(
      backgroundColor: Global.megaboxBack,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          title: Text('예매 내역서'),
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
                //여기가 결과 타일들
                child: Container(
              child: ListView.builder(
                itemCount: state.reservs.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    // color: Colors.blue,
                    height: 440,
                    width: 500,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(17, 20, 17, 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset:
                                Offset(10, 15), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "#  " + (index + 1).toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 30),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text("영화번호 : " + state.reservs[index]['movieNumber'],
                              style: TextStyle(
                                  fontWeight: FontWeight.w300, fontSize: 20)),
                          Text("영화시간 : " + state.reservs[index]['time'],
                              style: TextStyle(
                                  fontWeight: FontWeight.w300, fontSize: 20)),
                          Text(
                              "상영관번호 : " + state.reservs[index]['cinemaNumber'],
                              style: TextStyle(
                                  fontWeight: FontWeight.w300, fontSize: 20)),
                          Text("행번호 : " + state.reservs[index]['row'],
                              style: TextStyle(
                                  fontWeight: FontWeight.w300, fontSize: 20)),
                          Text("위치번호 : " + state.reservs[index]['col'],
                              style: TextStyle(
                                  fontWeight: FontWeight.w300, fontSize: 20)),
                          Text("열  : " + state.reservs[index]['ab'],
                              style: TextStyle(
                                  fontWeight: FontWeight.w300, fontSize: 20)),
                          Text("유저아이디 : " + state.reservs[index]['userid'],
                              style: TextStyle(
                                  fontWeight: FontWeight.w300, fontSize: 20)),
                          Text(
                              "예약시간 : " +
                                  state.reservs[index]['reservationDate'],
                              style: TextStyle(
                                  fontWeight: FontWeight.w300, fontSize: 20)),
                          Text("할인 후 금액 : " + state.reservs[index]['fee'],
                              style: TextStyle(
                                  fontWeight: FontWeight.w300, fontSize: 20)),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                    padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
                  );
                },
              ),
            )),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () => {Navigator.pop(context)}, child: Text('확인')),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
