import 'package:whobird_flutter/domain/entities/app_settings.dart';

/// The contract for managing user settings persistence.
///
/// The implementation of this contract will be in the Data layer.
abstract class SettingsRepository {
  /// Retrieves the current [AppSettings] from local storage.
  Future<AppSettings> getSettings();

  /// Saves the given [AppSettings] to local storage.
  Future<void> saveSettings(AppSettings settings);
}