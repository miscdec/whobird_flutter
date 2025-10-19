import 'dart:io';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/services.dart';

/// Abstract interface for a service that manages audio focus.
abstract class AudioFocusService {
  /// Requests audio focus. Returns `true` if focus was granted.
  Future<bool> requestAudioFocus();

  /// Abandons audio focus.
  Future<void> abandonAudioFocus();
}

class AudioFocusServiceImpl implements AudioFocusService {

  AudioFocusServiceImpl();

  static final audio_session = AudioSession.instance;

  @override
  Future<bool> requestAudioFocus() async {
    if(Platform.isFuchsia || Platform.isWindows || Platform.isLinux) {
      return true;
    }
    audio_session.then( (session) async {
      await session.configure(const AudioSessionConfiguration.speech());
      await session.setActive(true,fallbackConfiguration: AudioSessionConfiguration.speech());
      return true;
    }).onError((e,stack) {
      print("Failed to configure audio session: '${e.toString()}'.");
      return false;
    });
    return false;
  }

  @override
  Future<void> abandonAudioFocus() async {
    if(Platform.isFuchsia || Platform.isWindows || Platform.isLinux) {
      return;
    }
    audio_session.then( (session) async {
      await session.setActive(false);
    });
  }
}