import 'package:choocinema/states/movie.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import '../env.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../globals/globals.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String tmp;
  bool _isLoading = false;
  List<NetworkImage> _poster;
  int rows;
  List<Movie> movies;

  getRows() async {
    Dio dio = Dio();
    int rows;
    try {
      var responseWithDio =
          await dio.get('${Env.URL_PREFIX}/getrownum.php?table=movie');
      rows = int.parse(responseWithDio.data);
    } catch (e) {
      print(e);
    }

    this.rows = rows;
  }

  // ignore: missing_return
  getList() async {
    setState(() {
      _isLoading = true;
    });

    Dio dio = Dio();
    int rows;
    try {
      var responseWithDio =
          await dio.get('${Env.URL_PREFIX}/getrownum.php?table=movie');
      rows = int.parse(responseWithDio.data);
    } catch (e) {
      print(e);
    }

    for (int i = 1; i <= rows; i++) {
      String path =
          "${Env.URL_PREFIX}/getposter.php?movieNumber=" + i.toString();
      Image tmp = Image.network(
        path,
        fit: BoxFit.fill,
      );
      //_poster.add(NetworkImage(path));
    }

    print('@@@@@@@@@@@@@@@@@@@@@@@@');
    try {
      var responseWithDio = await dio.get('${Env.URL_PREFIX}/getmovielist.php');

      final items =
          json.decode(responseWithDio.data).cast<Map<String, dynamic>>();

      List<Movie> movies = (items).map<Movie>((json) {
        return Movie.fromJson(json);
      }).toList();
      this.movies = movies;
      print(movies);
    } catch (e) {
      print(e);
    }

    /*
    var responseWithDio;
    Map<String, dynamic> list;
    Dio dio = Dio();
    //Dio 이용하여 통신
    try {
      responseWithDio = await dio.get('${Env.URL_PREFIX}/list.php');
      tmp = responseWithDio.data;
    } catch (e) {
      print(e);
    }
    */
    setState(() {
      _isLoading = false;
    });
  }

  NetworkImage getImage(int index) {
    return _poster[index];
  }

  @override
  void initState() {
    super.initState();
    getRows();
    getList();
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
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: new Column(
                  children: <Widget>[
                    //제일 위의 레이아웃
                    Container(
                      child: SizedBox(
                        height: 10,
                      ),
                      height: 10,
                    ),
                    Container(
                      child: SizedBox(
                        height: 10,
                      ),
                      height: 10,
                    ),
                    Container(
                      child: Text(
                        '영화리스트',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Colors.white),
                      ),
                      height: 50,
                    ),
                    Container(
                      child: SizedBox(
                        height: 10,
                      ),
                      height: 10,
                    ),
                    Container(
                      //이미지 슬라이드 뷰 부분
                      height: 500,
                      padding: EdgeInsets.fromLTRB(10, 10, 20, 50),
                      child: new Swiper(
                        itemBuilder: (BuildContext context, int index) {
                          return ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.network(
                                "${Env.URL_PREFIX}/getposter.php?movieNumber=" +
                                    (index + 1).toString(),
                                fit: BoxFit.fill,
                              ));
                        },
                        itemCount: rows,
                        viewportFraction: 0.8,
                        scale: 0.1,
                        autoplay: true,
                        autoplayDisableOnInteraction: true,
                        control: new SwiperControl(),
                        pagination: new SwiperPagination(
                            margin: EdgeInsets.fromLTRB(10, 10, 10, 10)),
                        onTap: onTap,
                      ),
                    ),
                    Container(
                      child: SizedBox(
                        height: 30,
                      ),
                      height: 30,
                    ),
                    Container(
                        // 아래 하얀색 패널 부분
                        height: 500,
                        padding: EdgeInsets.only(top: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30)),
                            color: Colors.white),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: Text(
                                '🍿 무비차트',
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold),
                              ),
                              padding: EdgeInsets.only(left: 30),
                            ),

                            //영화정보 리스트
                            Expanded(
                              child: ListView.separated(
                                  //아래 상영영화 리스트 뷰 부분
                                  scrollDirection: Axis.horizontal,
                                  padding:
                                      const EdgeInsets.fromLTRB(30, 10, 30, 20),
                                  itemCount: rows,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      height: 100,
                                      width: 300,
                                      //color: Colors.black,
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 10, 20, 10),
                                      child: new GestureDetector(
                                        onTap: () => {print('hi')},
                                        child: new Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10),
                                                bottomLeft: Radius.circular(10),
                                                bottomRight:
                                                    Radius.circular(10)),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                spreadRadius: 5,
                                                blurRadius: 7,
                                                offset: Offset(0,
                                                    3), // changes position of shadow
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            children: <Widget>[
                                              Expanded(
                                                child: Image.network(
                                                  "${Env.URL_PREFIX}/getposter.php?movieNumber=" +
                                                      (index + 1).toString(),
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                width: 220,
                                                constraints: BoxConstraints(
                                                    maxWidth: 300),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      movies[index].movieTitle,
                                                      style: TextStyle(
                                                          fontSize: 30,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    SizedBox(
                                                      height: 1,
                                                    ),
                                                    Row(
                                                      children: <Widget>[
                                                        Text(
                                                          '📣 ' +
                                                              movies[index]
                                                                  .movieDir +
                                                              ' 감독',
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                          '🎭 ' +
                                                              movies[index]
                                                                  .leadActor +
                                                              ' 주연',
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    ElevatedButton(
                                                        onPressed: () =>
                                                            {print('예약')},
                                                        child: Text('예약하기')),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          const Divider()),
                            ),
                          ],
                        ))
                  ],
                ),
              ));
  }

  void onTap(int index) {
    print(index);
  }
}
