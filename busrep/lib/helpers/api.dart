import 'package:busrep/models/blockchain.dart';
import 'package:busrep/models/metaData.dart';
import 'package:busrep/models/response.dart';
import 'package:busrep/repositories/sharedPreferences.dart';

import 'package:http/http.dart' as http;

import 'dart:convert';

final url = loadServerAddress();

Future<ResponseUserIDList> requestUserIDList() async {
  final response = await http.get(
    Uri.http(await url, "/user_id_list"),
  );
  if (response.statusCode == 200) {
    final responseUserIDList =
        ResponseUserIDList.fromJson(jsonDecode(response.body));
    return responseUserIDList;
  } else {
    throw Exception('Failed to load userIDList');
  }
}

Future<Blockchain> requestRegister(RegisterMetaData registerMetaData) async {
  final response = await http.post(
    Uri.http(await url, "/register"),
    body: jsonEncode(await registerMetaData.toJson4Register()),
    headers: {"Content-Type": "application/json"},
  );
  if (response.statusCode == 200) {
    final Blockchain blockchain =
        Blockchain.fromJson(jsonDecode(response.body));
    return blockchain;
  } else {
    throw Exception('Failed to request register');
  }
}

Future<Blockchain> requestPost(PostMetaData postMetaData) async {
  final response = await http.post(
    Uri.http(await url, "/post"),
    body: jsonEncode(await postMetaData.toJson4Post()),
    headers: {"Content-Type": "application/json"},
  );
  if (response.statusCode == 200) {
    final Blockchain blockchain =
        Blockchain.fromJson(jsonDecode(response.body));
    return blockchain;
  } else {
    throw Exception('Failed to request register');
  }
}
