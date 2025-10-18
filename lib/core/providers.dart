import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whobird_flutter/data/datasources/audio_focus_service.dart';
import 'package:whobird_flutter/data/datasources/audio_service.dart';
import 'package:whobird_flutter/data/datasources/location_service.dart';
import 'package:whobird_flutter/data/datasources/ml_service.dart';
import 'package:whobird_flutter/data/datasources/persistence_service.dart';
import 'package:whobird_flutter/data/datasources/remote_data_service.dart';
import 'package:whobird_flutter/data/datasources/spectrogram_service.dart';
import 'package:whobird_flutter/data/repositories/audio_repository_impl.dart';
import 'package:whobird_flutter/data/repositories/classification_repository_impl.dart';
import 'package:whobird_flutter/data/repositories/model_repository_impl.dart';
import 'package:whobird_flutter/data/repositories/observation_history_repository_impl.dart';
import 'package:whobird_flutter/data/repositories/permission_repository_impl.dart';
import 'package:whobird_flutter/data/repositories/settings_repository_impl.dart';
import 'package:whobird_flutter/domain/entities/app_settings.dart';
import 'package:whobird_flutter/domain/entities/bird_observation.dart';
import 'package:whobird_flutter/domain/entities/classification.dart';
import 'package:whobird_flutter/domain/repositories/audio_repository.dart';
import 'package:whobird_flutter/domain/repositories/classification_repository.dart';
import 'package:whobird_flutter/domain/repositories/model_repository.dart';
import 'package:whobird_flutter/domain/repositories/observation_history_repository.dart';
import 'package:whobird_flutter/domain/repositories/permission_repository.dart';
import 'package:whobird_flutter/domain/repositories/settings_repository.dart';
import 'package:whobird_flutter/domain/usecases/clear_observation_history.dart';
import 'package:whobird_flutter/domain/usecases/get_observation_history.dart';
import 'package:whobird_flutter/domain/usecases/get_settings.dart';
import 'package:whobird_flutter/domain/usecases/save_settings.dart';
import 'package:whobird_flutter/domain/usecases/start_real_time_analysis.dart';
import 'package:whobird_flutter/core/usecases/usecase.dart';

// --- External ---
final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) => SharedPreferences.getInstance());
final httpClientProvider = Provider<http.Client>((ref) => http.Client());
final appDatabaseProvider = Provider<AppDatabase>((ref) => AppDatabase());

// --- Data Sources ---
final audioFocusServiceProvider = Provider<AudioFocusService>((ref) => AudioFocusServiceImpl());
final audioServiceProvider = Provider<AudioService>((ref) => MicStreamAudioService());
final locationServiceProvider = Provider<LocationService>((ref) => GeolocatorService());
final mlServiceProvider = Provider<MLService>((ref) => TfLiteService());
final persistenceServiceProvider = Provider<PersistenceService>((ref) => DriftPersistenceService(database: ref.watch(appDatabaseProvider)));
final remoteDataServiceProvider = Provider<RemoteDataService>((ref) => HttpModelDownloadService(client: ref.watch(httpClientProvider)));
final spectrogramServiceProvider = Provider<SpectrogramService>((ref) => SpectrogramServiceImpl());

// --- Repositories ---
final permissionRepositoryProvider = Provider<PermissionRepository>((ref) => PermissionRepositoryImpl());
final modelRepositoryProvider = Provider<ModelRepository>((ref) => ModelRepositoryImpl(remoteDataService: ref.watch(remoteDataServiceProvider)));
final audioRepositoryProvider = Provider<AudioRepository>((ref) => AudioRepositoryImpl(audioService: ref.watch(audioServiceProvider), audioFocusService: ref.watch(audioFocusServiceProvider)));
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final sharedPrefs = ref.watch(sharedPreferencesProvider);
  return sharedPrefs.when(
    data: (prefs) => SettingsRepositoryImpl(sharedPreferences: prefs),
    loading: () => throw Exception('SharedPreferences not yet available'),
    error: (err, stack) => throw Exception('SharedPreferences failed to load'),
  );
});
final classificationRepositoryProvider = Provider<ClassificationRepository>((ref) => ClassificationRepositoryImpl(
  mlService: ref.watch(mlServiceProvider),
  locationService: ref.watch(locationServiceProvider),
  spectrogramService: ref.watch(spectrogramServiceProvider),
));
final observationHistoryRepositoryProvider = Provider<ObservationHistoryRepository>((ref) => ObservationHistoryRepositoryImpl(persistenceService: ref.watch(persistenceServiceProvider)));


// --- Use Cases ---
final startRealTimeAnalysisUseCaseProvider = Provider<StartRealTimeAnalysis>((ref) => StartRealTimeAnalysis(
  permissionRepository: ref.watch(permissionRepositoryProvider),
  audioRepository: ref.watch(audioRepositoryProvider),
  classificationRepository: ref.watch(classificationRepositoryProvider),
));
final getObservationHistoryUseCaseProvider = Provider<GetObservationHistory>((ref) => GetObservationHistory(ref.watch(observationHistoryRepositoryProvider)));
final clearObservationHistoryUseCaseProvider = Provider<ClearObservationHistory>((ref) => ClearObservationHistory(ref.watch(observationHistoryRepositoryProvider)));
final getSettingsUseCaseProvider = Provider<GetSettings>((ref) => GetSettings(ref.watch(settingsRepositoryProvider)));
final saveSettingsUseCaseProvider = Provider<SaveSettings>((ref) => SaveSettings(ref.watch(settingsRepositoryProvider)));


// --- State Notifiers / Stream Providers ---
final analysisStreamProvider = StreamProvider.autoDispose<List<Classification>>((ref) {
  final useCase = ref.watch(startRealTimeAnalysisUseCaseProvider);
  return useCase(NoParams());
});

class HistoryNotifier extends StateNotifier<AsyncValue<List<BirdObservation>>> {
  final GetObservationHistory _getObservationHistory;
  final ClearObservationHistory _clearObservationHistory;

  HistoryNotifier(this._getObservationHistory, this._clearObservationHistory) : super(const AsyncValue.loading()) {
    loadHistory();
  }

  Future<void> loadHistory() async {
    state = const AsyncValue.loading();
    try {
      final observations = await _getObservationHistory(NoParams());
      state = AsyncValue.data(observations);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  Future<void> clearHistory() async {
    state = const AsyncValue.loading();
    try {
      await _clearObservationHistory(NoParams());
      state = const AsyncValue.data([]);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }
}

final historyNotifierProvider = StateNotifierProvider<HistoryNotifier, AsyncValue<List<BirdObservation>>>((ref) {
  return HistoryNotifier(
    ref.watch(getObservationHistoryUseCaseProvider),
    ref.watch(clearObservationHistoryUseCaseProvider),
  );
});

class SettingsNotifier extends StateNotifier<AsyncValue<AppSettings>> {
  final GetSettings _getSettings;
  final SaveSettings _saveSettings;

  SettingsNotifier(this._getSettings, this._saveSettings) : super(const AsyncValue.loading()) {
    loadSettings();
  }

  Future<void> loadSettings() async {
    state = const AsyncValue.loading();
    try {
      final settings = await _getSettings(NoParams());
      state = AsyncValue.data(settings);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  Future<void> saveSettings(AppSettings settings) async {
    try {
      await _saveSettings(settings);
      state = AsyncValue.data(settings);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }
}

final settingsNotifierProvider = StateNotifierProvider<SettingsNotifier, AsyncValue<AppSettings>>((ref) {
  return SettingsNotifier(
    ref.watch(getSettingsUseCaseProvider),
    ref.watch(saveSettingsUseCaseProvider),
  );
});