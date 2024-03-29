import 'dart:io';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:testing_layout/screen/LoginPage/screen/artist_format/artist_login_page.dart';
import 'package:testing_layout/screen/LoginPage/widget/apple_sign_button.dart';
import 'package:testing_layout/screen/LoginPage/widget/google_sign_button.dart';
import 'package:testing_layout/screen/LoginPage/widget/kakao_sign_button.dart';

final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  ScrollController scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 200),
            padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
            decoration: BoxDecoration(
                border: Border.all(color: Color(0xffA3A3A3)),
                borderRadius: BorderRadius.circular(22)),
            child: Column(
              children: [
                Divider(
                  color: Colors.white,
                  height: 20,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Sign in with',
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: Platform.isIOS
                      ? [
                          AppleSignButton(
                            isArtist: false,
                          ),
                          GoogleSignButton(
                            isArtist: false,
                          ),
                          KakaoSignButton(
                            isArtist: false,
                          )
                        ]
                      : [
                          GoogleSignButton(
                            isArtist: false,
                          ),
                          KakaoSignButton(
                            isArtist: false,
                          )
                        ],
                ),
                SizedBox(
                  height: 45,
                ),
                Text(
                  '당신이 뮤지션이라면?',
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 10,
                ),
                FlatButton(
                  height: 55,
                  minWidth: 250,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11.0),
                  ),
                  color: Color(0xff3E3E3E),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ArtistLoginPage()));
                  },
                  child: Text(
                    '뮤지션 등록/신청',
                    style: TextStyle(
                        fontSize: 21,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void showAlertDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: new Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            new CircularProgressIndicator(
              backgroundColor: Colors.white,
            ),
          ],
        ),
      );
    },
  );
  new Future.delayed(new Duration(seconds: 10), () {});
}

Future<auth.UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  // Create a new credential
  final auth.GoogleAuthCredential credential =
      auth.GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  // Once signed in, return the UserCredential
  return await auth.FirebaseAuth.instance.signInWithCredential(credential);
}

void signOutGoogle(BuildContext context) async {
  await googleSignIn.signOut();
  // Call back when user sign out
  Navigator.of(context)
      .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
  print("User Sign Out");
}

Future<auth.UserCredential> kakaoSignIn() async {
  try {
    final String token = await _retrieveToken();

    final authResult =
        await _auth.signInWithCustomToken(await _verifyToken(token));

    final auth.User firebaseUser = authResult.user;
    final auth.User currentUser = auth.FirebaseAuth.instance.currentUser;

    assert(firebaseUser.uid == currentUser.uid);

    await _updateEmailInfo(firebaseUser);

    return authResult;
  } on KakaoAuthException catch (e) {
    return Future.error(e);
  } on KakaoClientException catch (e) {
    return Future.error(e);
  } catch (e) {
    if (e.toString().contains("already in use")) {
      return Future.error(PlatformException(
          code: "ERROR_EMAIL_ALREADY_IN_USE",
          message: "The email address is already in use by another account"));
    }
    return Future.error(e);
  }
}

Future<String> _retrieveToken() async {
  final installed = await isKakaoTalkInstalled();
  final authCode = installed
      ? await AuthCodeClient.instance.requestWithTalk()
      : await AuthCodeClient.instance.request();
  AccessTokenResponse token = await AuthApi.instance.issueAccessToken(authCode);

  await AccessTokenStore.instance.toStore(
      token); // Store access token in AccessTokenStore for future API requests.
  return token.accessToken;
}

Future<void> _updateEmailInfo(auth.User firebaseUser) async {
  // When sign in is done, update email info.
  User kakaoUser = await UserApi.instance.me();
  if (kakaoUser.kakaoAccount.email.isNotEmpty) {
    firebaseUser.updateEmail(kakaoUser.kakaoAccount.email);
  }
}

Future<String> _verifyToken(String kakaoToken) async {
  try {
    final HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('verifyKakaoToken');

    final HttpsCallableResult result = await callable.call(
      <String, dynamic>{
        'token': kakaoToken,
      },
    );

    if (result.data['error'] != null) {
      print(result.data['error']);
      return Future.error(result.data['error']);
    } else {
      return result.data['token'];
    }
  } catch (e) {
    return Future.error(e);
  }
}

Future<void> kakaoSignOut(BuildContext context) {
  AccessTokenStore.instance.clear();
  Navigator.of(context)
      .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
  print("User Sign Out");
  return Future.value("");
}

Future<auth.User> linkWith(auth.User user) async {
  try {
    final token = await _retrieveToken();

    final HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('linkWithKakao');

    final HttpsCallableResult result = await callable.call(
      <String, dynamic>{
        'token': token,
      },
    );

    if (result.data['error'] != null) {
      return Future.error(result.data['error']);
    } else {
      auth.User user = _auth.currentUser;

      // Update email info if possible.
      await _updateEmailInfo(user);

      return user;
    }
  } on KakaoAuthException catch (e) {
    return Future.error(e);
  } on KakaoClientException catch (e) {
    return Future.error(e);
  } catch (e) {
    return Future.error(e);
  }
}

/// Generates a cryptographically secure random nonce, to be included in a
/// credential request.
String generateNonce([int length = 32]) {
  final charset =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
  final random = Random.secure();
  return List.generate(length, (_) => charset[random.nextInt(charset.length)])
      .join();
}

/// Returns the sha256 hash of [input] in hex notation.
String sha256ofString(String input) {
  final bytes = utf8.encode(input);
  final digest = sha256.convert(bytes);
  return digest.toString();
}

Future<auth.UserCredential> signInWithApple() async {
  // To prevent replay attacks with the credential returned from Apple, we
  // include a nonce in the credential request. When signing in in with
  // Firebase, the nonce in the id token returned by Apple, is expected to
  // match the sha256 hash of `rawNonce`.
  final rawNonce = generateNonce();
  final nonce = sha256ofString(rawNonce);

  // Request credential for the currently signed in Apple account.
  final appleCredential = await SignInWithApple.getAppleIDCredential(
    scopes: [
      AppleIDAuthorizationScopes.email,
      AppleIDAuthorizationScopes.fullName,
    ],
    nonce: nonce,
  );

  // Create an `OAuthCredential` from the credential returned by Apple.
  final oauthCredential = auth.OAuthProvider("apple.com").credential(
    idToken: appleCredential.identityToken,
    rawNonce: rawNonce,
  );

  // Sign in the user with Firebase. If the nonce we generated earlier does
  // not match the nonce in `appleCredential.identityToken`, sign in will fail.
  return await auth.FirebaseAuth.instance.signInWithCredential(oauthCredential);
}
