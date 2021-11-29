import 'package:choocinema/main.dart';
import 'package:choocinema/states/movie.dart';
import 'package:choocinema/states/schedule.dart';
import 'package:choocinema/states/user.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../env.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../globals/globals.dart';
import '../wigets/datebutton_widget.dart';
import 'package:intl/intl.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  //http 연결을 위한 Dio 생성
  Dio dio = Dio();

  //jsondecoded
  var _jsonDecoded;

  PanelController _pc = new PanelController();

  //http 통신을 할 때 true
  bool _isMainLoding = false;
  bool _isSliderLoading = false;

  //영화의 갯수
  int rows;

  //영화 정보들 from database
  List<Movie> movies;

  //시간에 따른 스케쥴들
  List<Schedule> schedules;

  String a = 'test';

  //
  bool _isSlideAble = true;
  //좌석 예매 장면 순서
  int _reservationSequence = 0;

  //선택한 날짜의 인덱스 번호
  int toggledIndex = 0;

  //사용자가 선택한 영화 인덱스 번호
  int selectedMovie = 0;

  String cinemaType = "";

  //영화 갯수 불러오기
  getRows() async {
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
      _isMainLoding = true;
    });

    //영화 목록 불러오기
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
      _isMainLoding = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getRows();
    getList();
  }

  //영화를 눌렀을 때
  selectCinema(int index) async {
    setState(() {
      _isSliderLoading = true;
    });

    final UserState state = Provider.of<UserState>(context, listen: false);
    state.setMovieNum(movies[index].movieNumber);

    print('누른날짜 $toggledIndex');
    DateTime now = DateTime.now();
    DateTime add = new DateTime(now.year, now.month, now.day + toggledIndex,
        now.hour, now.minute, now.second);
    String daySave = (now.day + toggledIndex).toString();
    //state.setMovieTime(add.toString());
    var responseWithDio = await dio.get(
        '${Env.URL_PREFIX}/getschedule.php?movieNumber=' +
            state.movienum +
            '&day=' +
            daySave);
    final items =
        json.decode(responseWithDio.data).cast<Map<String, dynamic>>();

    List<Schedule> schedules = (items).map<Schedule>((json) {
      return Schedule.fromJson(json);
    }).toList();
    this.schedules = schedules;

    setState(() {
      _isSliderLoading = false;
      _pc.open();
      selectedMovie = index;
    });
  }

  //시간을 눌렀을 때
  choiceSeat(int index) {
    print('좌석선태그올..');
    final UserState state = Provider.of<UserState>(context, listen: false);
    //state.setMovieTime(schedules[index].time);
    state.setCinemaNum(schedules[index].cinemaNumber);
    state.setMovieTime(schedules[index].time);
    state.setFee(schedules[index].fee);
    _pc.close();
    Navigator.pushNamed(context, SHEAT_PAGE);
  }

  selectTime() {
    setState(() {
      _reservationSequence = 2;
    });
  }

  //날자를 눌렀을 때
  toggleButton(int index) {
    toggledIndex = index;
    setState(() {
      selectCinema(selectedMovie);
      print('날자 인덱스 : $index');
    });
  }

  sliderPanelClosed() {
    setState(() {
      _reservationSequence = 0;
      toggledIndex = 0;
    });
  }

  disableSlidable() {
    setState(() {
      _isSlideAble = false;
    });
  }

  enableSlidable() {
    setState(() {
      _isSlideAble = true;
    });
  }

  changePage() {
    setState(() {
      Navigator.pushNamed(context, SHEAT_PAGE);
    });
  }

  getCinemaType(int index) async {
    var responseWithDio = await dio.get(
        '${Env.URL_PREFIX}/cinemaNumber.php?cinemaNumber=' +
            schedules[index].cinemaNumber);
    final items =
        json.decode(responseWithDio.data).cast<Map<String, dynamic>>();
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
                onPressed: () =>
                    {Navigator.pushNamed(context, RESULT_PAGE)}, //계정정보로 빠짐
              )
            ],
          ),
        ),
        body: _isMainLoding
            ? Center(child: CircularProgressIndicator())
            //슬라이딩 패널 추가
            : SlidingUpPanel(
                isDraggable: _isSlideAble,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.0),
                  topRight: Radius.circular(50.0),
                ),
                /*
                //접혔을 때 꾸미는 것 
                collapsed: Container(
                    decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50.0),
                          topRight: Radius.circular(50.0),
                        ))),
                        */
                panelBuilder: (sc) => panel(sc),
                backdropEnabled: true,
                controller: _pc,
                maxHeight: 600,
                minHeight: 0.0,
                onPanelClosed: () => {sliderPanelClosed()},
                body: SingleChildScrollView(
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
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                                padding: EdgeInsets.only(left: 30),
                              ),

                              //영화정보 리스트
                              Expanded(
                                child: ListView.separated(
                                    //아래 상영영화 리스트 뷰 부분
                                    scrollDirection: Axis.horizontal,
                                    padding: const EdgeInsets.fromLTRB(
                                        30, 10, 30, 10),
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
                                                  bottomLeft:
                                                      Radius.circular(10),
                                                  bottomRight:
                                                      Radius.circular(10)),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  spreadRadius: 5,
                                                  blurRadius: 7,
                                                  offset: Offset(0, 3),
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
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(
                                                        movies[index]
                                                            .movieTitle,
                                                        style: TextStyle(
                                                            fontSize: 30,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
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
                                                                color: Colors
                                                                    .grey),
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Container(
                                                            width: 110,
                                                            child: Text(
                                                              '🎭 ' +
                                                                  movies[index]
                                                                      .leadActor +
                                                                  ' 주연',
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  color: Colors
                                                                      .grey),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      ElevatedButton(
                                                          onPressed: () => {
                                                                selectCinema(
                                                                    index)
                                                              },
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
                          )),
                      Container(
                        height: 73,
                      )
                    ],
                  ),
                ),
              ));
  }

  void onTap(int index) {
    print(index);
  }

  Widget panel(ScrollController sc) {
    return MediaQuery.removePadding(context: context, child: getWidget());
  }

  Widget getWidget() {
    switch (_reservationSequence) {
      //상영관 선택
      case 0:
        return Container(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
              onTapDown: (TapDownDetails tapDownDetails) async {
                enableSlidable();
              },
              onVerticalDragDown: (DragDownDetails dragDownDetails) async {
                // Write the actions here
                enableSlidable();
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Global.megaboxBlack,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    )),
                height: 200,
                padding: EdgeInsets.fromLTRB(20, 15, 0, 0),
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 200,
                      padding: EdgeInsets.fromLTRB(0, 0, 25, 10),
                      child: Container(
                        child: Image.network(
                          "${Env.URL_PREFIX}/getposter.php?movieNumber=" +
                              (selectedMovie + 1).toString(),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            //padding: EdgeInsets.only(bottom: 40),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  movies[selectedMovie].movieTitle,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 40),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                    schedules != null && schedules.length != 0
                                        ? "가격 : " + schedules[toggledIndex].fee
                                        : "",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20),
                                    overflow: TextOverflow.ellipsis),
                                SizedBox(
                                  height: 20,
                                )
                              ],
                            ),
                          ),
                          Expanded(
                              child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 30,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () => {toggleButton(index)},
                                      child: Container(
                                        width: 70,
                                        child: Text(
                                          (() {
                                            DateTime now = DateTime.now();
                                            DateTime add = new DateTime(
                                                now.year,
                                                now.month,
                                                now.day + index);
                                            return add.day.toString();
                                          })(),
                                          style: (TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white)),
                                        ),
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(right: 5),
                                        color: toggledIndex == index
                                            ? Global.megaboxwhite
                                            : Global.megabox,
                                      ),
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          const Divider()))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            _isSliderLoading
                ? Container()
                : Expanded(
                    child: GestureDetector(
                    onVerticalDragDown: (DragDownDetails dragDownDetails) {
                      // Write the actions here
                      disableSlidable();
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 0, right: 0),
                      child: ListView.builder(
                        itemCount: schedules == null ? 0 : schedules.length,
                        itemBuilder: (BuildContext context, int x) {
                          return Container(
                            height: 170,
                            child: Container(
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    schedules == null
                                        ? ""
                                        : '상영관 : ' + schedules[x].cinemaNumber,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Expanded(
                                      child: Container(
                                    padding: EdgeInsets.only(top: 20),
                                    child: ListView.builder(
                                      itemCount: 1,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder:
                                          (BuildContext context, int y) {
                                        return GestureDetector(
                                          onTap: () => {choiceSeat(y)},
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 1,
                                                    color: Colors.black)),
                                            width: 150,
                                            alignment: Alignment.center,
                                            child: Text(
                                              schedules[x].getTime(),
                                              style: TextStyle(
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ))
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ))
          ],
        ));
        break;
      case 1:
        changePage();
        break;
      case 2:
        return Container(
          color: Colors.yellow,
        );
        break;
      default:
    }
  }
}
