import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:./sport/system/storage.dart';
import 'package:./sport/system/extension.dart';
import 'package:sport/system/tts.dart';

class Clock extends StatefulWidget {
  // Clock({Key? key}) : super(key: key){
  // }
  @override
  _ClockState createState() => _ClockState();
}
class _ClockState extends State<Clock> {
  final methodChannel = const MethodChannel('com.flutter/MethodChannel');
  TTS tts = TTS();
  Timer? _timer;
  int _count = 0, sec = 5;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
       try {
        await tts.initial();
        count();
      } catch (e) {
        
      // } finally {
      }
      
    });
  }

  void count() {
    _timer = setInterval(() {
      _count += sec;
      tts.speak("${_count}");
      print("timer: ${_count}," + DateTime.now().format());

    }, Duration(seconds: sec));

    
  }

  Timer setInterval(void Function() callback, Duration interval) {
    return Timer.periodic(interval, (Timer timer) {
      callback();
    });
  }
  
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
  }

  @override
  dispose() {
    super.dispose();
    _timer!.cancel();
  }
  @override
  void reassemble() async {
    super.reassemble();
  }

  void didChangeAppLifecycleState(AppLifecycleState state)  {
  }

  void backTo() async {
    Navigator.of(context).pop(); 
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_sharp,
              color: Colors.white,
            ),
            onPressed: () => backTo(),
          ),
          title: const Text('碼錶',
            style: TextStyle( color:Colors.white,)
          ),
          // actions: [
          //   IconButton( icon: Icon( Icons.menu, color: Colors.white),
          //     onPressed: () {
          //       setup();
          //     },
          //   )
          // ],
          backgroundColor: Colors.blue, 
        ),
        body:
          PopScope(
              canPop: false,
              onPopInvoked: (bool didPop) {
                if (didPop) {
                  return;
                }
                backTo();
              },
              child: body(),
            ),
      )
    );
  }

  Widget body() {
    return Container();
  }
}

