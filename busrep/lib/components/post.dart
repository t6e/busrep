import 'package:busrep/helpers/interaction.dart';
import 'package:flutter/material.dart';

class PostPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("busrep"),
      ),
      body: PostForm(),
    );
  }
}

class PostForm extends StatefulWidget {
  @override
  _PostForm createState() => _PostForm();
}

class _PostForm extends State<PostForm> {
  final _formKey = GlobalKey<FormState>();

  String inputValid(value) {
    if (value == null || value.isEmpty) {
      return "入力してください";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    String content;
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
                labelText: "投稿内容", hintText: "busrepのレビューを行った。"),
            autofocus: true,
            textAlign: TextAlign.left,
            onChanged: (text) {
              print("条件の入力値 : $text"); // Debug mode
              content = text;
            },
            validator: (value) => inputValid(value),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text("投稿しました")));
                  Navigator.pop(context);
                  post(content);
                }
              },
              child: Text("投稿する"),
            ),
          )
        ],
      ),
    );
  }
}
