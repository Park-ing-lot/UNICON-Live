import 'package:cloud_firestore/cloud_firestore.dart';

class UserDB {
  final String name;
  final String email;
  final String instagramId;
  final String youtubeLink;
  final String soudcloudLink;
  final String profile;
  final String resizedProfile;
  final String id;
  final String liveTitle;
  final String liveImage;
  final String resizedLiveImage;
  String token;
  int points;
  final bool isArtist;
  final List<dynamic> follow;
  final Timestamp birth;
  final List<dynamic> preferredGenre;
  final List<dynamic> preferredMood;
  final List<dynamic> genre;
  final List<dynamic> mood;
  final List<dynamic> dislikePeople;
  final List<dynamic> dislikeFeed;
  final List<dynamic> dislikeComment;
  final List<dynamic> dislikeChat;
  int fee;
  final bool admin;
  final Timestamp createTime;
  final DocumentReference reference;

  final List<dynamic> liked_video;

  UserDB.fromMap(Map<String, dynamic> map, {this.reference})
      : name = map['name'],
        email = map['email'],
        instagramId = map['instagram_id'],
        youtubeLink = map['youtube_link'],
        soudcloudLink = map['soundcloud_link'],
        profile = map['profile'],
        resizedProfile = map['resizedProfile'],
        id = map['id'],
        token = map['token'],
        points = map['points'],
        isArtist = map['is_artist'],
        follow = map['follow'],
        birth = map['birth'],
        preferredGenre = map['preferred_genre'],
        preferredMood = map['preferred_mood'],
        genre = map['genre'],
        mood = map['mood'],
        fee = map['fee'],
        dislikePeople = map['dislikePeople'],
        dislikeFeed = map['dislikeFeed'],
        dislikeComment = map['dislikeComment'],
        dislikeChat = map['dislikeChat'],
        createTime = map['createTime'],
        admin = map['admin'],
        liveTitle = map['liveTitle'],
        liveImage = map['liveImage'],
        resizedLiveImage = map['resizedLiveImage'],
        liked_video = map['liked_video'];
  UserDB.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  @override
  String toString() => '';
}
