import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/model/feed.dart';
import 'package:testing_layout/model/users.dart';
import 'package:testing_layout/screen/FeedPage/widget/widget_feed_box.dart';
import 'package:testing_layout/screen/FeedPage/components/feed_functions.dart';

class MyFeedPage extends StatefulWidget {
  final UserDB userDB;
  final String id;
  MyFeedPage({
    Key key,
    this.userDB,
    this.id,
  }) : super(key: key);

  @override
  _MyFeedPageState createState() => _MyFeedPageState();
}

class _MyFeedPageState extends State<MyFeedPage> {
  AssetsAudioPlayer get _assetsAudioPlayer => AssetsAudioPlayer.withId("music");
  ScrollController scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  Widget _fetchData(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Feed')
          .where('id', isEqualTo: widget.id)
          .orderBy('time', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        return _buildBody(context, snapshot.data.docs);
      },
    );
  }

  Widget _buildBody(BuildContext context, List<DocumentSnapshot> snapshot) {
    final myFeeds = snapshot.map((e) => Feed.fromSnapshot(e)).toList();

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          '내가 쓴 글',
          style: headline2,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            size: 30,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: ListView(
                controller: scrollController,
                addAutomaticKeepAlives: true,
                children: [
                  Column(children: myFeedBoxes(myFeeds, widget.userDB)),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: musicPlayer(_assetsAudioPlayer),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _fetchData(context);
  }

  List<Widget> myFeedBoxes(List<Feed> feeds, UserDB userDB) {
    List<Widget> results = [];
    for (var i = 0; i < feeds.length; i++) {
      results.add(Divider(
        height: 5,
        thickness: 5,
        color: appBarColor,
      ));
      results.add(FeedBox(
        feed: feeds[i],
        userDB: userDB,
      ));
    }
    if (results.length == 0) {
      results.add(Container(
        alignment: Alignment.center,
        height: 300,
        child: Text(
          '글이 없습니다.',
          style: TextStyle(fontSize: textFontSize, fontWeight: FontWeight.w600),
        ),
      ));
    }
    return results;
  }
}
