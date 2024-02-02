import 'package:firebase_auth/firebase_auth.dart';

class Message {
  User user;
  String? message;
  String isMe;
  String? imageUrl;

  Message(
      {required this.user, required this.isMe, this.imageUrl, this.message});
}
