import 'package:busrep/models/blockchain.dart';
import 'package:busrep/models/data.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final Future<Database> database = getDatabasesPath().then((path) {
  return openDatabase(
    join(path, 'busrep.db'),
    onCreate: (db, version) {
      db.execute(
        "CREATE TABLE user(id INTEGER PRIMARY KEY,user_id TEXT,username TEXT,public_key TEXT)",
      );
      db.execute(
        "CREATE TABLE blockchain(block_id INTEGER PRIMARY KEY,action TEXT,action_id INTEGER,digital_signature TEXT,created TEXT,previous_hash TEXT,user_id TEXT)",
      );
      return db.execute(
        "CREATE TABLE my_post(post_id INTEGER PRIMARY KEY,content TEXT,public_key TEXT,next_public_key TEXT)",
      );
    },
    version: 1,
  );
});

void saveBlockchain(Blockchain bc) async {
  final Database db = await database;
  List<Block> blockchain = bc.blockchain;
  if (blockchain.length == 0) {
    return;
  }
  blockchain.forEach((block) {
    db.insert(
      'blockchain',
      block.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  });
}

void saveMyPost(Post post) async {
  final Database db = await database;
  db.insert(
    'my_post',
    post.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<Block> getLastBlock() async {
  final Database db = await database;
  return Block.fromMap(
      (await db.query("blockchain", orderBy: "block_id desc", limit: 1))[0]);
}
