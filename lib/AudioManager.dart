import 'fileManager.dart';
import 'package:flutter_sound/flutter_sound.dart';

class AudioManager {
  FlutterSoundRecorder recorder = FlutterSoundRecorder();
  FileManager fileManager = FileManager();

  AudioManager() {
    recorder.openRecorder();
    recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
  }

  Future<void> startRecording() async {
    await recorder.startRecorder(toFile: "audio");
    // print("RECORDING STARTED!!!!!!!!!!!");
  }

  Future<String?> stopRecording() async {
    final filePath = await recorder.stopRecorder();
    //! TO SAVE FILE LOCALLY
    // await fileManager.saveFile(filePath!);
    // print("RECORDING STOPPED and SAVED!!!!!!!!!!!");
    return filePath;
  }

  void dispose() {
    recorder.closeRecorder();
  }
}
