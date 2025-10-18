import 'package:flutter/services.dart';

/// Abstract interface for a service that manages audio focus.
abstract class AudioFocusService {
  /// Requests audio focus. Returns `true` if focus was granted.
  Future<bool> requestAudioFocus();

  /// Abandons audio focus.
  Future<void> abandonAudioFocus();
}

class AudioFocusServiceImpl implements AudioFocusService {
  static const _channel = MethodChannel('com.example.whobird/audio_focus');

  @override
  Future<bool> requestAudioFocus() async {
    try {
      final bool? result = await _channel.invokeMethod('requestAudioFocus');
      return result ?? false;
    } on PlatformException catch (e) {
      print("Failed to request audio focus: '${e.message}'.");
      return false;
    }
  }

  @override
  Future<void> abandonAudioFocus() async {
    try {
      await _channel.invokeMethod('abandonAudioFocus');
    } on PlatformException catch (e) {
      print("Failed to abandon audio focus: '${e.message}'.");
    }
  }
}