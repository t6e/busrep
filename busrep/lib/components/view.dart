import 'dart:convert';

import 'package:busrep/components/post.dart';
import 'package:busrep/helpers/interaction.dart';
import 'package:busrep/models/data.dart';
import 'package:flutter/material.dart';

class ViewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("busrep"),
      ),
      body: FutureBuilder(
          future: view(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return ListView.separated(
                padding: const EdgeInsets.all(8),
                itemCount: 1,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 50,
                    color: Color.fromRGBO(255, 111, 255, 1),
                    child: Center(child: Text('Entry None')),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
              );
            }

            List<PostData> postData = snapshot.data;
            final List<PostData> entries = new List.from(postData.reversed);
            return ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: entries.length,
              itemBuilder: (BuildContext context, int index) {
                String userID = entries[index].userID;
                int n = userID.length ~/ 3;
                int r = utf8
                        .encode(userID.substring(0, n))
                        .reduce((value, element) => value + element) %
                    255;
                int g = utf8
                        .encode(userID.substring(n, n * 2))
                        .reduce((value, element) => value + element) %
                    255;
                int b = utf8
                        .encode(userID.substring(n * 2, n * 3))
                        .reduce((value, element) => value + element) %
                    255;
                return Container(
                  height: 50,
                  color: Color.fromRGBO(r, g, b, 1),
                  child: Center(
                      child: Text(
                          "${entries[index].userID} : ${entries[index].username} > ${entries[index].content} (${entries[index].created})")),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PostPage()),
        ),
        child: Icon(Icons.add),
      ),
    );
  }
}

// class Home extends StatelessWidget {
// final List<int> colorCodes = <int>[
//   600,
//   500,
// ];
//
// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: StandardHeader(),
//     body: FutureBuilder(
//         future: view(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return ListView.separated(
//               padding: const EdgeInsets.all(8),
//               itemCount: 1,
//               itemBuilder: (BuildContext context, int index) {
//                 return Container(
//                   height: 50,
//                   color: Colors.amber[colorCodes[index % colorCodes.length]],
//                   child: Center(child: Text('Entry None')),
//                 );
//               },
//               separatorBuilder: (BuildContext context, int index) =>
//               const Divider(),
//             );
//           }
//           final List<Post> entries = snapshot.data;
//           return ListView.separated(
//             padding: const EdgeInsets.all(8),
//             itemCount: entries.length,
//             itemBuilder: (BuildContext context, int index) {
//               return Container(
//                 height: 50,
//                 color: Colors.amber[colorCodes[index % colorCodes.length]],
//                 child: Center(child: Text('Entry ${entries[index].content}')),
//               );
//             },
//             separatorBuilder: (BuildContext context, int index) =>
//             const Divider(),
//           );
//         }),
//     floatingActionButton: FloatingActionButton(
//       onPressed: () => Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => PostPage()),
//       ),
//       child: Icon(Icons.add),
//     ),
//   );
// }
// }
