import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/model/users.dart';

class UnionGenreEdit extends StatefulWidget {
  final UserDB userDB;
  const UnionGenreEdit({this.userDB});

  @override
  _UnionGenreEditState createState() => _UnionGenreEditState();
}

class _UnionGenreEditState extends State<UnionGenreEdit> {
  // ignore: deprecated_member_use
  List<int> _selectedItems = List<int>();

  _initializeGenreList() {
    for (var i = 0; i < genreTotalList.length; i++) {
      if (widget.userDB.genre != null) {
        for (var j = 0; j < widget.userDB.genre.length; j++) {
          if (genreTotalList[i] == widget.userDB.genre[j]) {
            _selectedItems.add(i);
          }
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeGenreList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          '당신의 음악 장르는?',
          style: headline2,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.close,
            size: 30,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          FlatButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('Users')
                  .doc(widget.userDB.id)
                  .update(
                {
                  'genre': _makeGenreList(),
                },
              );
              Navigator.of(context).pop();
            },
            child: Text(
              '완료',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: appKeyColor,
              ),
            ),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: genreTotalList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              genreTotalList[index],
              style: body1,
            ),
            trailing: (_selectedItems.contains(index))
                ? Icon(
                    Icons.check,
                    color: appKeyColor,
                    size: 25,
                  )
                : null,
            onTap: () {
              if (!_selectedItems.contains(index)) {
                setState(() {
                  _selectedItems.add(index);
                });
              } else {
                setState(() {
                  _selectedItems.removeWhere((val) => val == index);
                });
              }
            },
          );
        },
      ),
    );
  }

  _makeGenreList() {
    List<String> res = [];
    for (var j = 0; j < _selectedItems.length; j++) {
      res.add(genreTotalList[_selectedItems[j]]);
    }
    return res;
  }
}
