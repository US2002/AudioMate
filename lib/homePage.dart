import 'dart:io';

// import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'AudioManager.dart';
import 'api_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //! Audio Manager
  //! BASE URL HERE
  ApiManager apiManager = ApiManager(
      url:
          'https://eeec-2405-201-6804-11cd-4026-ed0c-f6df-6ec0.ngrok-free.app');

  AudioManager audioManager = AudioManager();

  //! Controllers
  RecorderController controller = RecorderController();
  FlutterTts flutterTts = FlutterTts();

  //! Booleans
  bool isPlaying = false;
  bool isRecording = false;

  //! Response and Files
  String? path;
  String response = "Hey there! I'm your friendly voice companion.";

  @override
  void dispose() {
    audioManager.dispose();
    controller.dispose();
    super.dispose();
  }

  Widget audioWaveform() {
    return AudioWaveforms(
      enableGesture: true,
      size: Size(MediaQuery.of(context).size.width, 80),
      recorderController: controller,
      waveStyle: const WaveStyle(
        waveColor: Colors.white,
        extendWaveform: true,
        showMiddleLine: false,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.teal.withOpacity(0.5),
      ),
      padding: const EdgeInsets.all(5),
      // margin: const EdgeInsets.symmetric(horizontal: 15),
    );
  }

  Future<void> uploadAudio(String filePath) async {
    File audioFile = File(filePath);
    try {
      await apiManager.sendAudio(audioFile);
      await Future.delayed(const Duration(seconds: 2));
      // print("Now Getting AI response!!");
      getReplies();
    } catch (e) {
      // print('Failed to upload audio: $e');
      setState(() {
        response = 'Failed to upload audio: $e';
        reset();
      });
    }
  }

  Future<void> getReplies() async {
    try {
      String result = await apiManager.getReplyText();
      // print(result);
      setState(() {
        response = result;
      });
      _speak();
    } catch (e) {
      setState(() {
        response = 'Getting AI response $e';
        reset();
      });
    }
  }

  void toggleRecording() async {
    if (isRecording) {
      //!Controllers only
      controller.stop();
      controller.reset();

      //Everything else
      // response = "Stopped Recording, Sending Data to AI";
      final filePath = await audioManager.stopRecording();
      if (filePath != null) {
        // print(filePath);
        setState(() {
          response = "Getting response from assistant";
          isPlaying = true;
          path = filePath;
          uploadAudio(filePath);
        });
      }
    } else {
      //! Controllers only
      controller.record();

      //Everything else
      response = "Listening Closely...";
      audioManager.startRecording();
    }
    setState(() {
      isRecording = !isRecording;
      // print("ISRECORDING changed to: $isRecording");
    });
  }

  Widget buildButton() {
    return GestureDetector(
      onTap: () {
        toggleRecording();
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 4,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(
              scale: animation,
              child: child,
            );
          },
          child: Icon(
            isRecording ? Icons.stop : Icons.mic,
            size: 40,
            color: Colors.teal.withOpacity(0.8),
          ),
        ),
      ),
    );
  }

  Widget loadingIcon() {
    return Center(child: Image.asset('assets/Loading.gif'));
  }

  void initSetting() async {
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setLanguage("en-US");
  }

  Future<void> reset() async {
    setState(() {
      isPlaying = false;
      response = "Hey there! I'm your friendly voice companion.";
    });
  }

  void _speak() async {
    initSetting();
    await flutterTts.speak(response);
    await flutterTts.awaitSpeakCompletion(true);
    await Future.delayed(const Duration(seconds: 3));
    reset();
  }

  Widget _buildLoadingTray() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 100.0,
        width: double.infinity,
        child: Center(
          child: audioWaveform(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'VOICE ASSISTANT',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal.withOpacity(0.5),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  isPlaying ? loadingIcon() : buildButton(),
                  const SizedBox(height: 50),
                  SizedBox(
                    height: 100, // Set the maximum height you desire
                    width: double.infinity,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: SingleChildScrollView(
                        reverse: true,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Center(
                            child: Text(
                              response,
                              textAlign:
                                  TextAlign.center, // Align text in the center
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ), // Adjust speed as needed
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          isRecording ? _buildLoadingTray() : const SizedBox(height: 100),
        ],
      ),
    );
  }
}
