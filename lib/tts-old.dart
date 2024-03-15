import 'package:flutter_tts/flutter_tts.dart';
// zh-TW, en-US

// https://www.jianshu.com/p/8d86ba3b423a
// https://pub.dev/packages/flutter_tts/example
// https://pub.dev/packages/text_to_speech/install

class TextToSpseech {
  late FlutterTts flutterTts;
  
  TextToSpseech() {
    flutterTts = FlutterTts();

    flutterTts.setStartHandler(() {
      // setState(() {
        print("Playing");
      //   ttsState = TtsState.playing;
      // });
    });

    flutterTts.setInitHandler(() {
      // setState(() {
        print("TTS Initialized");
      // });
    });

    flutterTts.setCompletionHandler(() {
      // setState(() {
        print("Complete");
      //   ttsState = TtsState.stopped;
      // });
    });

    flutterTts.setCancelHandler(() {
      // setState(() {
      //   print("Cancel");
      //   ttsState = TtsState.stopped;
      // });
    });

    flutterTts.setPauseHandler(() {
      // setState(() {
      //   print("Paused");
      //   ttsState = TtsState.paused;
      // });
    });

    flutterTts.setContinueHandler(() {
      // setState(() {
      //   print("Continued");
      //   ttsState = TtsState.continued;
      // });
    });

    flutterTts.setErrorHandler((msg) {
      // setState(() {
        print("error: $msg");
      //   // ttsState = TtsState.stopped;
      // });
    });
  }

  Future speak(String text) async {
    await flutterTts.setLanguage("zh-CN"); /// 设置语言
    await flutterTts.setVolume(0.8); /// 设置音量
    await flutterTts.setSpeechRate(0.5); /// 设置语速
    await flutterTts.setPitch(1.0); /// 音调

    text = "你好，我的名字是李磊，你是不是韩梅梅？";
    if (text.isNotEmpty) {
      await flutterTts.speak(text);
    }
  }

  /// 暂停
  Future _pause() async {
    await flutterTts.pause();
  }

  /// 结束
  Future _stop() async {
    await flutterTts.stop();
  }
}
