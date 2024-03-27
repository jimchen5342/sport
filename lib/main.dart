import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_sensors/flutter_sensors.dart';
import 'package:./sport/tts.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _accelAvailable = false;
  List<double> _accelData = List.filled(3, 0.0);
  StreamSubscription? _accelSubscription;
  int swingCount = 0;
  int acceleration = 0;
  int mShakeTimeSpan = 800;
  int mShakeTimestamp = 0;
  TTS tts = TTS();

  String recorders = "", direction = "";
  
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((_) async {
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
  void dispose() {
    _stopAccelerometer();
    super.dispose();
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
          _accelData = sensorEvent.data;
          onSensorChanged(_accelData);
        });
      });
    }
  }

  void onSensorChanged(List<double> event) {
    double x = event[0];
    double y = event[1];
    double z = event[2];
    int xyz = sqrt(x*x + y*y + z*z).ceil();
    print(xyz);

    if (xyz > acceleration) { // 往上方向
      if(acceleration > 20 && direction != "上" ) {
        int now = DateTime.now().millisecondsSinceEpoch;
        if (mShakeTimestamp + mShakeTimeSpan < now) {
          swingCount++;
          // if(swingCount % 5 == 0) {
            tts.speak(swingCount.toString());
          // }
          var curr = DateTime.now();
          var time = "$curr".substring(11, 23);
          recorders = swingCount.toString() + ". " + time + ": " + acceleration.toString() 
            + (recorders.isNotEmpty ? "\n" : "") + recorders;
          mShakeTimestamp = now;
        }
        direction = "上";
      }
    } else {
      direction = "";
    }
    acceleration = xyz;
  }

  void _stopAccelerometer() {
    if (_accelSubscription == null) return;
    _accelSubscription?.cancel();
    _accelSubscription = null;
    acceleration = 0;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Sensors'),
        ),
        body: Container(
          padding: EdgeInsets.all(10.0),
          alignment: AlignmentDirectional.topCenter,
          child: Column(
            children: <Widget>[
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
                        // color:Colors.white,
                        fontSize: 16
                      ),  
                      maxLines: 300,
                      textAlign: TextAlign.center,
                    ),
                  )
                ),  
              ),
              Padding(padding: EdgeInsets.only(top: 5.0)),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.start,
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
                  if(acceleration ==0 )
                    MaterialButton(
                        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 30.0),
                      child: Text("開始",
                        style: TextStyle(
                          color:Colors.white,
                          fontSize: 18
                        )
                      ),
                      color: Colors.green,
                      onPressed:
                          _accelAvailable ? () => _startAccelerometer() : null,
                    )
                  else 
                    MaterialButton(
                      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 30.0),
                      child: Text("結束",
                        style: TextStyle(
                          color:Colors.white,
                          fontSize: 18
                        )
                      ),
                      color: Colors.red,
                      onPressed:
                          _accelAvailable ? () => _stopAccelerometer() : null,
                    ),
                ],
              ),
              // Padding(padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),),
            ],
          ),
        ),
      ),
    );
  }
}