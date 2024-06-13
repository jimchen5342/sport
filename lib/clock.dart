import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sensors/flutter_sensors.dart';
import 'package:sport/system/tts.dart';
import 'package:./sport/system/storage.dart';
import 'package:./sport/swingSetup.dart';

class Clock extends StatefulWidget {
  // Clock({Key? key}) : super(key: key){
  // }
  @override
  _ClockState createState() => _ClockState();
}
class _ClockState extends State<Clock> {
  final methodChannel = const MethodChannel('com.flutter/MethodChannel');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      
    });
  }
  
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
  }

  @override
  dispose() {
    super.dispose();
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

