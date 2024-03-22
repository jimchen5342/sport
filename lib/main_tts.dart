import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:./sport/tts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TTS tts = TTS(); 

  @override
  void initState() {
    super.initState();
  
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      await tts.initial();
    });
  }

  speak() {
    tts.speak("");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Text-to-Speech Example'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                children: <Widget>[
                
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(right: 10),
                          child: ElevatedButton(
                            child: const Text('Stop'),
                            onPressed: () {
                              // tts.stop();
                            },
                          ),
                        ),
                      ),
                      Expanded(
                          child: Container(
                        child: ElevatedButton(
                          child: const Text('Speak'),
                          onPressed: () {
                            speak();
                          },
                        ),
                      ))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}