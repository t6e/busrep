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
