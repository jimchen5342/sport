import 'package:text_to_speech/text_to_speech.dart';

// zh-TW, en-US

// https://www.jianshu.com/p/8d86ba3b423a
// https://pub.dev/packages/flutter_tts/example
// https://pub.dev/packages/text_to_speech/install

class TextToSpseech {
  TextToSpeech tts = TextToSpeech();
  double volume = 1; // Range: 0-1
  double rate = 1.0; // Range: 0-2
  double pitch = 1.0; // Range: 0-2
  String? language;
  String? languageCode;
  List<String> languages = <String>[];
  List<String> languageCodes = <String>[];
  String? voice;


  Future<void> initial() async {
    /// populate lang code (i.e. en-US)
    languageCodes = await tts.getLanguages();

    /// populate displayed language (i.e. English)
    final List<String>? displayLanguages = await tts.getDisplayLanguages();
    if (displayLanguages == null) {
      return;
    }

    languages.clear();
    for (final dynamic lang in displayLanguages) {
      languages.add(lang as String);
    }

    final String? defaultLangCode = "en-US"; // await tts.getDefaultLanguage();
    
    language = await tts.getDisplayLanguageByCode(languageCode!);

    // voice = await getVoiceByLang(languageCode!);


  }


  Future speak(String text) async {
    // tts.setVolume(1);  
    // String text = "Hello, Good Morning!";  
    // tts.speak(text);  
  }
}
