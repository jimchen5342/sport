import 'package:flutter/material.dart';
import 'package:./sport/swing.dart';
import 'package:./sport/system/storage.dart';
import 'package:./sport/system/alert.dart';
import 'package:package_info_plus/package_info_plus.dart';

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
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
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
  int active = -1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // await Storage.clear();
      list = await Storage.getJSON("swing");
      setState(() {});
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
          //   icon: const Icon( Icons.arrow_back_ios_sharp, color: Colors.white ),
          //   onPressed: () => Navigator.pop(context),
          // ),
          title: const Text('運動', style: TextStyle( color:Colors.white,) ),
          actions: [
            IconButton( icon: Icon( Icons.menu, color: Colors.white),
              onPressed: () {
                showInfo();
              },
            )
          ],
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
                itemExtent: 60.0, //强制高度为50.0
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: ()  {
                      active = index;
                      setState(() {
                        remove(index);
                      });                      
                    },
                    onLongPress: (){

                    }, 
                    child: rowRender(index)
                  );
                }
              )
            ),
            SizedBox(height: 10,),
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
                    onPressed:() async {
                      bool dirty = await Navigator.of(context).pushNamed('/swing') as bool;
                      if(dirty) {
                        list = await Storage.getJSON("swing");
                        setState(() {});
                      }
                    }
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void remove(index) {
    alert(context, '確定刪除資料？', btns: [
      TextButton(
        child: Text('確定'),
        onPressed: () async {
          list.removeAt(index);
          await Storage.setJSON("swing", list);
          active = -1;
          setState(() {});
          Navigator.of(context).pop();
        },
      ),
      TextButton(
        child: Text('取消'),
        onPressed: () {
          active = -1;
          setState(() {});
          Navigator.of(context).pop();
        },
      )
    ]);
  }

  showInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    alert(context, "Version Name:\n" + version + "");
  }

  Widget rowRender(int index) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.5, color: Colors.grey.shade300),
        ),
        color: active == index ? Colors.blue.shade100 : Colors.transparent
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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("日期：" + list[index]["date"],
                style: const TextStyle(
                  fontSize: 16
                ),  
                // textAlign: TextAlign.center,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 Text("左：" + list[index]["left"].toString(),
                    style: const TextStyle(
                      fontSize: 16
                    )
                  ),
                  SizedBox(width: 40),
                  Text("右：" + list[index]["right"].toString(),
                      style: const TextStyle(
                        fontSize: 16
                      )
                    )
                ]
              )
            ]
          )
        ]
      ),
    );
  }
}