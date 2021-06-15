import 'package:busrep/models/data.dart';

class ResponseView {
  final List<User> user;
  final List<Post> post;

  ResponseView({this.user, this.post});

  factory ResponseView.fromJson(Map<String, dynamic> json) {
    List<User> userList = [];
    json["user"].forEach((jsonUser) {
      User user = User.fromJson(jsonUser);
      userList.add(user);
    });
    List<Post> postList = [];
    json["post"].forEach((jsonPost) {
      Post post = Post.fromJson(jsonPost);
      postList.add(post);
    });
    return ResponseView(user: userList, post: postList);
  }
}

class ResponseUserIDList {
  final List<String> userIDList;

  ResponseUserIDList({this.userIDList});

  factory ResponseUserIDList.fromJson(Map<String, dynamic> json) {
    return ResponseUserIDList(
        userIDList: json["user_id_list"].cast<String>() as List<String>);
  }
}
