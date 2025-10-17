# whoBIRD Flutter: Detailed Design Document

## 1. Introduction

### 1.1. Document Purpose
This document provides the detailed technical design for the Flutter re-implementation of the whoBIRD application. It serves as the engineering blueprint, translating the project's requirements into a concrete architectural and implementation plan. All development work should adhere to the designs specified herein.

### 1.2. Scope and References
The design outlined in this document is based on the functional and non-functional requirements specified in `REQUIREMENTS.md`. This document assumes a full understanding of the project's goals as defined in the requirements document.

## 2. High-Level Architecture (Clean Architecture Mapping)

The application will strictly follow the principles of **Clean Architecture**, ensuring a clear separation of concerns, testability, and maintainability. The codebase will be organized into three primary layers: **Presentation**, **Domain**, and **Data**.

The diagram below illustrates the dependency flow, where outer layers depend only on inner layers through abstractions.

```
+----------------------------------------------------------------+
|  Presentation Layer (Flutter Widgets, BLoCs/ViewModels)        |
|      -> Depends on Domain Layer                                |
+----------------------------------------------------------------+
             ^
             | (Abstractions)
+----------------------------------------------------------------+
|  Domain Layer (Entities, Use Cases, Repository Interfaces)     |
|      -> No dependencies on other layers                        |
+----------------------------------------------------------------+
             ^
             | (Abstractions)
+----------------------------------------------------------------+
|  Data Layer (Repository Impls, Services, Data Sources)         |
|      -> Implements Domain contracts                            |
+----------------------------------------------------------------+
```

### Mapping from Native Android App to Clean Architecture:

| Original Android Component (`whoBIRD-master`) | New Flutter Clean Architecture Layer | Rationale |
| :--- | :--- | :--- |
| `MainActivity.kt`, `ViewActivity.kt` (UI XMLs) | **Presentation** | Responsible for rendering the UI and handling user input. |
| `SoundClassifier.kt` (Result combination logic) | **Domain** (Use Cases) | The core business rule of combining model outputs is framework-agnostic. |
| `SoundClassifier.kt` (TFLite interaction) | **Data** (ML Service) | The implementation detail of running a TFLite model belongs in the data layer. |
| `SoundClassifier.kt` (AudioRecord) | **Data** (Audio Service) | Accessing device hardware is an external data source concern. |
| `BirdDBHelper.java` | **Data** (Persistence Service) | The implementation of the database (SQLite) is a data layer detail. |
| `LocationHelper.java` | **Data** (Location Service) | Accessing the GPS is an external data source concern. |
| `Downloader.java` | **Data** (Remote Service) | Fetching data from a remote URL is a data layer responsibility. |

---

## 3. Domain Layer Design (The "What")

The Domain layer is the core of the application, containing all business logic and rules. It is completely independent of any frameworks.

### 3.1. Entities
*   **`BirdObservation`**: An immutable class representing a single recorded detection.
    ```dart
    @immutable
    class BirdObservation {
      final String id;
      final String commonName;
      final String scientificName;
      final double latitude;
      final double longitude;
      final double confidence;
      final DateTime timestamp;
      // ... other fields
    }
    ```
*   **`Classification`**: An immutable class representing a single classification result from the model.
    ```dart
    @immutable
    class Classification {
      final String label; // e.g., "Passer domesticus_House Sparrow"
      final double score;
    }
    ```
*   **`AudioChunk`**: Represents a buffer of audio data.
*   **`AppSettings`**: An entity representing the user's configurable settings.

### 3.2. Repository Interfaces (Contracts)
These are the abstract classes that define the contract for the Data layer to implement.

*   **`ClassificationRepository`**:
    ```dart
    abstract class ClassificationRepository {
      Future<List<Classification>> classifyAudio(AudioChunk audioChunk);
      Future<List<Classification>> filterByLocation(List<Classification> classifications, Location location);
    }
    ```
*   **`AudioRepository`**:
    ```dart
    abstract class AudioRepository {
      Stream<AudioChunk> get audioStream;
      Future<void> startRecording();
      Future<void> stopRecording();
    }
    ```
*   **`ObservationHistoryRepository`**:
    ```dart
    abstract class ObservationHistoryRepository {
      Future<void> saveObservation(BirdObservation observation);
      Future<List<BirdObservation>> getObservations();
      Future<void> clearHistory();
    }
    ```
*   **`SettingsRepository`**:
    ```dart
    abstract class SettingsRepository {
      Future<AppSettings> getSettings();
      Future<void> saveSettings(AppSettings settings);
    }
    ```

### 3.3. Use Cases (Interactors)
Each use case represents a single, discrete business operation.

*   **`StartRealTimeAnalysisUseCase`**: Subscribes to the `AudioRepository` stream, passes chunks to the `ClassificationRepository`, combines results, and outputs a stream of `BirdObservation` results.
*   **`GetObservationHistoryUseCase`**: Retrieves the list of observations from the `ObservationHistoryRepository`.
*   **`SaveDetectionUseCase`**: Saves a valid `BirdObservation` to the `ObservationHistoryRepository`.
*   **`GetSettingsUseCase`** and **`SaveSettingsUseCase`**: Manage application settings.

---

## 4. Data Layer Design (The "How")

The Data layer provides concrete implementations of the Domain layer's repository contracts.

### 4.1. Repository Implementations
*   **`ClassificationRepositoryImpl`**: Implements `ClassificationRepository`. It will depend on an `MLService` abstraction.
*   **`AudioRepositoryImpl`**: Implements `AudioRepository`. It will depend on an `AudioService` abstraction.
*   **`ObservationHistoryRepositoryImpl`**: Implements `ObservationHistoryRepository`. It will depend on a `PersistenceService` abstraction.

### 4.2. Data Sources (Services)
These are the concrete implementations that interact with external dependencies like plugins and APIs. Each will have an abstraction to facilitate testing and flexibility.

*   **ML Service (Abstraction for `NFR10`)**:
    *   **`MLService` (Interface)**: `abstract class MLService { Future<List<Classification>> runInference(Model model, data); }`
    *   **`TfLiteService` (Implementation)**: Wraps the `tflite_flutter` plugin. It will load the `model.tflite` and `metaModel.tflite` files and run the inference logic.
*   **Audio Service**:
    *   **`AudioService` (Interface)**: Defines the contract for audio recording.
    *   **`MicStreamAudioService` (Implementation)**: Uses the `mic_stream` plugin to provide a stream of raw audio data.
*   **Persistence Service**:
    *   **`PersistenceService` (Interface)**: Defines the contract for local database operations.
    *   **`DriftPersistenceService` (Implementation)**: Uses the `drift` package to implement a local SQLite database.
*   **Location Service**:
    *   **`LocationService` (Interface)**: Defines the contract for GPS data.
    *   **`GeolocatorService` (Implementation)**: Uses the `geolocator` plugin.
*   **Remote Service**:
    *   **`RemoteDataService` (Interface)**: Defines the contract for fetching remote data.
    *   **`HttpModelDownloadService` (Implementation)**: Uses the `http` package to download the TFLite models on first launch.

---

## 5. Presentation Layer Design (The "UI")

### 5.1. State Management Strategy
We will use the **BLoC (Business Logic Component)** library. This choice aligns perfectly with the requirement for a unidirectional data flow.

*   **Flow:** Widget dispatches an **Event** -> **Bloc** receives the Event -> Bloc calls one or more **Use Cases** from the Domain layer -> Bloc emits a new **State** -> Widget rebuilds based on the new State.
*   **DI:** Dependencies (Use Cases) will be provided to the Blocs via `get_it` and `flutter_bloc`'s `BlocProvider`.

### 5.2. Screen and BLoC Design

*   **Main Analysis Screen (`main_analysis_screen.dart`)**:
    *   **`AnalysisBloc`**:
        *   **Events**: `StartAnalysis`, `StopAnalysis`, `SettingsChanged`.
        *   **States**: `AnalysisInitial`, `AnalysisLoading`, `AnalysisInProgress(List<BirdObservation> detections)`, `AnalysisFailure(String error)`.
        *   **Dependencies**: `StartRealTimeAnalysisUseCase`, `GetSettingsUseCase`.
*   **Observation History Screen (`history_screen.dart`)**:
    *   **`HistoryBloc`**:
        *   **Events**: `LoadHistory`, `DeleteHistory`.
        *   **States**: `HistoryInitial`, `HistoryLoading`, `HistoryLoaded(List<BirdObservation> observations)`, `HistoryEmpty`, `HistoryFailure`.
        *   **Dependencies**: `GetObservationHistoryUseCase`, `ClearHistoryUseCase`.
*   **Settings Screen (`settings_screen.dart`)**:
    *   **`SettingsBloc`**:
        *   **Events**: `LoadSettings`, `UpdateSetting(Setting setting)`.
        *   **States**: `SettingsInitial`, `SettingsLoading`, `SettingsLoaded(AppSettings settings)`.
        *   **Dependencies**: `GetSettingsUseCase`, `SaveSettingsUseCase`.

---

## 6. Development Phasing Plan

Development will proceed in logical phases to ensure a stable foundation and iterative progress.

1.  **Phase 1: Project Setup and Domain Layer (The Foundation)**
    *   Set up the Flutter project with the required directory structure.
    *   Add all necessary dependencies to `pubspec.yaml`.
    *   Implement all **Entities** and **Repository Interfaces** in the Domain layer.
    *   Write unit tests for all planned **Use Cases** (using mocks for repositories).

2.  **Phase 2: Data Layer Implementation (The Guts)**
    *   Implement all **Data Source Services** (Audio, Location, Persistence, ML).
    *   Implement all **Repository Implementations**, connecting them to the services.
    *   Write integration tests for the repositories to ensure they work with the services correctly.

3.  **Phase 3: Presentation Layer (The UI)**
    *   Implement the BLoCs for each screen, injecting the Domain Use Cases.
    *   Develop the Flutter widgets for each screen, connecting them to the BLoCs using `BlocProvider` and `BlocBuilder`.
    *   Write widget tests for key UI interactions and state changes.

4.  **Phase 4: Final Integration, Testing, and Polish**
    *   Connect all layers and perform end-to-end testing.
    *   Profile the application for performance bottlenecks and optimize where necessary.
    *   Finalize UI/UX polish and prepare for release.