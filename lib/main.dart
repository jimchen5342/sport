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

class _HomePageState extends State<_HomePage> {
  List<dynamic> list = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      // await Storage.clear();
      list = await Storage.getJSON("swing");
      // list.add({"date": "2024-03-20", "left": 1, "right": 1});
      // list.insert(0, {"date": "2024-03-10", "left": 11, "right": 11});
      // list.add({"date": "2024-03-20", "left": 1, "right": 1});
      // list.insert(0, {"date": "2024-03-10", "left": 11, "right": 11});
      // list.add({"date": "2024-03-20", "left": 1, "right": 1});
      // list.insert(0, {"date": "2024-03-10", "left": 11, "right": 11});
      // list.add({"date": "2024-03-20", "left": 1, "right": 1});
      // list.insert(0, {"date": "2024-03-10", "left": 11, "right": 11});
      // list.add({"date": "2024-03-20", "left": 1, "right": 1});
      // list.insert(0, {"date": "2024-03-10", "left": 11, "right": 11});
      // list.add({"date": "2024-03-20", "left": 1, "right": 1});
      // list.insert(0, {"date": "2024-03-10", "left": 11, "right": 11});
      // await Storage.setJSON("swing", list);

      setState(() {});
      // print(list);
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
      body: Container(
        padding: EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1, 
              child: ListView.builder(
                itemCount: list.length,
                itemExtent: 50.0, //强制高度为50.0
                itemBuilder: (BuildContext context, int index) {
                  return rowRender(index); // ListTile(title: Text("$index"));
                }
              )
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                  MaterialButton(
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
                    child:  Text("運動",
                      style: TextStyle(
                        color:Colors.white,
                        fontSize: 18
                      )
                    ),
                    color: Colors.blue,
                    onPressed:() {
                       Navigator.of(context).pushNamed('/swing');
                    }
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget rowRender(int index) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      child: Row(
        children: [
          SizedBox(width: 25,
            child: Text((index + 1).toString(),
            style: const TextStyle(
              fontSize: 16
            ),  
            // textAlign: TextAlign.center,
          ),
          ),
          Column(
            children: [
              Text("日期：" + list[index]["date"],
                style: const TextStyle(
                  fontSize: 16
                ),  
                // textAlign: TextAlign.center,
              ),
              Row(
                children: [
                  Expanded( flex: 1,  
                    child: Text("左：" + list[index]["left"].toString(),
                      style: const TextStyle(
                        fontSize: 16
                      )
                    )
                  ),
                  Expanded( flex: 1,  
                    child: Text("右：" + list[index]["right"].toString(),
                      style: const TextStyle(
                        fontSize: 16
                      )
                    )
                  ),
                ]
              )
            ]
          )
        ]
      ),
    );
  }
}