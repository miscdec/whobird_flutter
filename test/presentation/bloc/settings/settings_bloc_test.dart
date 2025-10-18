import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:whobird_flutter/core/usecases/usecase.dart';
import 'package:whobird_flutter/domain/entities/app_settings.dart';
import 'package:whobird_flutter/domain/usecases/get_settings.dart';
import 'package:whobird_flutter/domain/usecases/save_settings.dart';
import 'package:whobird_flutter/presentation/bloc/settings/settings_bloc.dart';

class MockGetSettings extends Mock implements GetSettings {}
class MockSaveSettings extends Mock implements SaveSettings {}

void main() {
  late SettingsBloc bloc;
  late MockGetSettings mockGetSettings;
  late MockSaveSettings mockSaveSettings;

  setUp(() {
    mockGetSettings = MockGetSettings();
    mockSaveSettings = MockSaveSettings();
    bloc = SettingsBloc(
      getSettings: mockGetSettings,
      saveSettings: mockSaveSettings,
    );
  });

  const testSettings = AppSettings(
    probabilityThreshold: 0.5,
    showImages: true,
    audioSource: 'Default',
    highPassFilterHz: 200,
    metaModelInfluence: 0.5,
    saveWavFiles: false,
  );

  test('initial state should be SettingsInitial', () {
    expect(bloc.state, SettingsInitial());
  });

  group('LoadSettings', () {
    blocTest<SettingsBloc, SettingsState>(
      'should emit [SettingsLoading, SettingsLoaded] when settings are loaded',
      build: () {
        when(() => mockGetSettings(NoParams())).thenAnswer((_) async => testSettings);
        return bloc;
      },
      act: (bloc) => bloc.add(LoadSettings()),
      expect: () => [
        SettingsLoading(),
        const SettingsLoaded(testSettings),
      ],
    );
  });

  group('SaveSettingsEvent', () {
    blocTest<SettingsBloc, SettingsState>(
      'should call SaveSettings use case and emit [SettingsLoaded]',
      build: () {
        when(() => mockSaveSettings(any())).thenAnswer((_) async => Future.value());
        return bloc;
      },
      act: (bloc) => bloc.add(const SaveSettingsEvent(testSettings)),
      verify: (_) {
        verify(() => mockSaveSettings(testSettings)).called(1);
      },
      expect: () => [
        const SettingsLoaded(testSettings),
      ],
    );
  });
}