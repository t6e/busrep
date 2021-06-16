import 'dart:convert';

import 'package:busrep/helpers/crypto.dart';
import 'package:busrep/models/blockchain.dart';
import 'package:busrep/models/data.dart';
import 'package:busrep/models/metaData.dart';
import 'package:busrep/repositories/database.dart';
import 'package:busrep/repositories/sharedPreferences.dart';
import 'package:flutter/foundation.dart';

import 'interaction.dart';

void checkRegistered(RegisterMetaData registerMetaData,
    Blockchain responseRegister, String password) async {
  final int postID = isRegistered(registerMetaData, responseRegister);
  if (postID != -1) {
    Post myPost = await registerMetaData.myPost(postID);
    saveMyPost(myPost);
    savePrivateKey(await registerMetaData.chainedKeys.nextKeyPair
        .extractPrivateKeyBytes());
  } else {
    register(registerMetaData.username, password);
  }
}

int isRegistered(
    RegisterMetaData registerMetaData, Blockchain responseRegister) {
  List<int> digitalSignature = registerMetaData.digitalSignature;
  for (var block in responseRegister.blockchain.reversed) {
    if (listEquals(digitalSignature, block.digitalSignature)) {
      return block.actionID;
    }
  }
  return -1;
}

void checkPosted(PostMetaData postMetaData, Blockchain responsePost) async {
  final int postID = isPosted(postMetaData, responsePost);
  if (postID == -1) {
    Post myPost = await postMetaData.myPost(postID);
    saveMyPost(myPost);
    savePrivateKey(
        await postMetaData.chainedKeys.nextKeyPair.extractPrivateKeyBytes());
  }
}

int isPosted(PostMetaData postMetaData, Blockchain responsePost) {
  List<int> digitalSignature = postMetaData.digitalSignature;
  for (var block in responsePost.blockchain.reversed) {
    if (listEquals(digitalSignature, block.digitalSignature)) {
      return block.actionID;
    }
  }
  return -1;
}

Future<List<PostData>> associateUserIDWithPostBlockchain(
    List<Post> postList) async {
  Blockchain postBlockchain = await getPostBlockchain();
  Map<String, String> identityTable = (await getIdentityTable()).identityTable;
  List<PostData> postDataList = [];
  for (var block in postBlockchain.blockchain) {
    Post matchPost = postList.singleWhere(
        (post) => post.postID == block.actionID,
        orElse: () => null);
    if (block.userID != "None") {
      if (await verifyPostBlock(block, matchPost)) {
        postDataList.add(PostData(
            content: matchPost.content,
            username: await getUsernameByUserID(block.userID),
            userID: block.userID,
            created: block.created));
      }
    } else {
      String publicKey = jsonEncode(matchPost.publicKey.bytes);
      String userID = identityTable.keys.firstWhere(
          (userID) => identityTable[userID] == publicKey,
          orElse: () => null);
      if (userID != null) {
        String nextPublicKey = jsonEncode(matchPost.nextPublicKey.bytes);
        identityTable[userID] = nextPublicKey;
        associateUserIDWithBlock(block, userID);
        block.userID = userID;
      } else {
        throw Exception('Failed to update UserID');
      }

      if (await verifyPostBlock(block, matchPost)) {
        postDataList.add(PostData(
            content: matchPost.content,
            username: await getUsernameByUserID(block.userID),
            userID: block.userID,
            created: block.created));
      }
    }
  }
  return postDataList;
}
