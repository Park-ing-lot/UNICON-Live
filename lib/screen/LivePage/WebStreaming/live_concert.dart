import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/model/artists.dart';
import 'package:testing_layout/model/lives.dart';
import 'package:testing_layout/model/users.dart';
import 'package:testing_layout/screen/LivePage/WebStreaming/web_streaming.dart';
import 'chatting.dart';
import 'webConstant.dart';

bool artistTap = false;

class LiveConcert extends StatefulWidget {
  final Artist artist;
  final Lives live;
  final UserDB userDB;
  LiveConcert({
    this.live,
    this.artist,
    this.userDB,
  });

  @override
  _LiveConcertState createState() => _LiveConcertState();
}

class _LiveConcertState extends State<LiveConcert> {
  Stream<DocumentSnapshot> documentStream;
  List<dynamic> viewers = [];

  StreamSubscription<DocumentSnapshot> stream;

  SharedPreferences _preferences;
  bool _live = true;
  bool _feed = true;

  void _loadFirst() async {
    // SharedPreferences의 인스턴스를 필드에 저장
    _preferences = await SharedPreferences.getInstance();
    setState(() {
      // SharedPreferences에 counter로 저장된 값을 읽어 필드에 저장. 없을 경우 0으로 대입
      _live = (_preferences.getBool('_live') ?? true);
      _feed = (_preferences.getBool('_feed') ?? true);
    });
  }

  @override
  void initState() {
    super.initState();
    hideChat = true;
    _loadFirst();

    documentStream = FirebaseFirestore.instance
        .collection('LiveTmp')
        .doc(widget.live.id)
        .snapshots(includeMetadataChanges: true);

    stream = documentStream.listen((event) {
      setState(() {
        viewers = event.data()['viewers'];
      });
    });

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    super.dispose();
    stream.cancel();
    // chatFocusNode.dispose();
    FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.artist.id)
        .get()
        .then((value) {
      if (value.data()['live_now'] == true) {
        widget.live.viewers.remove(widget.userDB.id);
        widget.live.reference.update({'viewers': widget.live.viewers});
      }
    });

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          title: Center(
            child: new Text(
              '라이브가 곧 종료됩니다.',
              style: TextStyle(
                  fontSize: subtitleFontSize, fontWeight: FontWeight.bold),
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text(
                "나가기",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: textFontSize,
                    fontWeight: FontWeight.w600),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _fetchData(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.artist.id)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        return _buildBody(context, snapshot.data);
      },
    );
  }

  Widget _buildBody(BuildContext context, DocumentSnapshot snapshot) {
    Artist _artist = Artist.fromSnapshot(snapshot);
    if (_artist.liveNow == false) {
      Future.delayed(Duration.zero, () async {
        _showExitDialog();
      });
    }
    maxwidth = MediaQuery.of(context).size.width;
    maxheight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(children: [
        InkWell(
          onTap: () {
            setState(() {
              if (chatFocusNode.hasFocus) {
                chatFocusNode.unfocus();
              } else {
                artistTap = !artistTap;
              }
            });
          },
          child: WebStreaming(
            artist: _artist,
            width: hideChat ? maxwidth : maxwidth * 0.7,
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: ChatWidget(
            live: widget.live,
            artist: _artist,
            userDB: widget.userDB,
            width: hideChat ? maxwidth - maxwidth : maxwidth - maxwidth * 0.7,
          ),
        ),
        Positioned(
          bottom: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 200),
                height: 50,
                width: hideChat
                    ? maxwidth
                    : chatFocusNode.hasFocus
                        ? maxwidth * 0.5
                        : maxwidth * 0.7,
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    CircleAvatar(
                      backgroundColor: appKeyColor,
                      radius: 8,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Text(
                        viewers.length.toString() + '  명 시청중',
                        style: TextStyle(
                            fontSize: widgetFontSize,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                    ),
                    IconButton(
                        icon: Icon(
                          hideChat
                              ? Icons.chat_bubble_outline
                              : Icons.chat_bubble,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            hideChat = !hideChat;
                            chatFocusNode.unfocus();
                            if (hideChat == true) {
                              goDown = true;
                            }
                          });
                        }),
                  ],
                ),
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 200),
                height: artistTap ? 100 : 0,
                width: hideChat
                    ? maxwidth
                    : chatFocusNode.hasFocus
                        ? maxwidth * 0.5
                        : maxwidth * 0.7,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(11),
                  ),
                ),
                child: Row(
                  children: [
                    VerticalDivider(
                      width: 20,
                    ),
                    CircleAvatar(
                      radius: 35,
                      backgroundImage: NetworkImage(_artist.profile),
                    ),
                    VerticalDivider(
                      width: 20,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _artist.name,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: subtitleFontSize),
                        ),
                        Text(
                          '라이브 방송중',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: subtitleFontSize - 2),
                        ),
                      ],
                    ),
                    Expanded(child: Text('')),
                    FlatButton(
                      height: 50,
                      color: appKeyColor,
                      onPressed: () {
                        _onLikePressed(widget.userDB);
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            widget.userDB.follow.contains(_artist.id)
                                ? MdiIcons.heart
                                : MdiIcons.heartOutline,
                            size: 25,
                          ),
                          Text(
                            ' Follow',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: subtitleFontSize),
                          )
                        ],
                      ),
                    ),
                    VerticalDivider(
                      width: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _fetchData(context);
  }

  void _onLikePressed(UserDB userDB) async {
    FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
    setState(() {
      // Add data to CandidatesDB
      if (!widget.artist.myPeople.contains(widget.userDB.id)) {
        widget.artist.myPeople.add(userDB.id);
        userDB.follow.add(widget.artist.id);
        if (_live) {
          _firebaseMessaging.subscribeToTopic(widget.artist.id + 'live');
        }
        if (_feed) {
          _firebaseMessaging.subscribeToTopic(widget.artist.id + 'Feed');
        }
      }

      // Unliked
      else {
        widget.artist.myPeople.remove(userDB.id);
        // Delete data from UsersDB

        userDB.follow.remove(widget.artist.id);
        if (_live) {
          _firebaseMessaging.unsubscribeFromTopic(widget.artist.id + 'live');
        }
        if (_feed) {
          _firebaseMessaging.unsubscribeFromTopic(widget.artist.id + 'Feed');
        }
      }
    });
    await widget.artist.reference.update({'my_people': widget.artist.myPeople});
    await userDB.reference.update({'follow': userDB.follow});
  }
}
