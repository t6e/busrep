import 'package:busrep/models/data.dart';

class ResponseView {
  final List<User> user;
  final List<Post> post;

  ResponseView({this.user, this.post});
}

class ResponseUserIDList {
  final List<String> userIDList;

  ResponseUserIDList({this.userIDList});

  factory ResponseUserIDList.fromJson(Map<String, dynamic> json) {
    return ResponseUserIDList(
        userIDList: json["user_id_list"].cast<String>() as List<String>);
  }
}
