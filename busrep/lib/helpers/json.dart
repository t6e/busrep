import 'dart:convert';

List<int> jsonDecodeDigitalSignature(String jsonDigitalSignature) {
  return jsonDecode(jsonDigitalSignature).cast<int>() as List<int>;
}
