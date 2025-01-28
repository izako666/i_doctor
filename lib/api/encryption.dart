import 'dart:convert';

import 'package:encrypt/encrypt.dart';
import 'package:flutter/services.dart';

Future<String> encryptPassword(String password) async {
  String jsonKey = await rootBundle.loadString('assets/keys/encryptor.json');
  Map<String, dynamic> jsonMap = jsonDecode(jsonKey);
  var key = jsonMap['key'];
  key = Key.fromUtf8(key.padRight(32, '0'));
  final encrypter = Encrypter(AES(key));
  final iv = IV.fromLength(16);
  String encrypted = encrypter.encrypt(password, iv: iv).base16;
  final encryptedWithIv = '${iv.base16}:$encrypted';
  return encryptedWithIv;
}

Future<String> decryptPassword(String encryptedPassword) async {
  String jsonKey = await rootBundle.loadString('assets/keys/encryptor.json');
  Map<String, dynamic> jsonMap = jsonDecode(jsonKey);
  var key = jsonMap['key'];
  key = Key.fromUtf8(key.padRight(32, '0'));
  final encrypter = Encrypter(AES(key));
  final parts = encryptedPassword.split(':');
  if (parts.length != 2) {
    throw ArgumentError('Invalid encrypted data format');
  }
  final iv = IV.fromBase16(parts[0]);
  final encrypted = Encrypted.fromBase16(parts[1]);
  String decrypted = encrypter.decrypt(encrypted, iv: iv);
  return decrypted;
}
