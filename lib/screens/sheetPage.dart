import 'package:choocinema/globals/globals.dart';
import 'package:choocinema/states/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  makeReservation() {
    final UserState state = Provider.of<UserState>(context, listen: false);
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
                onPressed: () => {makeReservation()},
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
