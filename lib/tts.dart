import 'package:text_to_speech/text_to_speech.dart';
// zh-TW, en-US
// https://pub.dev/packages/text_to_speech/install

class TTS {
  TextToSpeech tts = TextToSpeech();

  Future<void> initial() async {
    /// populate lang code (i.e. en-US)
    tts.setLanguage("en-US");
  }



  Future speak(String text) async {
    // tts.setVolume(1);  
    // String text = "Hello, Good Morning!";  
    // tts.speak(text);

    for(var i = 0; i < 100; i++) {
       tts.speak(i.toString());
      await waitTask();
    }
  }

  Future waitTask() async {
    await Future.delayed(const Duration(seconds: 1));
    return;
  }
}
