import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/model/users.dart';

class UnionMoodEdit extends StatefulWidget {
  final UserDB userDB;
  const UnionMoodEdit({this.userDB});

  @override
  _UnionMoodEditState createState() => _UnionMoodEditState();
}

class _UnionMoodEditState extends State<UnionMoodEdit> {
  // ignore: deprecated_member_use
  List<int> _selectedItems = List<int>();

  _initializeMoodList() {
    for (var i = 0; i < moodTotalList.length; i++) {
      if (widget.userDB.mood != null) {
        for (var j = 0; j < widget.userDB.mood.length; j++) {
          if (moodTotalList[i] == widget.userDB.mood[j]) {
            _selectedItems.add(i);
          }
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeMoodList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          '당신의 음악 무드는?',
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
                  'mood': _makeMoodList(),
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
        itemCount: moodTotalList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              moodTotalList[index],
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

  _makeMoodList() {
    List<String> res = [];
    for (var j = 0; j < _selectedItems.length; j++) {
      res.add(moodTotalList[_selectedItems[j]]);
    }
    return res;
  }
}
