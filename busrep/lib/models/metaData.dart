import 'dart:convert';

import 'package:busrep/models/data.dart';
import 'package:busrep/models/crypto.dart';

class RegisterMetaData {
  final String userID;
  final String username;
  final ChainedKeys chainedKeys;
  final List<int> digitalSignature;

  RegisterMetaData(
      {this.userID, this.username, this.chainedKeys, this.digitalSignature});

  Future<Map<String, dynamic>> toJson4Register() async {
    return {
      "user_id": userID,
      "username": username,
      "public_key":
          jsonEncode((await chainedKeys.keyPair.extractPublicKey()).bytes),
      "next_public_key":
          jsonEncode((await chainedKeys.nextKeyPair.extractPublicKey()).bytes),
      "digital_signature": jsonEncode(digitalSignature)
    };
  }

  Future<Post> myPost(int postID) async {
    return Post(
        postID: postID,
        content: userID + ":::" + username,
        publicKey: await chainedKeys.keyPair.extractPublicKey(),
        nextPublicKey: await chainedKeys.nextKeyPair.extractPublicKey());
  }
}

class PostMetaData {
  final String userID;
  final String username;
  final ChainedKeys chainedKeys;
  final List<int> digitalSignature;
  final int maxBlockID;

  PostMetaData(
      {this.userID,
      this.username,
      this.chainedKeys,
      this.digitalSignature,
      this.maxBlockID});
}
