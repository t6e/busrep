import 'package:busrep/helpers/blockchain.dart';
import 'package:busrep/models/crypto.dart';
import 'package:busrep/models/metaData.dart';
import 'package:busrep/repositories/sharedPreferences.dart';

import 'crypto.dart';

Future<RegisterMetaData> createRegisterMetaData(
    String username, String password) async {
  ChainedKeys chainedKeys = await createFirstChainedKeys(password);
  String userID = await loadUserID();
  List<int> digitalSignature =
      await createDigitalSignature(chainedKeys, username, userID);
  return RegisterMetaData(
      userID: userID,
      username: username,
      chainedKeys: chainedKeys,
      digitalSignature: digitalSignature);
}

Future<PostMetaData> createPostMetaData(String content) async {
  final ChainedKeys chainedKeys = await createChainedKeys();
  final String userID = await loadUserID();
  final int maxBlockID = await loadMaxBlockID();
  final List<int> digitalSignature =
      await createDigitalSignature(chainedKeys, content, userID);
  return PostMetaData(
      userID: userID,
      content: content,
      chainedKeys: chainedKeys,
      digitalSignature: digitalSignature,
      maxBlockID: maxBlockID);
}
