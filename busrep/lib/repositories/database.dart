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

void saveUser(User user) async {
  final Database db = await database;
  db.insert(
    'user',
    user.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

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

Future<Blockchain> getUnknownRegisterBlockchain() async {
  final Database db = await database;
  final blockList = await db.query("blockchain",
      orderBy: "block_id asc",
      where: "action=? AND user_id=?",
      whereArgs: ["Register", "None"]);
  return Blockchain.fromMap(blockList);
}

void associateUserIDWithBlock(Block block, String userID) async {
  final Database db = await database;
  Map<String, dynamic> blockMap = block.toMap();
  blockMap["user_id"] = userID;
  await db.update(
    'blockchain',
    blockMap,
    where: "block_id = ?",
    whereArgs: [block.blockID],
    conflictAlgorithm: ConflictAlgorithm.fail,
  );
}

Future<String> getUsernameByUserID(String userID) async {
  final Database db = await database;
  final username = (await db.query("user",
      columns: ["username"],
      where: "user_id=?",
      whereArgs: [userID],
      limit: 1))[0]["username"];
  return username;
}

Future<Blockchain> getPostBlockchain() async {
  final Database db = await database;
  return Blockchain.fromMap(await db.query("blockchain",
      orderBy: "action_id asc", where: "action=?", whereArgs: ["Post"]));
}

Future<IdentityTable> getIdentityTable() async {
  final Database db = await database;
  final results = await db.query("user", columns: ["user_id", "public_key"]);
  Map<String, String> identityTable = {};
  results.forEach((result) {
    identityTable[result["user_id"]] = result["public_key"];
  });
  return IdentityTable(identityTable: identityTable);
}
