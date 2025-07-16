import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart'; // Uncomment when added

class SecurityService {
  static const MethodChannel _channel = MethodChannel('security/screenshot');
  
  /// Enable screenshot and screen recording protection
  static Future<void> enableSecureMode() async {
    try {
      if (Platform.isAndroid) {
        // Method 1: Using flutter_windowmanager (recommended)
        await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
        
        // Method 2: Using platform channel (alternative)
        await _channel.invokeMethod('enableSecureMode');
      } else if (Platform.isIOS) {
        // iOS automatically hides content in app switcher, but we can add more protection
        await _channel.invokeMethod('enableSecureMode');
      }
    } catch (e) {
      print('Failed to enable secure mode: $e');
    }
  }
  
  /// Disable screenshot protection
  static Future<void> disableSecureMode() async {
    try {
      if (Platform.isAndroid) {
        // Method 1: Using flutter_windowmanager
        await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
        
        // Method 2: Using platform channel
        await _channel.invokeMethod('disableSecureMode');
      } else if (Platform.isIOS) {
        await _channel.invokeMethod('disableSecureMode');
      }
    } catch (e) {
      print('Failed to disable secure mode: $e');
    }
  }
  
  /// Check if device supports screenshot detection
  static Future<bool> canDetectScreenshots() async {
    try {
      return await _channel.invokeMethod('canDetectScreenshots') ?? false;
    } catch (e) {
      return false;
    }
  }
}