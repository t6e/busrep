import 'package:cryptography/cryptography.dart';

class ChainedKeys {
  final SimpleKeyPair keyPair;
  final SimpleKeyPair nextKeyPair;

  ChainedKeys({this.keyPair, this.nextKeyPair});
}
