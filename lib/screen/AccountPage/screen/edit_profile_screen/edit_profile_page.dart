import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/components/uni_icon_icons.dart';
import 'package:testing_layout/model/users.dart';
import 'package:testing_layout/screen/AccountPage/screen/edit_profile_screen/screen/screen_union_genre_edit.dart';
import 'package:testing_layout/screen/AccountPage/screen/edit_profile_screen/screen/screen_union_mood_edit.dart';
import 'package:testing_layout/screen/LoginPage/screen/artist_format/screen_artist_format.dart';
import 'package:testing_layout/screen/LoginPage/login_page.dart';
import 'package:image/image.dart' as img;

class EditProfilePage extends StatefulWidget {
  final UserDB userDB;

  const EditProfilePage({Key key, this.userDB}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File _image;
  bool _canGo = true;
  FToast fToast;
  bool _isLoading = false;

  String _profileImageURL;
  String _resizedProfileURL;
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  TextEditingController _nameEditingController = TextEditingController();
  TextEditingController _instagramEditingController = TextEditingController();
  TextEditingController _youtubeEditingController = TextEditingController();
  TextEditingController _soundcloudEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _profileImageURL = widget.userDB.profile;
    _nameEditingController = TextEditingController(text: widget.userDB.name);

    fToast = FToast();
    fToast.init(context);

    if (widget.userDB.isArtist) {
      _instagramEditingController =
          TextEditingController(text: widget.userDB.instagramId);
      _youtubeEditingController =
          TextEditingController(text: widget.userDB.youtubeLink);
      _soundcloudEditingController =
          TextEditingController(text: widget.userDB.soudcloudLink);
    }
  }

  List<Widget> _buildUnionProfile() {
    return <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 20,
            ),
            Center(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: appKeyColor,
                        width: 1.5,
                      ),
                    ),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(_profileImageURL),
                      radius: 80,
                    ),
                  ),
                  Positioned(
                    top: 5,
                    right: 5,
                    child: IconButton(
                      icon: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          UniIcon.fix,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _canGo = false;
                        });
                        _uploadImageToStorage(ImageSource.gallery);
                      },
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  UniIcon.profile,
                  size: 30,
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: TextFormField(
                    autocorrect: false,
                    textInputAction: TextInputAction.next,
                    controller: _nameEditingController,
                    style: body2,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: "활동명 (필수)",
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: appKeyColor,
                          width: 1,
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  UniIcon.soundcloud,
                  size: 30,
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: TextFormField(
                    autocorrect: false,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.url,
                    controller: _soundcloudEditingController,
                    style: body2,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: "Soundcloud link",
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: appKeyColor,
                          width: 1,
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  UniIcon.youtube,
                  size: 30,
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: TextFormField(
                    autocorrect: false,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.url,
                    controller: _youtubeEditingController,
                    style: body2,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: "Youtube link",
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: appKeyColor,
                          width: 1,
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  UniIcon.instagram,
                  size: 30,
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: TextFormField(
                    autocorrect: false,
                    textInputAction: TextInputAction.done,
                    controller: _instagramEditingController,
                    keyboardType: TextInputType.text,
                    style: body2,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: "Instagram ID",
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: appKeyColor,
                          width: 1,
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      SizedBox(
        height: 30,
      ),
      Divider(
        height: 0,
        color: outlineColor,
      ),
      InkWell(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '장르 수정하기',
              style: body1,
            ),
          ),
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => UnionGenreEdit(userDB: widget.userDB),
              fullscreenDialog: true,
            ),
          );
        },
      ),
      Divider(
        height: 0,
        color: outlineColor,
      ),
      InkWell(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '무드 수정하기',
              style: body1,
            ),
          ),
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => UnionMoodEdit(userDB: widget.userDB),
              fullscreenDialog: true,
            ),
          );
        },
      ),
      Divider(
        height: 0,
        color: outlineColor,
      ),
      InkWell(
        onTap: signoutAccount,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '로그아웃',
              style: TextStyle(
                color: Colors.red,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
      Divider(
        height: 0,
        color: outlineColor,
      ),
      SizedBox(height: 120),
    ];
  }

  List<Widget> _buildUserProfile() {
    return [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 20,
            ),
            Center(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: appKeyColor,
                        width: 1.5,
                      ),
                    ),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(_profileImageURL),
                      radius: 80,
                    ),
                  ),
                  Positioned(
                    top: 5,
                    right: 5,
                    child: IconButton(
                      icon: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          UniIcon.fix,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _canGo = false;
                        });
                        _uploadImageToStorage(ImageSource.gallery);
                      },
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  UniIcon.profile,
                  size: 30,
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: TextFormField(
                    autocorrect: false,
                    textInputAction: TextInputAction.next,
                    controller: _nameEditingController,
                    style: body2,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: "이름 (필수)",
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: appKeyColor,
                          width: 1,
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      SizedBox(
        height: 30,
      ),
      Divider(
        height: 0,
        color: outlineColor,
      ),
      widget.userDB.isArtist == false
          ? InkWell(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '유니온 전환',
                          style: TextStyle(
                            color: appKeyColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      InkWell(
                        child: Icon(
                          UniIcon.more_info,
                          color: appKeyColor,
                          size: 21,
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(dialogRadius),
                                ),
                                backgroundColor: dialogColor1,
                                title: Center(
                                  child: Text(
                                    '유니온이란?',
                                    style: title1,
                                  ),
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      ' 일반 유저도 별도의 등록 과정을 통해 유니온으로 전환되어 공연을 진행할 수 있습니다.',
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: FlatButton(
                                            color: appKeyColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      widgetRadius),
                                            ),
                                            onPressed: () async {
                                              Navigator.of(context).pop();
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ArtistForm(),
                                                ),
                                              );
                                            },
                                            child: Text(
                                              '도전하기',
                                              style: subtitle2,
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ArtistForm(),
                  ),
                );
              },
            )
          : SizedBox(),
      widget.userDB.isArtist == false
          ? Divider(
              height: 0,
              color: outlineColor,
            )
          : SizedBox(),
      InkWell(
        onTap: signoutAccount,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '로그아웃',
              style: TextStyle(
                color: Colors.red,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
      Divider(
        height: 0,
        color: outlineColor,
      ),
      SizedBox(
        height: 300,
      ),
    ];
  }

  void signoutAccount() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 10,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(dialogRadius),
          ),
          backgroundColor: dialogColor1,
          title: Center(
            child: Text(
              '로그아웃',
              style: title1,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('로그아웃 하시겠습니까?'),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: FlatButton(
                      color: dialogColor3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(widgetRadius),
                      ),
                      child: Text(
                        '로그아웃',
                        style: TextStyle(
                          color: dialogColor4,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed: () async {
                        if (widget.userDB.id.contains('kakao')) {
                          await kakaoSignOut(context);
                          await FirebaseAuth.instance.signOut();
                        } else {
                          signOutGoogle(context);
                          await FirebaseAuth.instance.signOut();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          '프로필 수정',
          style: headline2,
        ),
        centerTitle: false,
        automaticallyImplyLeading: false,
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
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: widget.userDB.isArtist
                      ? _buildUnionProfile()
                      : _buildUserProfile(),
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
                onPressed: _canGo
                    ? () async {
                        if (_nameEditingController.text != '') {
                          Map<String, dynamic> _userUploadResult = {
                            'name': _nameEditingController.text.trim(),
                            'profile': _profileImageURL,
                            'resizedProfile': _resizedProfileURL,
                          };

                          if (widget.userDB.isArtist) {
                            if (_soundcloudEditingController.text != '' ||
                                _youtubeEditingController.text != '' ||
                                _instagramEditingController.text != '') {
                              bool check1 = false;
                              bool check2 = false;
                              bool check3 = false;
                              if (_soundcloudEditingController.text != '') {
                                if (_soundcloudEditingController.text
                                    .contains('soundcloud.com')) {
                                  if (_soundcloudEditingController.text
                                      .startsWith('https://')) {
                                    _userUploadResult['soundcloud_link'] =
                                        _soundcloudEditingController.text
                                            .trim();
                                  } else {
                                    _userUploadResult['soundcloud_link'] =
                                        'https://' +
                                            _soundcloudEditingController.text
                                                .trim();
                                  }
                                  check1 = true;
                                } else {
                                  Widget toast = Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24.0,
                                      vertical: 12.0,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25.0),
                                      color: dialogColor1,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.warning),
                                        SizedBox(
                                          width: 12.0,
                                        ),
                                        Text(
                                          "사운드클라우드 링크를 정확하게 입력하세요.",
                                          style: caption2,
                                        ),
                                      ],
                                    ),
                                  );

                                  fToast.showToast(
                                    child: toast,
                                    gravity: ToastGravity.CENTER,
                                    toastDuration: Duration(seconds: 2),
                                  );
                                }
                              }

                              if (_youtubeEditingController.text != '') {
                                if (_youtubeEditingController.text
                                    .contains('youtube.com')) {
                                  _userUploadResult['youtube_link'] =
                                      _youtubeEditingController.text.trim();

                                  check2 = true;
                                } else {
                                  Widget toast = Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24.0,
                                      vertical: 12.0,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25.0),
                                      color: dialogColor1,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.warning),
                                        SizedBox(
                                          width: 12.0,
                                        ),
                                        Text(
                                          "유튜브 링크를 정확하게 입력하세요.",
                                          style: caption2,
                                        ),
                                      ],
                                    ),
                                  );

                                  fToast.showToast(
                                    child: toast,
                                    gravity: ToastGravity.CENTER,
                                    toastDuration: Duration(seconds: 2),
                                  );
                                }
                              }

                              if (_instagramEditingController.text != '') {
                                _userUploadResult['instagram_id'] =
                                    _instagramEditingController.text
                                        .trim()
                                        .replaceAll('@', '');
                                check3 = true;
                              }

                              if (check1 || check2 || check3) {
                                setState(() {
                                  _canGo = false;
                                  _isLoading = true;
                                });
                                await FirebaseFirestore.instance
                                    .collection('Users')
                                    .doc(widget.userDB.id)
                                    .update(_userUploadResult);
                                Navigator.of(context).pop();
                              }
                            } else {
                              Widget toast = Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24.0,
                                  vertical: 12.0,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25.0),
                                  color: dialogColor1,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.warning),
                                    SizedBox(
                                      width: 12.0,
                                    ),
                                    Text(
                                      "SNS를 적어도 하나 입력하세요.",
                                      style: caption2,
                                    ),
                                  ],
                                ),
                              );

                              fToast.showToast(
                                child: toast,
                                gravity: ToastGravity.CENTER,
                                toastDuration: Duration(seconds: 2),
                              );
                            }
                          } else {
                            setState(() {
                              _canGo = false;
                              _isLoading = true;
                            });
                            await FirebaseFirestore.instance
                                .collection('Users')
                                .doc(widget.userDB.id)
                                .update(_userUploadResult);
                            Navigator.of(context).pop();
                          }
                        } else {
                          Widget toast = Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24.0,
                              vertical: 12.0,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.0),
                              color: dialogColor1,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.warning),
                                SizedBox(
                                  width: 12.0,
                                ),
                                Text(
                                  "이름이 누락되었습니다.",
                                  style: caption2,
                                ),
                              ],
                            ),
                          );

                          fToast.showToast(
                            child: toast,
                            gravity: ToastGravity.CENTER,
                            toastDuration: Duration(seconds: 2),
                          );
                        }
                      }
                    : null,
                child: _isLoading
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : Text(
                        '저장',
                        style: subtitle1,
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _uploadImageToStorage(ImageSource source) async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile pickedImage = await imagePicker.getImage(source: source);

    if (pickedImage == null) {
      setState(() {
        // _profileImageURL = _user.photoURL;
        _canGo = true;
      });
    } else {
      img.Image imageTmp =
          img.decodeImage(File(pickedImage.path).readAsBytesSync());
      img.Image resizedImg = img.copyResize(
        imageTmp,
        height: 1000,
      );

      File resizedFile = File(pickedImage.path)
        ..writeAsBytesSync(img.encodeJpg(resizedImg));
      setState(() {
        _image = resizedFile;
      });

      // 프로필 사진을 업로드할 경로와 파일명을 정의. 사용자의 uid를 이용하여 파일명의 중복 가능성 제거
      Reference storageReference =
          _firebaseStorage.ref().child("profile/${widget.userDB.id}");

      // 파일 업로드
      // 파일 업로드 완료까지 대기
      await storageReference.putFile(_image);

      // 업로드한 사진의 URL 획득
      String downloadURL = await storageReference.getDownloadURL();
      String resizedURL = '';
      try {
        resizedURL = await FirebaseStorage.instance
            .ref('/profile/${widget.userDB.id}_1080x1080')
            .getDownloadURL();
      } catch (e) {
        print(e);
      }

      // 업로드된 사진의 URL을 페이지에 반영
      setState(() {
        _resizedProfileURL = resizedURL;
        _profileImageURL = downloadURL;
        _canGo = true;
      });
    }
  }
}
