import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testing_layout/components/constant.dart';

class InitialGenreSelection extends StatefulWidget {
  @override
  _InitialGenreSelectionState createState() => _InitialGenreSelectionState();
}

class _InitialGenreSelectionState extends State<InitialGenreSelection> {
  Map<String, bool> _genreMap = Map.fromIterable(
    genreTotalList,
    key: (element) => element,
    value: (element) => false,
  );

  Map<String, bool> _moodMap = Map.fromIterable(
    moodTotalList,
    key: (element) => element,
    value: (element) => false,
  );

  User _user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          elevation: 0,
          title: Text(
            '내가 좋아하는 음악 스타일',
            style: headline2,
          ),
          centerTitle: false,
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
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(defaultPadding),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '장르',
                        style: subtitle1,
                      ),
                    ),
                    SizedBox(height: 5),
                    Divider(
                      height: 0,
                      thickness: 2,
                      color: outlineColor,
                    ),
                    SizedBox(height: 20),
                    Wrap(
                      alignment: WrapAlignment.start,
                      spacing: 20,
                      runSpacing: 10,
                      children: _buildGenre(),
                    ),
                    SizedBox(height: 50),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '분위기',
                        style: subtitle1,
                      ),
                    ),
                    SizedBox(height: 5),
                    Divider(
                      height: 0,
                      thickness: 2,
                      color: outlineColor,
                    ),
                    SizedBox(height: 20),
                    Wrap(
                      alignment: WrapAlignment.start,
                      spacing: 20,
                      runSpacing: 10,
                      children: _buildMood(),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 30,
              right: 30,
              child: FlatButton(
                minWidth: MediaQuery.of(context).size.width - 60,
                height: 50,
                color: appKeyColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection('Users')
                      .doc(_user.uid)
                      .update(
                    {
                      'preferred_genre': _makeLikedGenreList(),
                      'preferred_mood': _makeLikedMoodList(),
                    },
                  );
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/inapp', (Route<dynamic> route) => false);
                },
                child: Text(
                  '선택 완료',
                  style: subtitle1,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _buildGenre() {
    List<Widget> genreChildren = [];
    for (var index = 0; index < _genreMap.length; index++) {
      genreChildren.add(
        InkWell(
          onTap: () {
            _selectGenre(index);
          },
          child: _genreMap[_genreMap.keys.toList()[index]]
              ? Container(
                  width: 95,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: appKeyColor,
                      width: 1,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(widgetRadius),
                  ),
                  padding: EdgeInsets.all(widgetDefaultPadding),
                  child: Text(
                    _genreMap.keys.toList()[index],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: appKeyColor,
                    ),
                  ),
                )
              : Container(
                  width: 95,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                      width: 1,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(widgetRadius),
                  ),
                  padding: EdgeInsets.all(widgetDefaultPadding),
                  child: Text(
                    _genreMap.keys.toList()[index],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                ),
        ),
      );
    }
    return genreChildren;
  }

  List<Widget> _buildMood() {
    List<Widget> moodChildren = [];
    for (var index = 0; index < _moodMap.length; index++) {
      moodChildren.add(
        InkWell(
          onTap: () {
            _selectMood(index);
          },
          child: _moodMap[_moodMap.keys.toList()[index]]
              ? Container(
                  width: 95,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: appKeyColor,
                      width: 1,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(widgetRadius),
                  ),
                  padding: EdgeInsets.all(widgetDefaultPadding),
                  child: Text(
                    _moodMap.keys.toList()[index],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: appKeyColor,
                    ),
                  ),
                )
              : Container(
                  width: 95,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                      width: 1,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(widgetRadius),
                  ),
                  padding: EdgeInsets.all(widgetDefaultPadding),
                  child: Text(
                    _moodMap.keys.toList()[index],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                ),
        ),
      );
    }
    return moodChildren;
  }

  _selectGenre(int val) {
    setState(() {
      _genreMap[_genreMap.keys.toList()[val]] =
          !_genreMap[_genreMap.keys.toList()[val]];
    });
  }

  _selectMood(int val) {
    setState(() {
      _moodMap[_moodMap.keys.toList()[val]] =
          !_moodMap[_moodMap.keys.toList()[val]];
    });
  }

  _makeLikedGenreList() {
    List<String> res = [];
    for (var index = 0; index < _genreMap.length; index++) {
      if (_genreMap[_genreMap.keys.toList()[index]]) {
        res.add(_genreMap.keys.toList()[index]);
      }
    }
    return res;
  }

  _makeLikedMoodList() {
    List<String> res = [];
    for (var index = 0; index < _moodMap.length; index++) {
      if (_moodMap[_moodMap.keys.toList()[index]]) {
        res.add(_moodMap.keys.toList()[index]);
      }
    }
    return res;
  }
}
