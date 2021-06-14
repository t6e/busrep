import 'package:busrep/models/crypto.dart';
import 'package:busrep/models/metaData.dart';
import 'package:busrep/repositories/sharedPreferences.dart';
import 'package:cryptography/cryptography.dart';

import 'crypto.dart';

Future<RegisterMetaData> createRegisterMetaData(
    String username, String password) async {
  ChainedKeys chainedKeys = await createChainedKeys(password);
  String userID = await loadUserID();
  List<int> digitalSignature =
      await createDigitalSignature(chainedKeys, username, userID);
  return RegisterMetaData(
      userID: userID,
      username: username,
      chainedKeys: chainedKeys,
      digitalSignature: digitalSignature);
}
