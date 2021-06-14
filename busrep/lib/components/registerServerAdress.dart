import 'package:busrep/components/registerUser.dart';
import 'package:flutter/material.dart';
import 'package:busrep/repositories/sharedPreferences.dart';

class RegisterAddressPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("busrep"),
      ),
      body: AddressForm(),
    );
  }
}

class AddressForm extends StatefulWidget {
  @override
  _AddressForm createState() => _AddressForm();
}

class _AddressForm extends State<AddressForm> {
  final _formKey = GlobalKey<FormState>();

  String inputValid(value) {
    if (value == null || value.isEmpty) {
      return "入力してください";
    }
    return null;
  }

  void inputSaved(String value) {
    saveServerAddress(value);
  }

  @override
  Widget build(BuildContext context) {
    String address;
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: "アドレス"),
            autofocus: true,
            textAlign: TextAlign.center,
            onChanged: (addr) {
              print("条件の入力値 : $addr"); // Debug mode
              address = addr;
            },
            validator: (value) => inputValid(value),
            onSaved: (value) => inputSaved(value),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text("アドレスを登録しました")));
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MaterialApp(
                        debugShowCheckedModeBanner: false,
                        title: 'Whisper',
                        home: RegisterUserPage(),
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
