import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/load_user_db.dart';
import 'package:testing_layout/screen/LoginPage/screen/artist_format/screen_artist_format.dart';
import 'package:testing_layout/screen/LoginPage/screen/screen_initial_genre_selection.dart';
import 'package:testing_layout/screen/LoginPage/screen/screen_policy/screen_show-text-file.dart';

class PolicyCheckDialog extends StatefulWidget {
  final bool isArtist;
  PolicyCheckDialog({this.isArtist});
  @override
  _PolicyCheckDialogState createState() => _PolicyCheckDialogState();
}

class _PolicyCheckDialogState extends State<PolicyCheckDialog> {
  FToast fToast;
  bool check1 = false;
  bool check2 = false;
  bool check3 = false;
  bool check4 = false;
  // ignore: non_constant_identifier_names
  bool check_eula = false;
  // ignore: non_constant_identifier_names
  bool check_total = false;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
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
          '약관 동의',
          style: title1,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Checkbox(
                  value: check_total,
                  onChanged: (value) {
                    setState(() {
                      if (TargetPlatform.iOS == Theme.of(context).platform) {
                        check_eula = value;
                      }
                      check1 = value;
                      check2 = value;
                      check3 = value;
                      check4 = value;
                      check_total = value;
                    });
                  },
                ),
                Expanded(
                    child: Text(
                  '전체 동의',
                  style: subtitle2,
                )),
              ],
            ),
            Divider(
              height: 20,
              color: dialogColor3,
              thickness: 2,
            ),
            TargetPlatform.iOS == Theme.of(context).platform
                ? Row(
                    children: [
                      Checkbox(
                          value: check_eula,
                          onChanged: (value) {
                            setState(() {
                              check_eula = value;
                            });
                          }),
                      Expanded(
                          child: Text(
                        'Apple의 표준 사용권 계약',
                        style: subtitle2,
                      )),
                      InkWell(
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ShowTextFileScreen(
                                filename: 'eula.txt',
                                title: 'Apple의 표준 사용권 계약',
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  )
                : SizedBox(),
            Row(
              children: [
                Checkbox(
                    value: check1,
                    onChanged: (value) {
                      setState(() {
                        check1 = value;
                      });
                    }),
                Expanded(
                    child: Text(
                  '서비스 이용약관',
                  style: subtitle2,
                )),
                InkWell(
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ShowTextFileScreen(
                          filename: 'terms-and-conditions.txt',
                          title: '서비스 이용약관',
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: check2,
                  onChanged: (value) {
                    setState(() {
                      check2 = value;
                    });
                  },
                ),
                Expanded(
                    child: Text(
                  '개인정보 처리방침',
                  style: subtitle2,
                )),
                InkWell(
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ShowTextFileScreen(
                          filename: 'privacy-policy.txt',
                          title: '개인정보 처리방침',
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: check3,
                  onChanged: (value) {
                    setState(() {
                      check3 = value;
                    });
                  },
                ),
                Expanded(
                    child: Text(
                  '커뮤니티 가이드라인',
                  style: subtitle2,
                )),
                InkWell(
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ShowTextFileScreen(
                          filename: 'community-guideline.txt',
                          title: '커뮤니티 가이드라인',
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: check4,
                  onChanged: (value) {
                    setState(() {
                      check4 = value;
                    });
                  },
                ),
                Expanded(
                    child: Text(
                  '법적고지',
                  style: subtitle2,
                )),
                InkWell(
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ShowTextFileScreen(
                          filename: 'legal-notice.txt',
                          title: '법적고지',
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: FlatButton(
                    color: appKeyColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(widgetRadius),
                    ),
                    onPressed: () {
                      if (check1 && check2 && check3 && check4) {
                        widget.isArtist
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ArtistForm()))
                            : Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        InitialGenreSelection()));
                        LoadUser().onCreate();
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
                                "약관에 모두 동의하셔야 진행할 수 있습니다.",
                                textAlign: TextAlign.center,
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
                    },
                    child: Text(
                      '계속',
                      style: subtitle2,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
