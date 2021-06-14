import 'package:busrep/components/post.dart';
import 'package:flutter/material.dart';

class ViewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("busrep"),
      ),
      body: Center(
        child: Text("閲覧"),
      ),
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
