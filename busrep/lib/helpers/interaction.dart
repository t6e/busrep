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

  verifyRegisterBlockchain(responseView.user, unknownRegisterBlockchain);
  List<PostData> postDataList =
      await associateUserIDWithPostBlockchain(responseView.post);
  return postDataList;
}
