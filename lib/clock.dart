import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:./sport/system/extension.dart';
import 'package:sport/system/tts.dart';

class Clock extends StatefulWidget {
  // Clock({Key? key}) : super(key: key){ }
  @override
  _ClockState createState() => _ClockState();
}
class _ClockState extends State<Clock> {
  final methodChannel = const MethodChannel('com.flutter/MethodChannel');
  TTS tts = TTS();
  Timer? _timer;
  int sec = 30;
  List<String> list = [];
  DateTime old = DateTime.now();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
       try {
        await tts.initial();
        count();
        // BackgroundService.setToBackground();
      } catch (e) {
        
      // } finally {
      }

    });


  }

  void count() {
    _timer = setInterval(() {
      var now = DateTime.now();

      if(now.format(pattern: "HH:mm") != old.format(pattern: "HH:mm")) {
        tts.speak(now.format(pattern: "HH:mm"));
      }
    
      list.insert(0, "時間：${now.format(pattern: "HH:mm:ss")}, 差距：${now.difference(old).inSeconds}");

      old = now;
      setState(() { });
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
        body: PopScope(
          canPop: false,
          onPopInvoked: (bool didPop) {
            if (didPop) {
              return;
            }
            backTo();
          },
          child: body(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          child: const Icon(Icons.add),
        ),
        
      )
    );
  }

  Widget body() {
    return Container(
        padding: const EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1, 
              child: ListView.builder(
                itemCount: list.length,
                itemExtent: 40.0, //强制高度
                itemBuilder: (BuildContext context, int index) {
                  return Text(list[index]);
                }
              )
            ),
          ],
        ),
      );
  }

}

