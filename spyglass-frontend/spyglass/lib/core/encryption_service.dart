import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'logger.dart';

class EncryptionService {
  static String encrypt(String plainText, String password) {
    try {
      // Generate a key from password using consistent method
      final key = _generateKey(password);
      
      // Use CBC mode with PKCS7 padding (default)
      final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
      
      // Generate random IV
      final iv = IV.fromSecureRandom(16);
      
      // Encrypt the text
      final encrypted = encrypter.encrypt(plainText, iv: iv);
      
      // Combine IV + encrypted data and encode as base64
      final combined = iv.bytes + encrypted.bytes;
      final result = base64.encode(combined);
      
      logger.d('🔐 Encrypted ${plainText.length} chars to ${result.length} chars');
      logger.d('🔐 Key length: ${key.bytes.length}, IV length: ${iv.bytes.length}');
      return result;
    } catch (e) {
      logger.e('❌ Encryption failed: $e');
      throw Exception('Encryption failed: $e');
    }
  }

  static String decrypt(String encryptedData, String password) {
    try {
      logger.d('🔓 Starting decryption...');
      logger.d('🔓 Encrypted data length: ${encryptedData.length}');
      
      // Decode from base64
      final combined = base64.decode(encryptedData);
      logger.d('🔓 Combined bytes length: ${combined.length}');
      
      // Validate minimum length (16 bytes IV + at least 16 bytes data)
      if (combined.length < 32) {
        throw Exception('Invalid encrypted data: too short');
      }
      
      // Extract IV (first 16 bytes) and encrypted data (rest)
      final ivBytes = combined.take(16).toList();
      final encryptedBytes = combined.skip(16).toList();
      
      logger.d('🔓 IV bytes length: ${ivBytes.length}');
      logger.d('🔓 Encrypted bytes length: ${encryptedBytes.length}');
      
      // Validate IV length
      if (ivBytes.length != 16) {
        throw Exception('Invalid IV length: ${ivBytes.length}');
      }
      
      // Create IV and encrypted objects
      final iv = IV(Uint8List.fromList(ivBytes));
      final encrypted = Encrypted(Uint8List.fromList(encryptedBytes));
      
      // Generate key from password (must match encryption)
      final key = _generateKey(password);
      logger.d('🔓 Generated key length: ${key.bytes.length}');
      
      // Create encrypter with same settings as encryption
      final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
      
      // Decrypt
      final decrypted = encrypter.decrypt(encrypted, iv: iv);
      
      logger.d('🔓 Decrypted ${encryptedData.length} chars to ${decrypted.length} chars');
      return decrypted;
    } catch (e) {
      logger.e('❌ Decryption failed: $e');
      // More specific error messages
      if (e.toString().contains('Invalid or corrupted pad block')) {
        throw Exception('Wrong encryption key or corrupted data');
      } else if (e.toString().contains('Invalid argument(s)')) {
        throw Exception('Invalid encrypted data format');
      } else {
        throw Exception('Decryption failed: $e');
      }
    }
  }

  // Alternative decrypt method for debugging
  static String decryptWithValidation(String encryptedData, String password) {
    try {
      logger.d('🔍 Debug decrypt - Input validation...');
      
      // Validate input
      if (encryptedData.isEmpty) {
        throw Exception('Empty encrypted data');
      }
      
      if (password.isEmpty) {
        throw Exception('Empty password');
      }
      
      // Try to decode base64 first
      late Uint8List combined;
      try {
        combined = base64.decode(encryptedData);
        logger.d('🔍 Base64 decode successful: ${combined.length} bytes');
      } catch (e) {
        throw Exception('Invalid base64 encoding: $e');
      }
      
      // Check minimum length
      if (combined.length < 32) {
        throw Exception('Data too short: ${combined.length} bytes (minimum 32)');
      }
      
      // Extract components
      final ivBytes = combined.sublist(0, 16);
      final encryptedBytes = combined.sublist(16);
      
      logger.d('🔍 IV: ${ivBytes.length} bytes');
      logger.d('🔍 Encrypted content: ${encryptedBytes.length} bytes');
      
      // Check if encrypted data length is valid for AES block size
      if (encryptedBytes.length % 16 != 0) {
        throw Exception('Invalid encrypted data length: ${encryptedBytes.length} (not multiple of 16)');
      }
      
      // Generate key
      final key = _generateKey(password);
      logger.d('🔍 Generated key: ${key.bytes.length} bytes');
      
      // Create objects
      final iv = IV(ivBytes);
      final encrypted = Encrypted(encryptedBytes);
      
      // Create encrypter
      final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
      
      // Attempt decryption
      final decrypted = encrypter.decrypt(encrypted, iv: iv);
      
      logger.d('🔍 Decryption successful: ${decrypted.length} chars');
      return decrypted;
      
    } catch (e) {
      logger.e('🔍 Debug decrypt failed: $e');
      rethrow;
    }
  }

  static Key _generateKey(String password) {
    try {
      // Use a consistent salt
      final salt = utf8.encode('spyglass_salt_2025'); 
      final passwordBytes = utf8.encode(password);
      
      // Combine password and salt
      var key = passwordBytes + salt;
      
      // Apply SHA-256 iterations for key strengthening
      for (int i = 0; i < 1000; i++) {
        key = sha256.convert(key).bytes;
      }
      
      // Take first 32 bytes for AES-256
      final keyBytes = Uint8List.fromList(key.take(32).toList());
      
      logger.d('🔑 Generated key from password: ${keyBytes.length} bytes');
      return Key(keyBytes);
    } catch (e) {
      logger.e('❌ Key generation failed: $e');
      throw Exception('Key generation failed: $e');
    }
  }

  // Utility method to test encryption/decryption roundtrip
  static bool testEncryptionRoundtrip(String testData, String password) {
    try {
      logger.d('🧪 Testing encryption roundtrip...');
      
      final encrypted = encrypt(testData, password);
      logger.d('🧪 Encryption successful');
      
      final decrypted = decrypt(encrypted, password);
      logger.d('🧪 Decryption successful');
      
      final success = decrypted == testData;
      logger.d('🧪 Roundtrip test: ${success ? 'PASSED' : 'FAILED'}');
      
      if (!success) {
        logger.e('🧪 Original: "$testData"');
        logger.e('🧪 Decrypted: "$decrypted"');
      }
      
      return success;
    } catch (e) {
      logger.e('🧪 Roundtrip test FAILED: $e');
      return false;
    }
  }
}