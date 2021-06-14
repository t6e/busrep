import 'package:busrep/helpers/userID.dart';
import 'package:busrep/models/crypto.dart';
import 'package:cryptography/cryptography.dart';

import 'dart:convert';

final ed25519 = Ed25519();
// final x25519 = X25519();
final hasher = Sha256();
// final aesCtr = AesCtr.with256bits(macAlgorithm: Hmac.sha256());

// Chained Keys
Future<ChainedKeys> createChainedKeys(String password) async {
  SimpleKeyPair keyPair = await createKeyPairFromSeed(password);
  SimpleKeyPair nextKeyPair = await generateKeyPair();
  return ChainedKeys(keyPair: keyPair, nextKeyPair: nextKeyPair);
}

//Key Pair
Future<SimpleKeyPair> createKeyPairFromSeed(String password) async {
  final String userID = await createUserID();
  final SimpleKeyPair keyPair =
      await createKeyPairFromPassword(userID, password);
  return keyPair;
}

Future<SimpleKeyPair> createKeyPairFromPassword(
    String userID, String password) async {
  final hash = await hasher.hash(utf8.encode(userID + password));
  final elements = hash.bytes;

  return ed25519.newKeyPairFromSeed(elements);
}

Future<SimpleKeyPair> generateKeyPair() async {
  return await ed25519.newKeyPair();
}

//DigitalSignature
Future<List<int>> createDigitalSignature(
    ChainedKeys chainedKeys, String username, String userID) async {
  final publicKey = await chainedKeys.nextKeyPair.extractPublicKey();
  final message = createRegisterMessage(username, userID, publicKey);
  final hashedMessage = await hashMessage(message);
  final Signature digitalSignature =
      await ed25519.sign(hashedMessage, keyPair: chainedKeys.keyPair);
  return digitalSignature.bytes;
}

//Create Message
String createRegisterMessage(
    String username, String userID, SimplePublicKey publicKey) {
  return jsonEncode({
    "username": username,
    "userID": userID,
    "nextPublicKey": publicKey.bytes
  });
}

//Hash
Future<List<int>> hashMessage(String message) async {
  final hash = await hasher.hash(utf8.encode(message));
  return hash.bytes;
}

//
// Future<SimpleKeyPair> createKeyPairFromPrivateKey(List<int> privateKey) async {
//   return ed25519.newKeyPairFromSeed(privateKey);
// }
//

//
// // Serialize
// String serializePrivateKey(List<int> privateKey) {
//   return jsonEncode(privateKey);
// }
//
// String serializePublicKey(SimplePublicKey publicKey) {
//   return jsonEncode(publicKey.bytes);
// }
//
// String serializeSignature(Signature signature) {
//   return jsonEncode(signature.bytes);
// }
//
// // Deserialize
// SimplePublicKey deserializePublicKeyED25519(String publicKey) {
//   return SimplePublicKey(jsonDecode(publicKey).cast<int>(),
//       type: KeyPairType.ed25519);
// }
//
// SimplePublicKey deserializePublicKeyX25519(String publicKey) {
//   return SimplePublicKey(jsonDecode(publicKey).cast<int>(),
//       type: KeyPairType.x25519);
// }
//
// Future<SimpleKeyPair> deserializeKeyPairED25519(
//     String encodedPrivateKey) async {
//   final decodedPrivateKey = jsonDecode(encodedPrivateKey);
//
//   final List<int> privateKey = decodedPrivateKey.cast<int>();
//   return ed25519.newKeyPairFromSeed(privateKey);
// }
//
// Future<SimpleKeyPair> deserializeKeyPairX25519(String encodedPrivateKey) async {
//   final decodedPrivateKey = jsonDecode(encodedPrivateKey);
//
//   final List<int> privateKey = decodedPrivateKey.cast<int>();
//   return x25519.newKeyPairFromSeed(privateKey);
// }
//
// Signature deserializeSignature(String stringSignature, String publicKey) {
//   final mapSignature = jsonDecode(stringSignature);
//   return Signature(mapSignature.cast<int>(),
//       publicKey: deserializePublicKeyED25519(publicKey));
// }
//
// // Convert
// SimplePublicKey convertED25519(SimplePublicKey publicKey) {
//   return SimplePublicKey(publicKey.bytes, type: KeyPairType.ed25519);
// }
//
// SimplePublicKey convertX25519(SimplePublicKey publicKey) {
//   return SimplePublicKey(publicKey.bytes, type: KeyPairType.x25519);
// }
//
// // Encrypt
// Future<SecretBox> aesCtrEncrypt(String message, SecretKey secretKey) async {
//   final mByte = utf8.encode(message);
//   return aesCtr.encrypt(mByte, secretKey: secretKey);
// }
//
// // String serializeTag(List<String> tag) {
// //   return jsonEncode(tag);
// // }
// //
// // List<String> deserializeTag(String tag) {
// //   return jsonDecode(tag).cast<String>();
// // }
//

//
// Future<bool> dsVerify(messageHash, signature) {
//   return ed25519.verify(messageHash, signature: signature);
// }
