import 'package:flutter/material.dart';

import 'package:busrep/repositories/sharedPreferences.dart';
import 'package:busrep/common/footer.dart';
import 'package:busrep/components/registerServerAdress.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Whisper',
      home: FutureBuilder(
          future: loadServerAddress(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data == "None") {
                return RegisterAddressPage();
              } else {
                return Footer();
              }
            } else {
              return Footer();
            }
          }),
    );
  }
}
