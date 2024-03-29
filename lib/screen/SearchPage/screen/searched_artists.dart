import 'package:flutter/material.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/model/artists.dart';
import 'package:testing_layout/model/users.dart';
import 'package:testing_layout/screen/SearchPage/widget/search_artist_box.dart';

class SearchedArtist extends StatefulWidget {
  final List<Artist> artists;
  final UserDB userDB;
  final String title;
  SearchedArtist(this.artists, this.userDB, this.title);
  @override
  _SearchedArtistState createState() => _SearchedArtistState();
}

class _SearchedArtistState extends State<SearchedArtist> {
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0.0,
        centerTitle: false,
        title: Text(
          widget.title,
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
      ),
      body: widget.artists.length == 0
          ? Center(
              child: Text(
                '아티스트가 없습니다.',
                style: TextStyle(
                  fontSize: subtitleFontSize,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            )
          : Padding(
              padding: EdgeInsets.all(20),
              child: GridView.count(
                controller: _scrollController,
                scrollDirection: Axis.vertical,
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                childAspectRatio: 1 / 1.3,
                children: List.generate(
                  widget.artists.length,
                  (index) {
                    return SearchArtistBox(
                      userDB: widget.userDB,
                      artist: widget.artists[index],
                    );
                  },
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        mini: true,
        onPressed: () {
          _scrollController.animateTo(
            0.0,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 300),
          );
        },
        child: Icon(
          Icons.arrow_upward,
          color: Colors.white,
        ),
        backgroundColor: appKeyColor,
      ),
    );
  }
}
