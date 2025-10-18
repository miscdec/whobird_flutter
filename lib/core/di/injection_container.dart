import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:whobird_flutter/data/datasources/audio_service.dart';
import 'package:whobird_flutter/data/datasources/location_service.dart';
import 'package:whobird_flutter/data/datasources/ml_service.dart';
import 'package:whobird_flutter/data/datasources/persistence_service.dart';
import 'package:whobird_flutter/data/datasources/remote_data_service.dart';
import 'package:whobird_flutter/data/repositories/audio_repository_impl.dart';
import 'package:whobird_flutter/data/repositories/classification_repository_impl.dart';
import 'package:whobird_flutter/data/repositories/observation_history_repository_impl.dart';
import 'package:whobird_flutter/data/repositories/settings_repository_impl.dart';
import 'package:whobird_flutter/domain/repositories/audio_repository.dart';
import 'package:whobird_flutter/domain/repositories/classification_repository.dart';
import 'package:whobird_flutter/domain/repositories/observation_history_repository.dart';
import 'package:whobird_flutter/domain/repositories/settings_repository.dart';
import 'package:whobird_flutter/domain/usecases/clear_observation_history.dart';
import 'package:whobird_flutter/domain/usecases/get_observation_history.dart';
import 'package:whobird_flutter/domain/usecases/get_settings.dart';
import 'package:whobird_flutter/domain/usecases/save_detection.dart';
import 'package:whobird_flutter/domain/usecases/save_settings.dart';
import 'package:whobird_flutter/domain/usecases/start_real_time_analysis.dart';
import 'package:whobird_flutter/presentation/bloc/analysis/analysis_bloc.dart';
import 'package:whobird_flutter/presentation/bloc/history/history_bloc.dart';
import 'package:whobird_flutter/presentation/bloc/settings/settings_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // BLoCs
  sl.registerFactory(() => AnalysisBloc(startRealTimeAnalysis: sl()));
  sl.registerFactory(() => HistoryBloc(getObservationHistory: sl(), clearObservationHistory: sl()));
  sl.registerFactory(() => SettingsBloc(getSettings: sl(), saveSettings: sl()));

  // Use Cases
  sl.registerLazySingleton(() => StartRealTimeAnalysis(audioRepository: sl(), classificationRepository: sl()));
  sl.registerLazySingleton(() => GetObservationHistory(sl()));
  sl.registerLazySingleton(() => ClearObservationHistory(sl()));
  sl.registerLazySingleton(() => SaveDetection(sl()));
  sl.registerLazySingleton(() => GetSettings(sl()));
  sl.registerLazySingleton(() => SaveSettings(sl()));

  // Repositories
  sl.registerLazySingleton<ClassificationRepository>(() => ClassificationRepositoryImpl(mlService: sl()));
  sl.registerLazySingleton<AudioRepository>(() => AudioRepositoryImpl(audioService: sl()));
  sl.registerLazySingleton<ObservationHistoryRepository>(() => ObservationHistoryRepositoryImpl(persistenceService: sl()));
  sl.registerLazySingleton<SettingsRepository>(() => SettingsRepositoryImpl()); // Placeholder for now

  // Data Sources
  sl.registerLazySingleton<MLService>(() => TfLiteService());
  sl.registerLazySingleton<AudioService>(() => MicStreamAudioService());
  sl.registerLazySingleton<LocationService>(() => GeolocatorService());
  sl.registerLazySingleton<PersistenceService>(() => DriftPersistenceService());
  sl.registerLazySingleton<RemoteDataService>(() => HttpModelDownloadService(client: sl()));

  // External
  sl.registerLazySingleton(() => http.Client());
}