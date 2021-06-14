import 'dart:convert';

import 'package:busrep/helpers/crypto.dart';
import 'package:busrep/models/blockchain.dart';
import 'package:busrep/repositories/database.dart';

Future<int> loadMaxBlockID() async {
  Block lastBlock = await getLastBlock();
  return lastBlock.blockID;
}

void blockchained(Blockchain responsePost) async {
  if (await isLegalBlockChain(responsePost)) {
    saveBlockchain(responsePost);
  } else {
    throw Exception('Error: Blockchain is Illegal !!!');
  }
}

Future<bool> isLegalBlockChain(Blockchain responsePost) async {
  Block previousBlock = await getLastBlock();
  for (Block block in responsePost.blockchain) {
    if ((await previousHash(previousBlock)) != block.previousHash) {
      return false;
    }
    previousBlock = block;
  }
  return true;
}

Future<String> previousHash(Block previousBlock) async {
  String message = previousBlock.blockID.toString() +
      previousBlock.action +
      previousBlock.actionID.toString() +
      jsonEncode(previousBlock.digitalSignature) +
      previousBlock.created +
      previousBlock.previousHash;
  List<int> hashedMessage = await hashMessage(message);
  var previousHash = "";
  hashedMessage.forEach((c) {
    String c2 = c.toRadixString(16);
    if (c2.length == 1) {
      c2 = "0" + c2;
    }
    previousHash += c2;
  });
  return previousHash;
}
