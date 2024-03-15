import 'package:text_to_speech/text_to_speech.dart';
// zh-TW, en-US

// https://www.jianshu.com/p/8d86ba3b423a
// https://pub.dev/packages/flutter_tts/example
// https://pub.dev/packages/text_to_speech/install

class TextToSpseech {
  TextToSpeech tts = TextToSpeech(); 

  // TextToSpseech() {
    
  // }

  Future speak(String text) async {
    String text = "Hello, Good Morning!";  
    tts.speak(text);  
  }
}
