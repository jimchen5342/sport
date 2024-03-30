import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_sensors/flutter_sensors.dart';
import 'package:sport/system/tts.dart';
import 'package:./sport/system/storage.dart';

class Swing extends StatefulWidget {
  // Swing({Key? key}) : super(key: key){
  // }
  @override
  _SwingState createState() => _SwingState();
}
class _SwingState extends State<Swing> {
  bool _accelAvailable = false;
  StreamSubscription? _accelSubscription;
  int swingCount = 0;
  int mAccelerationStand = 20, mAcceleration = 0, 
    mShakeTimeStand = 800, mShakeTimestamp = 0;
  TTS tts = TTS();
  String recorders = "", direction = "", mode = "left";
  var dirty = false;
  var recorder = {"date": "", "left": 0, "right": 0};
  List<dynamic> list = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      list = await Storage.getJSON("swing");
      var curr = DateTime.now();
      var today = "$curr".substring(0, 10);
      if(list.length > 0 && list[0]["date"] == today) {
        recorder["left"] = list[0]["left"] as int;
        recorder["right"] = list[0]["right"] as int;
      } else {
        recorder["date"] = today;
        list.insert(0, recorder);
      }

      try {
        await tts.initial();
        // tts.count();
      } catch (e) {
        debugPrint(e.toString());
      } finally {
        _checkAccelerometerStatus();
      }
    });
  }
  
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
  }

  @override
  dispose() {
    _stopAccelerometer();
    super.dispose();
  }
  @override
  void reassemble() async {
    super.reassemble();
  }

  void didChangeAppLifecycleState(AppLifecycleState state)  {
  }

  void _checkAccelerometerStatus() async {
    await SensorManager()
      .isSensorAvailable(Sensors.ACCELEROMETER)
      .then((result) async {
        setState(() {
          _accelAvailable = result;
        });
      }
    );
  }

  Future<void> _startAccelerometer() async {
    if (_accelSubscription != null) return;
    if (_accelAvailable) {
      swingCount = 0;
      recorders = "";
      final stream = await SensorManager().sensorUpdates(
        sensorId: Sensors.ACCELEROMETER,
        interval: Sensors.SENSOR_DELAY_UI, //  Sensors.SENSOR_DELAY_FASTEST,
      );
      _accelSubscription = stream.listen((sensorEvent) {
        setState(() {
          onSensorChanged(sensorEvent.data);
        });
      });
    }
  }

  void onSensorChanged(List<double> event) {
    double x = event[0];
    double y = event[1];
    double z = event[2];
    int xyz = sqrt(x*x + y*y + z*z).ceil();

    if (xyz > mAcceleration) { // 往上方向
      if(mAcceleration > mAccelerationStand && direction != "上" ) {
        int now = DateTime.now().millisecondsSinceEpoch;
        if (mShakeTimestamp + mShakeTimeStand < now) {
          swingCount++;
          // if(swingCount % 5 == 0) {
            tts.speak(swingCount.toString());
          // }
          var curr = DateTime.now();
          var time = "$curr".substring(11, 23);
          recorders = swingCount.toString() + ". " + time + ": " + mAcceleration.toString() 
            + (recorders.isNotEmpty ? "\n" : "") + recorders;
          mShakeTimestamp = now;
        }
        direction = "上";
      }
    } else {
      direction = "";
    }
    mAcceleration = xyz;
  }

  void _stopAccelerometer() {
    if (_accelSubscription == null) return;
    _accelSubscription?.cancel();
    _accelSubscription = null;
    mAcceleration = 0;
    setState(() {});
  }

  void quit() async {
    if(mAcceleration == 0) {
      Navigator.of(context).pop(dirty); 
    }
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
            onPressed: () => quit(),
          ),
          title: const Text('擺手偵測',
            style: TextStyle( color:Colors.white,)
          ),
          // actions: [Text("First action")],
          backgroundColor: Colors.blue, 
        ),
        body: // body()
          PopScope(
              canPop: false,
              onPopInvoked: (bool didPop) {
                if (didPop) {
                  return;
                }
                quit();
              },
              child: body(),
            ),
      )
    );
  }

  Widget body() {
    return Container(
      padding: const EdgeInsets.all(10.0),
      alignment: AlignmentDirectional.topCenter,
      child: Column(
        children: <Widget>[
          // Text(
          //   "mAcceleration：${mAcceleration}",
          //   style: const TextStyle(
          //     // color:Colors.white,
          //     fontSize: 20
          //   ),
          //   textAlign: TextAlign.center,
          // ),
          Expanded(
            flex: 1, 
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              width: double.infinity,
              padding: EdgeInsets.all(5.0),
              child: SingleChildScrollView(child: 
                Text(recorders,
                  style: const TextStyle(
                    fontSize: 16
                  ),  
                  maxLines: 300,
                  textAlign: TextAlign.center,
                ),
              )
            ),  
          ),
          const Padding(padding: EdgeInsets.only(top: 5.0)),
          if(_accelAvailable == true)
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "次數：${swingCount}",
                  style: const TextStyle(
                    // color:Colors.white,
                    fontSize: 20
                  ),
                  textAlign: TextAlign.center,
                ),
                Expanded( flex: 1,  child: Container() ),
                if(mAcceleration == 0 )
                  MaterialButton(
                    padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                    child: Text("左",
                      style: TextStyle(
                        color:Colors.white,
                        fontSize: 18
                      )
                    ),
                    color: Colors.green,
                    onPressed:() {
                       if(_accelAvailable) {
                        tts.speak("start");
                        mode = "left";
                        _startAccelerometer();
                       }
                    }
                  ),
                if(mAcceleration == 0 )
                  SizedBox(width: 10,),
                if(mAcceleration == 0 )
                  MaterialButton(
                    padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                    child: Text("右",
                      style: TextStyle(
                        color:Colors.white,
                        fontSize: 18
                      )
                    ),
                    color: Colors.green,
                    onPressed:() {
                       if(_accelAvailable) {
                        tts.speak("start");
                        mode = "right";
                        _startAccelerometer();
                       }
                    }
                  ),
                if(mAcceleration > 0 ) 
                  MaterialButton(
                    padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 30.0),
                    child: Text("結束",
                      style: TextStyle(
                        color:Colors.white,
                        fontSize: 18
                      )
                    ),
                    color: Colors.red,
                    onPressed:() async {
                       if(_accelAvailable) {
                        if(swingCount > 0) {
                          dirty = true;
                          int num = recorder[mode] as int;
                          recorder[mode] = swingCount + num;
                          await Storage.setJSON("swing", list);
                        }
                        tts.speak("stop");
                        _stopAccelerometer();
                       }
                    }
                  ),
              ],
            ),
          // Padding(padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),),
        ],
      ),
    );
  }
}