import 'dart:convert';

import 'package:busrep/helpers/json.dart';

class Block {
  final int blockID;
  final String action;
  final int actionID;
  final List<int> digitalSignature;
  final String created;
  final String previousHash;
  String userID;

  Block(
      {this.blockID,
      this.action,
      this.actionID,
      this.digitalSignature,
      this.created,
      this.previousHash,
      this.userID});

  Map<String, dynamic> toMap() {
    return {
      'block_id': blockID,
      'action': action,
      'action_id': actionID,
      "digital_signature": jsonEncode(digitalSignature),
      "created": created,
      "previous_hash": previousHash,
      "user_id": "None"
    };
  }

  factory Block.fromJson(Map<String, dynamic> json) {
    return Block(
        blockID: json["block_id"],
        action: json["action"],
        actionID: json["action_id"],
        digitalSignature: jsonDecodeDigitalSignature(json["digital_signature"]),
        created: json["created"],
        previousHash: json["previous_hash"],
        userID: "None");
  }

  factory Block.fromMap(Map<String, dynamic> map) {
    return Block(
        blockID: map["block_id"],
        action: map["action"],
        actionID: map["action_id"],
        digitalSignature: jsonDecodeDigitalSignature(map["digital_signature"]),
        created: map["created"],
        previousHash: map["previous_hash"],
        userID: map["user_id"]);
  }
}

class Blockchain {
  final List<Block> blockchain;

  Blockchain({this.blockchain});

  factory Blockchain.fromJson(Map<String, dynamic> json) {
    List<Block> blockchain = [];
    json["blockchain"].forEach((jsonBlock) {
      Block block = Block.fromJson(jsonBlock);
      blockchain.add(block);
    });
    return Blockchain(blockchain: blockchain);
  }

  factory Blockchain.fromMap(List<Map<String, dynamic>> blockList) {
    List<Block> blockchain = [];
    blockList.forEach((mapBlock) {
      Block block = Block.fromMap(mapBlock);
      blockchain.add(block);
    });
    return Blockchain(blockchain: blockchain);
  }

  List<int> getActionID() {
    List<int> blockIDList = [];
    blockchain.forEach((block) {
      blockIDList.add(block.actionID);
    });
    return blockIDList;
  }
}
