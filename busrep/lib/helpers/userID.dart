import 'package:busrep/models/response.dart';
import 'package:busrep/repositories/sharedPreferences.dart';
import 'package:uuid/uuid.dart';

import 'api.dart';

var uuid = Uuid();

String generateUserID(ResponseUserIDList userIDList) {
  String userID;
  do {
    userID = uuid.v4();
  } while (userIDList.userIDList.contains(userID));
  return userID;
}

Future<String> createUserID() async {
  final ResponseUserIDList responseUserIDList = await requestUserIDList();
  final String userID = generateUserID(responseUserIDList);
  saveUserID(userID);
  return userID;
}
