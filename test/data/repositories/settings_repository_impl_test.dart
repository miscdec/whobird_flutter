import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whobird_flutter/data/repositories/settings_repository_impl.dart';
import 'package:whobird_flutter/domain/entities/app_settings.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late SettingsRepositoryImpl repository;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    repository = SettingsRepositoryImpl(sharedPreferences: mockSharedPreferences);
  });

  group('getSettings', () {
    test('should return default AppSettings when SharedPreferences is empty', () async {
      // Arrange
      when(() => mockSharedPreferences.getDouble(any())).thenReturn(null);
      when(() => mockSharedPreferences.getBool(any())).thenReturn(null);
      when(() => mockSharedPreferences.getString(any())).thenReturn(null);
      when(() => mockSharedPreferences.getInt(any())).thenReturn(null);

      // Act
      final result = await repository.getSettings();

      // Assert
      expect(result, isA<AppSettings>());
      expect(result.probabilityThreshold, 0.5);
      expect(result.showImages, isTrue);
    });

    test('should return AppSettings with values from SharedPreferences', () async {
      // Arrange
      when(() => mockSharedPreferences.getDouble(any())).thenReturn(0.8);
      when(() => mockSharedPreferences.getBool(any())).thenReturn(false);
      when(() => mockSharedPreferences.getString(any())).thenReturn('Custom');
      when(() => mockSharedPreferences.getInt(any())).thenReturn(500);

      // Act
      final result = await repository.getSettings();

      // Assert
      expect(result, isA<AppSettings>());
      expect(result.probabilityThreshold, 0.8);
      expect(result.showImages, isFalse);
    });
  });

  group('saveSettings', () {
    test('should call SharedPreferences to save the settings', () async {
      // Arrange
      const settings = AppSettings(
        probabilityThreshold: 0.7,
        showImages: false,
        audioSource: 'Mic',
        highPassFilterHz: 300,
        metaModelInfluence: 0.7,
        saveWavFiles: true,
      );
      when(() => mockSharedPreferences.setDouble(any(), any())).thenAnswer((_) async => true);
      when(() => mockSharedPreferences.setBool(any(), any())).thenAnswer((_) async => true);
      when(() => mockSharedPreferences.setString(any(), any())).thenAnswer((_) async => true);
      when(() => mockSharedPreferences.setInt(any(), any())).thenAnswer((_) async => true);

      // Act
      await repository.saveSettings(settings);

      // Assert
      verify(() => mockSharedPreferences.setDouble('probabilityThreshold', 0.7)).called(1);
      verify(() => mockSharedPreferences.setBool('showImages', false)).called(1);
      verify(() => mockSharedPreferences.setString('audioSource', 'Mic')).called(1);
      verify(() => mockSharedPreferences.setInt('highPassFilterHz', 300)).called(1);
      verify(() => mockSharedPreferences.setBool('saveWavFiles', true)).called(1);
    });
  });
}