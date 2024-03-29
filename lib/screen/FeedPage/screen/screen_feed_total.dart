import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/model/feed.dart';
import 'package:testing_layout/model/users.dart';
import 'package:testing_layout/screen/FeedPage/widget/widget_feed_box.dart';
import 'package:testing_layout/screen/FeedPage/components/feed_functions.dart';

class FeedTotal extends StatefulWidget {
  final UserDB userDB;
  FeedTotal({
    Key key,
    this.userDB,
  }) : super(key: key);

  @override
  _FeedTotalState createState() => _FeedTotalState();
}

class _FeedTotalState extends State<FeedTotal> {
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

  @override
  Widget build(BuildContext context) {
    var userDB = Provider.of<UserDB>(context);
    var feeds = Provider.of<List<Feed>>(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Text(
          '전체 보기',
          style: headline2,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.close,
              size: 30,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
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
                children: [Column(children: feedBoxes(feeds, userDB))],
              ),
            ),
            Positioned(
              bottom: 0,
              child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  height: 40,
                  child: musicPlayer(_assetsAudioPlayer)),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> feedBoxes(List<Feed> feeds, UserDB userDB) {
    List<Widget> results = [];
    for (var i = 0; i < feeds.length; i++) {
      if (userDB.dislikePeople != null) {
        if (userDB.dislikePeople.contains(feeds[i].id)) {
          continue;
        }
      }
      if (userDB.dislikeFeed != null) {
        if (userDB.dislikeFeed.contains(feeds[i].feedID)) {
          continue;
        }
      }
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
