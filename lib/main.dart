import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:./sport/swing.dart';
import 'package:./sport/system/storage.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  //  Navigator.of(context).pushNamed('/two');
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        // debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/home',
        routes: <String, WidgetBuilder>{
          '/home': (BuildContext context) => _HomePage(),
          '/swing': (BuildContext context) => Swing(),
        },
        // home: Scaffold(
        //   body: Swing(),
        // ),
      )
    );
  }
}

class _HomePage extends StatefulWidget {
  const _HomePage();
 
  @override
  State<_HomePage> createState() => _HomePageState();
}

// 
class _HomePageState extends State<_HomePage> {
  List<dynamic> list = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      // await Storage.clear();
      list = await Storage.getJSON("swing");
    });
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // leading: IconButton(
          //   icon: const Icon(
          //     Icons.arrow_back_ios_sharp,
          //     color: Colors.white,
          //   ),
          //   onPressed: () => Navigator.pop(context),
          // ),
          title: const Text('運動', style: TextStyle( color:Colors.white,) ),
          // actions: [Text("First action")],
          backgroundColor: Colors.blue, 
        ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/swing');
              },
              child: const Text('Next page'),
            ),
          ],
        ),
      ),
    );
  }
}