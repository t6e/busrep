import 'package:flutter/material.dart';
import 'package:busrep/common/footer.dart';
import 'package:busrep/helpers/interaction.dart';

class RegisterUserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("busrep"),
      ),
      body: UserForm(),
    );
  }
}

class UserForm extends StatefulWidget {
  @override
  _AddressForm createState() => _AddressForm();
}

class _AddressForm extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();

  String inputValid(value) {
    if (value == null || value.isEmpty) {
      return "入力してください";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    String username;
    String password;
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: "Username"),
            autofocus: true,
            textAlign: TextAlign.center,
            onChanged: (un) {
              print("条件の入力値 : $un"); // Debug mode
              username = un;
            },
            validator: (value) => inputValid(value),
          ),
          TextFormField(
            decoration: InputDecoration(labelText: "Password"),
            autofocus: true,
            textAlign: TextAlign.center,
            onChanged: (pw) {
              print("条件の入力値 : $pw"); // Debug mode
              password = pw;
            },
            validator: (value) => inputValid(value),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  register(username, password);
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text("登録しました")));
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MaterialApp(
                        debugShowCheckedModeBanner: false,
                        title: 'Whisper',
                        home: Footer(),
                      ),
                    ),
                  );
                }
              },
              child: Text("OK"),
            ),
          )
        ],
      ),
    );
  }
}
