import 'package:flutter/material.dart';
import 'dart:ui'; 

class Swing extends StatefulWidget {
  // Swing({Key? key}) : super(key: key){

  // }

  @override
  _SwingState createState() => _SwingState();
}


class _SwingState extends State<Swing> {
  @override
  void initState() {
    super.initState();

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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state)  {
  }


  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_sharp,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text('擺手偵測'),
          actions: [],
        ),
        body: Container()
        
      )
    );
  }

}