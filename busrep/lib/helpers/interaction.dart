import 'package:busrep/helpers/utils.dart';
import 'package:busrep/models/blockchain.dart';
import 'package:busrep/models/metaData.dart';
import 'package:busrep/helpers/api.dart';
import 'package:busrep/repositories/database.dart';

import 'metaData.dart';

void register(String username, String password) async {
  RegisterMetaData registerMetaData =
      await createRegisterMetaData(username, password);
  Blockchain responseRegister = await requestRegister(registerMetaData);
  saveBlockchain(responseRegister);
  checkRegistered(registerMetaData, responseRegister, password);
}
