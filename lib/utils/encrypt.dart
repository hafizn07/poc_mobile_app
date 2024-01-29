import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptionService {
  static final key = encrypt.Key.fromUtf8('Paulwalker007ice');
  static final iv = encrypt.IV.fromLength(16); // IV length should be 16 for AES

  static String encryptData(String data) {
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter.encrypt(data, iv: iv);
    return encrypted.base64;
  }

  static String decryptData(String encryptedString) {
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final decrypted = encrypter.decrypt64(encryptedString, iv: iv);
    return decrypted;
  }
}
