# Voice Assistant App

## Description

This Flutter-based Voice Assistant app allows users to interact with an AI-powered assistant through voice commands. The app provides functionalities for recording voice, processing audio, and fetching responses from an API.

## Features

- **Permission Handling**: The app requests microphone permissions and navigates to the home page if granted, ensuring a seamless user experience.
- **Audio Recording**: Users can start/stop recording their voice, which triggers AI response processing.
- **API Communication**: The app communicates with an API to send recorded audio and fetch AI-generated responses.

## File Structure

- `main.dart`: Contains the main entry point of the app, setting up the UI and navigation.
- `permissionChecker.dart`: Manages permission checks and navigation flow based on permission status.
- `homePage.dart`: Defines the home page UI, recording functionality, and interaction with the API.
- `AudioManager.dart`: Handles audio recording functionalities using Flutter Sound library.
- `apiHandler.dart`: Manages API communication for sending audio and fetching AI-generated responses.

## Usage

1. **Setup**: Ensure Flutter environment is set up.
2. **Dependencies**: Install required packages using `flutter pub get`.
3. **Run**: Launch the app on an emulator or physical device using `flutter run`.

## Dependencies

- `flutter`: The core Flutter framework.
- `permission_handler`: Manages permissions for accessing the device's microphone.
- `shared_preferences`: Used for storing app state (e.g., if it's the first time using the app).
- `flutter_tts`: Enables text-to-speech functionality.
- `audio_waveforms`: Renders audio waveforms in the UI.
- `http`: Handles HTTP requests for API communication.
- `flutter_sound`: Provides audio recording capabilities.

## How to Contribute

1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Make changes and submit a pull request.

## Authors

- [Ujjawal Soni/DIT University](https://github.com/us2002)
