# whoBIRD File and Directory Overview

This document provides a detailed overview of the files and directories within the whoBIRD project. It is intended to help developers navigate the codebase and understand the purpose of each component.

## Root Directory

-   **`CODEBASE_ANALYSIS.md`**: A detailed document explaining the project's architecture and overall code logic.
-   **`LICENSE`**: The license file for the project (GPLv3).
-   **`README.md`**: The main README file, providing a general overview of the application, its features, and instructions for users.
-   **`build.gradle`**: The top-level Gradle build file for the entire project. It defines project-wide configurations and dependencies.
-   **`settings.gradle`**: The Gradle settings file that includes the `app` module in the project build.
-   **`gradlew` & `gradlew.bat`**: The Gradle wrapper scripts for Unix-based systems and Windows, respectively. They allow the project to be built with a specific version of Gradle without requiring a system-wide installation.
-   **`gradle/`**: This directory contains the Gradle wrapper JAR file (`gradle-wrapper.jar`), which is used by the `gradlew` scripts.
-   **`fastlane/`**: This directory contains metadata for automated app store deployments using the Fastlane tool. It includes localized descriptions, screenshots, and changelogs.
-   **`misc/`**: Contains miscellaneous image files.
-   **`preview.jpeg` & `demo.mp4`**: A preview image and a video demonstrating the application.

## `/app` Directory (The Main Application Module)

This directory contains the source code and resources for the whoBIRD Android application itself.

-   **`build.gradle`**: The module-level Gradle build file. It specifies dependencies, build configurations, and settings specific to the Android app.
-   **`proguard-rules.pro`**: Configuration file for ProGuard, which is used to shrink, obfuscate, and optimize the application's code.

### `/app/src/main`

This is the main source set for the application.

-   **`AndroidManifest.xml`**: The core manifest file for the Android application. It declares the app's components (activities, services), required permissions (e.g., audio recording, location), and other essential information.

#### `/app/src/main/assets`

This directory contains raw asset files that are bundled with the application.

-   **`labels_*.txt`**: A series of text files containing the names of the bird species supported by the BirdNET model, localized into various languages.
-   **`assets.txt`**: A list of asset IDs from the Macaulay Library, used to fetch bird images.
-   **`taxo_code.txt`**: A list of eBird taxonomy codes, used to link to the eBird website for more information about a species.

#### `/app/src/main/java/org/tensorflow/lite/examples/soundclassifier`

This directory contains all the Java and Kotlin source code for the application.

-   **`BaseActivity.java`**: A base activity class that other activities in the app extend from. (Functionality not specified in the provided code, but likely contains common setup or utility methods).
-   **`DownloadActivity.kt`**: The first activity the user sees. It handles the download and verification of the TFLite models.
-   **`Downloader.java`**: A helper class that performs the actual download of the models from a remote server.
-   **`MainActivity.kt`**: The main screen of the application. It orchestrates the audio recording, classification, and display of results.
-   **`SoundClassifier.kt`**: The core class of the application. It manages the `AudioRecord` instance, processes the audio, runs inference with the TFLite models, and interprets the results.
-   **`MelSpectrogram.java`**: A utility class that converts raw audio data into a visual mel spectrogram image.
-   **`ViewActivity.kt`**: The activity that displays the history of bird observations stored in the local database.
-   **`BirdInfoActivity.kt`**: An activity that displays a list of all bird species supported by the app, allowing users to search for specific birds.
-   **`SettingsActivity.java`**: The activity that displays and manages the application's settings.
-   **`BirdDBHelper.java`**: A SQLite helper class for creating and managing the local database where bird observations are stored.
-   **`BirdObservation.java`**: A data class representing a single bird observation record.
-   **`LocationHelper.java`**: A helper class for managing location updates.
-   **`WavUtils.java`**: A utility class for creating and playing `.wav` audio files.
-   **`MlWebViewClient.kt`**: A custom `WebViewClient` for handling the display of web content (bird images).
-   **`Recycler...` classes**: Adapter classes used by `RecyclerView` to display lists of data (e.g., observations, bird info).

#### `/app/src/main/res`

This directory contains all the non-code resources for the application.

-   **`drawable/`**: Contains all the drawable resources, such as icons, button backgrounds, and other graphics.
-   **`layout/`**: Contains the XML layout files that define the user interface for each activity.
-   **`menu/`**: Contains the XML files that define the contents of menus (e.g., the bottom navigation bar).
-   **`mipmap/`**: Contains the application's launcher icons for different screen densities.
-   **`raw/`**: Contains raw resource files, such as the notification sound.
-   **`values/`**: Contains XML files that define static values, such as strings (`strings.xml`), colors (`colors.xml`), styles (`styles.xml`), and arrays (`arrays.xml`).
-   **`values-*/`**: A series of directories containing localized string resources for different languages.
-   **`xml/`**: Contains XML resource files, such as the preferences screen definition (`root_preferences.xml`).