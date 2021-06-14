import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferences = SharedPreferences.getInstance();

void saveServerAddress(String address) async {
  SharedPreferences prefs = await sharedPreferences;
  await prefs.setString('serverAddress', address);
}

Future<String> loadServerAddress() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final address = prefs.get("serverAddress") ?? "None";
  return address;
}

void saveUserID(String userID) async {
  SharedPreferences prefs = await sharedPreferences;
  await prefs.setString('userID', userID);
}

Future<String> loadUserID() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final userID = prefs.get("userID") ?? "None";
  return userID;
}

void savePrivateKey(List<int> privateKey) async {
  SharedPreferences prefs = await sharedPreferences;
  await prefs.setString('privateKey', jsonEncode(privateKey));
}

Future<List<int>> loadPrivateKey() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final privateKey = prefs.get("privateKey") ?? "None";
  if (privateKey != "None") {
    return jsonDecode(privateKey);
  } else {
    return [];
  }
}
