# whoBIRD Flutter: Implementation Tasks

This document breaks down the `DESIGN_DOCUMENT.md` into a detailed, actionable checklist of coding tasks. It is intended to be used as a project backlog to track development progress. Testing is an integral part of each step.

---

### Phase 1: Project Setup and Domain Layer (The Foundation)

-   [ ] **Task 1.1: Project Initialization**
    -   [ ] Initialize a new Flutter project using the `flutter create` command.
    -   [ ] Create the top-level directory structure: `/core`, `/domain`, `/data`, `/presentation` inside the `/lib` folder.
    -   [ ] Add all required dependencies to `pubspec.yaml` (e.g., `flutter_bloc`, `get_it`, `drift`, `tflite_flutter`, `mic_stream`, `geolocator`, `http`, `permission_handler`, `bloc_test`, `mocktail`).

-   [ ] **Task 1.2: Core Utilities**
    -   [ ] Set up a dependency injection container using `get_it` in `/core/di/`.
    -   [ ] Define custom error/failure types in `/core/error/`.
    -   [ ] Define app-wide constants in `/core/constants/`.

-   [ ] **Task 1.3: Domain Layer - Entities**
    -   [ ] Create `domain/entities/bird_observation.dart`.
    -   [ ] Create `domain/entities/classification.dart`.
    -   [ ] Create `domain/entities/audio_chunk.dart`.
    -   [ ] Create `domain/entities/app_settings.dart`.

-   [ ] **Task 1.4: Domain Layer - Repository Interfaces**
    -   [ ] Define `domain/repositories/classification_repository.dart`.
    -   [ ] Define `domain/repositories/audio_repository.dart`.
    -   [ ] Define `domain/repositories/observation_history_repository.dart`.
    -   [ ] Define `domain/repositories/settings_repository.dart`.

-   [ ] **Task 1.5: Domain Layer - Use Cases**
    -   [ ] Implement `domain/usecases/start_real_time_analysis.dart`.
    -   [ ] **Unit Test:** Write tests for `StartRealTimeAnalysisUseCase` using `mocktail` to mock repository dependencies.
    -   [ ] Implement `domain/usecases/get_observation_history.dart`.
    -   [ ] **Unit Test:** Write tests for `GetObservationHistoryUseCase`.
    -   [ ] Implement `domain/usecases/save_detection.dart`.
    -   [ ] **Unit Test:** Write tests for `SaveDetectionUseCase`.
    -   [ ] Implement `domain/usecases/get_settings.dart`.
    -   [ ] **Unit Test:** Write tests for `GetSettingsUseCase`.
    -   [ ] Implement `domain/usecases/save_settings.dart`.
    -   [ ] **Unit Test:** Write tests for `SaveSettingsUseCase`.

---

### Phase 2: Data Layer Implementation (The Guts)

-   [ ] **Task 2.1: Data Sources - Services**
    -   [ ] Define and implement `data/datasources/ml_service.dart` (wrapping `tflite_flutter`).
    -   [ ] Define and implement `data/datasources/audio_service.dart` (wrapping `mic_stream`).
    -   [ ] Define and implement `data/datasources/location_service.dart` (wrapping `geolocator`).
    -   [ ] Define and implement `data/datasources/persistence_service.dart` (wrapping `drift` and setting up DB tables).
    -   [ ] Define and implement `data/datasources/remote_data_service.dart` (wrapping `http` for model downloads).
    -   [ ] **Unit Test:** Write unit tests for each service, mocking their external plugin dependencies (e.g., mock `Tflite` plugin).

-   [ ] **Task 2.2: Repository Implementations**
    -   [ ] Implement `data/repositories/classification_repository_impl.dart`.
    -   [ ] **Integration Test:** Write tests for `ClassificationRepositoryImpl` to verify its interaction with the real (or mocked) ML and Location services.
    -   [ ] Implement `data/repositories/audio_repository_impl.dart`.
    -   [ ] **Integration Test:** Write tests for `AudioRepositoryImpl`.
    -   [ ] Implement `data/repositories/observation_history_repository_impl.dart`.
    -   [ ] **Integration Test:** Write tests for `ObservationHistoryRepositoryImpl`.
    -   [ ] Implement `data/repositories/settings_repository_impl.dart`.
    -   [ ] **Integration Test:** Write tests for `SettingsRepositoryImpl`.

---

### Phase 3: Presentation Layer (The UI)

-   [ ] **Task 3.1: BLoC Implementation**
    -   [ ] Implement `presentation/bloc/analysis/analysis_bloc.dart` with all events and states.
    -   [ ] **Unit Test:** Write tests for `AnalysisBloc` using `bloc_test`, mocking its use case dependencies.
    -   [ ] Implement `presentation/bloc/history/history_bloc.dart` with all events and states.
    -   [ ] **Unit Test:** Write tests for `HistoryBloc` using `bloc_test`.
    -   [ ] Implement `presentation/bloc/settings/settings_bloc.dart` with all events and states.
    -   [ ] **Unit Test:** Write tests for `SettingsBloc` using `bloc_test`.

-   [ ] **Task 3.2: Widget and Screen Development**
    -   [ ] Create the main analysis screen (`presentation/screens/main_analysis_screen.dart`).
    -   [ ] **Widget Test:** Write tests for the main analysis screen to verify it correctly renders all states from a mocked `AnalysisBloc`.
    -   [ ] Create the observation history screen (`presentation/screens/history_screen.dart`).
    -   [ ] **Widget Test:** Write tests for the history screen to verify list loading, data, and empty states from a mocked `HistoryBloc`.
    -   [ ] Create the settings screen (`presentation/screens/settings_screen.dart`).
    -   [ ] **Widget Test:** Write tests for key user interactions on the settings screen with a mocked `SettingsBloc`.
    -   [ ] Develop reusable widgets (e.g., `DetectionCard`, `SpectrogramView`) in `/presentation/widgets`.
    -   [ ] **Widget Test:** Write individual widget tests for reusable components.
    -   [ ] Set up app-level routing.

---

### Phase 4: Final Integration, Testing, and Polish

-   [ ] **Task 4.1: Initial Setup and Permissions**
    -   [ ] Implement the first-launch logic to check for, download, and verify the TFLite models using the `RemoteDataService`.
    -   [ ] Implement a robust permissions flow for microphone and location access using `permission_handler`.
    -   [ ] **Widget Test:** Write widget tests for the initial setup and permission request UI flows.

-   [ ] **Task 4.2: End-to-End Testing**
    -   [ ] Manually perform end-to-end testing of all application features on both iOS and Android.
    -   [ ] (Optional but Recommended) Write automated integration tests (`integration_test` package) for critical user flows, such as a full record-to-detection-to-history flow.

-   [ ] **Task 4.3: Performance and Polish**
    -   [ ] Profile the application using Flutter DevTools to identify and fix any performance bottlenecks.
    -   [ ] Review and refine the UI/UX for a polished look and feel.
    -   [ ] Verify that all non-functional requirements from `REQUIREMENTS.md` have been met.
    -   [ ] Prepare for a release build.