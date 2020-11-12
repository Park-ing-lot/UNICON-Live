import 'package:flutter/material.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/components/uni_icon_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class SoundcloudLinkBox extends StatefulWidget {
  final String soundcloudUrl;

  const SoundcloudLinkBox({Key key, this.soundcloudUrl}) : super(key: key);
  @override
  _SoundcloudLinkBoxState createState() => _SoundcloudLinkBoxState();
}

class _SoundcloudLinkBoxState extends State<SoundcloudLinkBox> {
  _showMessage(BuildContext context) {
    var _alertDialog = AlertDialog(
      title: Text(
        '해당 유니온이 기입을 완료하지 않았습니다.',
        style: TextStyle(fontSize: textFontSize, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) => _alertDialog,
    );
  }

  _launchSoundcloud(BuildContext context, String url) async {
    if (url == null || url == '') {
      _showMessage(context);
      return;
    }
    if (await canLaunch(url)) {
      await launch(
        url,
        forceWebView: true,
        forceSafariVC: true,
        enableJavaScript: true,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      print('Error');
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        UniIcon.soundcloud,
        size: 35,
      ),
      onPressed: () {
        _launchSoundcloud(context, widget.soundcloudUrl);
      },
    );
  }
}
