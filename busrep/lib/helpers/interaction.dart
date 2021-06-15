import 'dart:convert';

import 'package:busrep/helpers/crypto.dart';
import 'package:busrep/helpers/utils.dart';
import 'package:busrep/models/blockchain.dart';
import 'package:busrep/models/data.dart';
import 'package:busrep/models/metaData.dart';
import 'package:busrep/helpers/api.dart';
import 'package:busrep/models/response.dart';
import 'package:busrep/repositories/database.dart';

import 'package:busrep/helpers/blockchain.dart';
import 'package:busrep/helpers/metaData.dart';

void register(String username, String password) async {
  RegisterMetaData registerMetaData =
      await createRegisterMetaData(username, password);
  Blockchain responseRegister = await requestRegister(registerMetaData);
  saveBlockchain(responseRegister);
  checkRegistered(registerMetaData, responseRegister, password);
}

void post(String content) async {
  PostMetaData postMetaData = await createPostMetaData(content);
  Blockchain responsePost = await requestPost(postMetaData);
  blockchained(responsePost);
  checkPosted(postMetaData, responsePost);
}

Future<List<PostData>> view() async {
  Blockchain responseBlockchain = await requestBlockchain();
  blockchained(responseBlockchain);
  Blockchain unknownRegisterBlockchain = await getUnknownRegisterBlockchain();
  ResponseView responseView = await requestView(unknownRegisterBlockchain);

  // responseView.user.forEach((user) {
  //   print("~~~~~~~~~~~~~~~~~~~");
  //   print("ID : ${user.id}");
  //   print("Username : ${user.username}");
  // });
  verifyRegisterBlockchain(responseView.user, unknownRegisterBlockchain);
  print("1");
  List<PostData> postDataList =
      await associateUserIDWithPostBlockchain(responseView.post);
  print("2");
  print("PostDataList Length : ${postDataList.length}");
  return postDataList;
}

Future<List<PostData>> associateUserIDWithPostBlockchain(
    List<Post> postList) async {
  print("PostList Length : ${postList.length}");
  print("called getPostBlockchain()");
  Blockchain postBlockchain = await getPostBlockchain();
  Map<String, String> identityTable = (await getIdentityTable()).identityTable;
  List<PostData> postDataList = [];
  int c = 0;
  for (var block in postBlockchain.blockchain) {
    print("count : $c");
    c++;
    Post matchPost = postList.singleWhere(
        (post) => post.postID == block.actionID,
        orElse: () => null);
    // print("a");
    print("block.userID : ${block.userID}");
    if (block.userID != "None") {
      if (await verifyPostBlock(block, matchPost)) {
        print("+++++");
        postDataList.add(PostData(
            content: matchPost.content,
            username: await getUsernameByUserID(block.userID),
            userID: block.userID,
            created: block.created));
      } else {
        print("*****");
      }
    } else {
      String publicKey = jsonEncode(matchPost.publicKey.bytes);
      String userID = identityTable.keys.firstWhere(
          (userID) => identityTable[userID] == publicKey,
          orElse: () => null);
      // print("b");
      if (userID != null) {
        // print("c");

        String nextPublicKey = jsonEncode(matchPost.nextPublicKey.bytes);
        identityTable[userID] = nextPublicKey;
        associateUserIDWithBlock(block, userID);
        block.userID = userID;
      } else {
        print("BAD!!!!!!!!!");

        throw Exception('Failed to update UserID');
      }

      if (await verifyPostBlock(block, matchPost)) {
        print("-----");

        postDataList.add(PostData(
            content: matchPost.content,
            username: await getUsernameByUserID(block.userID),
            userID: block.userID,
            created: block.created));
      } else {
        print("#####");
      }
    }
  }
  print("Last PostDataList Length : ${postDataList.length}");
  return postDataList;
}
