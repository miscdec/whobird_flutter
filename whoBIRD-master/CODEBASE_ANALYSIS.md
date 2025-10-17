# whoBIRD Codebase Analysis

This document provides a detailed analysis of the whoBIRD Android application's project architecture and code logic. It is intended to serve as a reference for future development and maintenance.

## 1. Project Overview

whoBIRD is an Android application that identifies bird species in real-time by analyzing their sounds. It leverages the **BirdNET** machine learning model, a neural network trained to classify over 6,000 bird species from around the world.

The key features of the application are:
- **Real-time audio analysis:** The app continuously listens to the environment and identifies bird sounds on-device.
- **Offline functionality:** All analysis is performed locally, without requiring an internet connection (after initial model download).
- **Location and time awareness:** The app uses the device's location and the current date to improve prediction accuracy by filtering for birds that are likely to be present.
- **Observation history:** All positive detections are stored in a local database for later review.
- **Spectrogram visualization:** The app can display a mel spectrogram of the recorded audio, providing a visual representation of the sound.

The project is built using **Kotlin** and **Java**, and it relies on **TensorFlow Lite** for running the machine learning models on-device.

## 2. Project Architecture

The whoBIRD application follows a standard Android architecture, with a clear separation of concerns between the user interface (Activities), core logic, and data persistence.

The main components are:

- **Activities (UI Layer):** These are the screens that the user interacts with. Each activity has a specific role, such as displaying the main interface, showing the observation history, or managing settings.
- **SoundClassifier (Core Logic):** This is the central class that orchestrates the entire bird sound identification process. It manages audio recording, preprocessing, model inference, and result handling.
- **TensorFlow Lite Models (Machine Learning):** The project uses two TFLite models:
    1.  `model.tflite`: The primary BirdNET model that classifies bird sounds.
    2.  `metaModel.tflite`: A secondary model that uses location and time data to refine the predictions.
- **BirdDBHelper (Data Persistence):** This is a SQLite database helper class that manages the storage of bird observation data.
- **Utility Classes:** Several helper classes are used for tasks such as downloading models (`Downloader`), handling location (`LocationHelper`), and generating spectrograms (`MelSpectrogram`).

## 3. Key Components and Code Logic

### 3.1. Initial Setup: `DownloadActivity.kt` & `Downloader.java`

- **Purpose:** This is the entry point of the application. Its primary responsibility is to ensure that the required TFLite models are downloaded and available before the main application can start.
- **Logic:**
    1.  On startup, `DownloadActivity` checks for the existence of `model.tflite` and `metaModel.tflite` using `Downloader.checkModels()`.
    2.  The `checkModels()` method verifies the files and their MD5 checksums to ensure they are not corrupted.
    3.  If the models are present and valid, `MainActivity` is launched immediately.
    4.  If the models are missing or invalid, the user is prompted to download them. The `Downloader.downloadModels()` method fetches the files from a GitHub repository in a background thread, updating a progress bar on the UI.
    5.  Once the download is complete, the user can proceed to the main application.

### 3.2. Main Screen & Audio Processing: `MainActivity.kt` & `SoundClassifier.kt`

- **Purpose:** `MainActivity` is the main screen where the real-time analysis occurs. `SoundClassifier` is the class that contains the core logic for this process.
- **`MainActivity.kt` Logic:**
    - It initializes the `SoundClassifier` and handles UI elements like the record/pause button, navigation, and the WebView for displaying bird images.
    - It manages Android permissions for `RECORD_AUDIO` and `ACCESS_LOCATION`.
    - It starts and stops the `SoundClassifier` and `LocationHelper` based on the activity's lifecycle (`onResume`, `onPause`).
- **`SoundClassifier.kt` Logic (The Core Workflow):**
    1.  **Audio Recording:** It uses `AudioRecord` to continuously capture audio from the device's microphone in a background timer task (`scheduleAtFixedRate`). The audio is stored in a circular buffer to maintain a rolling 3-second window of sound.
    2.  **Preprocessing:** An optional Butterworth high-pass filter can be applied to the audio to reduce low-frequency noise (e.g., wind, traffic).
    3.  **Main Model Inference:** The 3-second audio sample is fed into the primary BirdNET TFLite model (`interpreter.run()`). The model outputs an array of probabilities, one for each of the 6,000+ bird species.
    4.  **Meta Model Inference:**
        - The device's current latitude, longitude, and the week of the year are used as input for the `metaModel.tflite`.
        - This model outputs a probability score for each species, indicating how likely it is to be found at that specific location and time.
    5.  **Result Combination:** The output from the main model is combined with the output from the meta-model using a weighted average. This significantly improves accuracy by down-weighting predictions for birds that are geographically or seasonally out of place. The user can adjust the influence of the meta-model in the settings.
    6.  **Display Results:** The top two bird species with the highest combined probability are displayed on the UI. The background color of the result indicates the confidence level. If the confidence is high enough and the feature is enabled, an image of the bird is loaded from the Macaulay Library into a WebView.
    7.  **Data Storage:** Detections that exceed a certain probability threshold are saved to the local SQLite database via `BirdDBHelper`.

### 3.3. Spectrogram Visualization: `MelSpectrogram.java`

- **Purpose:** This class is responsible for converting a raw audio buffer into a mel spectrogram image.
- **Logic:**
    1.  **Downsampling:** The audio is first downsampled from 48kHz to 24kHz.
    2.  **STFT:** It performs a Short-Time Fourier Transform (STFT) to analyze the frequency content of the audio over time. This is done in parallel using multiple threads to improve performance.
    3.  **Mel Scale:** The resulting frequencies are converted to the mel scale, which better reflects human hearing.
    4.  **Bitmap Creation:** The final mel spectrogram data is rendered into a `Bitmap` object, which is then displayed on the main screen.

### 3.4. Observation History: `ViewActivity.kt`

- **Purpose:** This screen displays the list of all past bird detections.
- **Logic:**
    - It retrieves all bird observations from the database using `BirdDBHelper.getAllBirdObservations()`.
    - The observations are displayed in a `RecyclerView`.
    - Users can tap on an observation to play back the recorded sound and view the bird's image.
    - It provides options to share individual detections, share the entire database as a CSV file, or delete all data.

### 3.5. Data Persistence: `BirdDBHelper.java`

- **Purpose:** This class manages the application's SQLite database.
- **Schema:** It defines a single table, `BirdObservations`, with columns for:
    - `ID` (Primary Key)
    - `TimeInMillis`
    - `Latitude`
    - `Longitude`
    - `SpeciesName`
    - `BirdNET_ID`
    - `Probability`
- **Logic:** It provides standard database operations: adding new entries, retrieving all entries, and clearing the database. It is implemented as a singleton to ensure a single point of access to the database.