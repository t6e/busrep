import 'dart:convert';

import 'package:busrep/helpers/crypto.dart';
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userID,
      'username': username,
      "public_key": jsonEncode(nextPublicKey.bytes)
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      userID: json["user_id"],
      username: json["username"],
      publicKey: deserializePublicKeyED25519(json["public_key"]),
      nextPublicKey: deserializePublicKeyED25519(json["next_public_key"]),
    );
  }
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

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      postID: json["post_id"],
      content: json["content"],
      publicKey: deserializePublicKeyED25519(json["public_key"]),
      nextPublicKey: deserializePublicKeyED25519(json["next_public_key"]),
    );
  }
}

class PostData {
  final String content;
  final String username;
  final String userID;
  final String created;

  PostData({this.content, this.username, this.userID, this.created});
}

class IdentityTable {
  Map<String, String> identityTable;

  IdentityTable({this.identityTable});
}
