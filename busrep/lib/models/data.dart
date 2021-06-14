import 'dart:convert';

import 'package:cryptography/cryptography.dart';

class User {
  final int id;
  final String userID;
  final String username;
  final SimplePublicKey publicKey;
  final SimplePublicKey nextPublicKey;

  User(
      {this.id,
      this.userID,
      this.username,
      this.publicKey,
      this.nextPublicKey});
}

class Post {
  final int postID;
  final String content;
  final SimplePublicKey publicKey;
  final SimplePublicKey nextPublicKey;

  Post({this.postID, this.content, this.publicKey, this.nextPublicKey});

  Map<String, dynamic> toMap() {
    return {
      'post_id': postID,
      'content': content,
      "public_key": jsonEncode(publicKey.bytes),
      "next_public_key": jsonEncode(nextPublicKey.bytes)
    };
  }
}

class PostData {
  final String content;
  final String username;
  final String userID;
  final SimplePublicKey publicKey;
  final SimplePublicKey nextPublicKey;

  PostData(
      {this.content,
      this.username,
      this.userID,
      this.publicKey,
      this.nextPublicKey});
}
