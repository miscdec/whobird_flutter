import 'package:shared_preferences/shared_preferences.dart';
import 'package:whobird_flutter/core/error/failures.dart';
import 'package:whobird_flutter/domain/entities/app_settings.dart';
import 'package:whobird_flutter/domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SharedPreferences sharedPreferences;

  SettingsRepositoryImpl({required this.sharedPreferences});

  static const _kProbabilityThreshold = 'probabilityThreshold';
  static const _kShowImages = 'showImages';
  static const _kAudioSource = 'audioSource';
  static const _kHighPassFilterHz = 'highPassFilterHz';
  static const _kMetaModelInfluence = 'metaModelInfluence';
  static const _kSaveWavFiles = 'saveWavFiles';

  @override
  Future<AppSettings> getSettings() async {
    try {
      final probabilityThreshold = sharedPreferences.getDouble(_kProbabilityThreshold) ?? 0.5;
      final showImages = sharedPreferences.getBool(_kShowImages) ?? true;
      final audioSource = sharedPreferences.getString(_kAudioSource) ?? 'Default';
      final highPassFilterHz = sharedPreferences.getInt(_kHighPassFilterHz) ?? 200;
      final metaModelInfluence = sharedPreferences.getDouble(_kMetaModelInfluence) ?? 0.5;
      final saveWavFiles = sharedPreferences.getBool(_kSaveWavFiles) ?? false;

      return AppSettings(
        probabilityThreshold: probabilityThreshold,
        showImages: showImages,
        audioSource: audioSource,
        highPassFilterHz: highPassFilterHz,
        metaModelInfluence: metaModelInfluence,
        saveWavFiles: saveWavFiles,
      );
    } catch (e) {
      throw CacheFailure(message: 'Failed to retrieve settings: $e');
    }
  }

  @override
  Future<void> saveSettings(AppSettings settings) async {
    try {
      await sharedPreferences.setDouble(_kProbabilityThreshold, settings.probabilityThreshold);
      await sharedPreferences.setBool(_kShowImages, settings.showImages);
      await sharedPreferences.setString(_kAudioSource, settings.audioSource);
      await sharedPreferences.setInt(_kHighPassFilterHz, settings.highPassFilterHz);
      await sharedPreferences.setDouble(_kMetaModelInfluence, settings.metaModelInfluence);
      await sharedPreferences.setBool(_kSaveWavFiles, settings.saveWavFiles);
    } catch (e) {
      throw CacheFailure(message: 'Failed to save settings: $e');
    }
  }
}