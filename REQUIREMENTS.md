# whoBIRD Flutter Re-implementation: Requirements Document

## 1. Introduction and Vision

### 1.1. Project Vision

The vision of this project is to re-implement the native Android `whoBIRD` application using the Flutter framework. The new application will be a high-quality, cross-platform tool for real-time bird sound identification. The primary focus will be on creating a codebase that is simple, clean, testable, maintainable, and driven by purpose, adhering strictly to the principles of Clean Architecture and the software craftsmanship philosophy outlined in the project's development guidelines.

### 1.2. Document Purpose

This document defines the functional and non-functional requirements for the project. It serves as the foundational agreement for the project's scope, features, and technical standards, ensuring all development work is aligned with a clear and shared goal.

## 2. Core Functional Requirements

The Flutter application must replicate and, where appropriate, improve upon the core functionality of the existing native Android application.

### 2.1. Real-time Bird Sound Identification
- **FR1:** The application must continuously record audio from the device's microphone.
- **FR2:** The application must process the audio in real-time to identify bird sounds using the pre-trained BirdNET TensorFlow Lite model.
- **FR3:** All model inference and audio processing must occur on-device.
- **FR4:** The application must provide a mechanism to start and stop the real-time analysis.

### 2.2. Location and Time-based Filtering
- **FR5:** The application must be able to acquire the device's current location (latitude and longitude).
- **FR6:** The application must use the device's location and the current week of the year as inputs for the secondary "meta" model to improve prediction accuracy.
- **FR7:** The final prediction shown to the user must be a weighted combination of the main model's output and the meta-model's output.

### 2.3. User Interface and Results Display
- **FR8:** The main screen must display the top two most probable bird species detected, along with their confidence scores (as a percentage).
- **FR9:** The confidence level of a detection must be visually indicated (e.g., through a color-coded background).
- **FR10:** If a detection's confidence is above a specified threshold, an image of the bird must be fetched from the Macaulay Library and displayed in a WebView.
- **FR11:** The application must be able to display a mel spectrogram visualization of the recorded audio.

### 2.4. Observation History
- **FR12:** All positive detections above a certain confidence threshold must be saved to a persistent local database.
- **FR13:** A dedicated screen must display a list of all saved observations, sorted with the most recent first.
- **FR14:** Users must be able to view details for each observation, including playing back the recorded sound and viewing the bird's image.
- **FR15:** Users must be able to switch between a detailed view (all detections) and a summarized view (best detection per species).
- **FR16:** Users must have the ability to export the entire observation history as a CSV file.
- **FR17:** Users must have the ability to delete all saved observations.
- **FR18:** Users must be able to back up the database to a file.

### 2.5. Application Settings
- **FR19:** A dedicated settings screen must allow users to configure the application's behavior, including:
    - Adjusting the model's probability threshold.
    - Toggling the display of bird images.
    - Selecting the audio source.
    - Configuring a high-pass filter for audio.
    - Adjusting the influence of the location-based meta-model.
    - Enabling or disabling the saving of `.wav` files for each detection.

### 2.6. Initial Setup
- **FR20:** On first launch, the application must check for the required TensorFlow Lite models. If they are not present, it must download them from a remote source and verify their integrity before allowing the user to proceed.

## 3. Architectural and Non-Functional Requirements (Development Standards)

These requirements are mandatory and are based on the project's official development guidelines.

- **NFR1: Clean Architecture:** The codebase **must** be separated into distinct layers: `domain`, `data`, and `presentation`. The `domain` layer must be pure and have no dependencies on Flutter or any third-party packages.
- **NFR2: Dependency Inversion:** Higher-level modules (e.g., presentation) **must** depend on abstractions (interfaces/abstract classes) defined in lower-level modules (e.g., domain), not on concrete implementations.
- **NFR3: Code Style and Formatting:** All code **must** adhere to the official Dart Style Guide and be formatted with `dart format`. All naming conventions (UpperCamelCase, lowerCamelCase, etc.) specified in the guidelines **must** be followed.
- **NFR4: State Management:** The application **must** use a unidirectional data flow. State objects **must** be immutable (`@immutable`). State management logic will be handled by ViewModels (or equivalent), keeping widgets passive.
- **N-FR5: Dependency Injection:** The use of global singletons is prohibited. A dependency injection mechanism (e.g., `get_it`, `Riverpod`) **must** be used to provide dependencies.
- **NFR6: Immutability:** All data models and state classes **must** be immutable.
- **NFR7: Testability:** All business logic (use cases) and data repository implementations **must** be covered by unit tests. Key UI components and user flows **must** be covered by widget tests.
- **NFR8: Documentation:** All public classes, methods, and fields **must** have clear and concise `///` doc comments.
- **NFR9: Simplicity and Clarity:** Code should be simple, clear, and readable. Over-engineered abstractions and "magic" frameworks are to be avoided in favor of explicit logic.

## 4. Proposed Technology Stack

- **Framework:** Flutter
- **Language:** Dart
- **Architecture:** Clean Architecture
- **State Management:** To be determined, but must support unidirectional data flow and immutability (e.g., `flutter_bloc`, `Riverpod`).
- **Dependency Injection:** `get_it`
- **Machine Learning:** `tflite_flutter` and `tflite_flutter_helper`
- **Local Database:** `drift` (formerly Moor) or `sqflite`
- **Audio Recording:** `mic_stream` or a similar plugin.
- **HTTP Client:** `http` or `dio`
- **Permissions:** `permission_handler`
- **Location:** `geolocator` or `location`
- **File System:** `path_provider`