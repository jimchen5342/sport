import 'dart:async';
import 'dart:math';
import 'package:intl/intl.dart';
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
      if(acceleration > 18 && direction != "上" ) {
        int now = DateTime.now().millisecondsSinceEpoch;
        if (mShakeTimestamp + 600 < now) {
          swingCount++;
          // if(swingCount % 5 == 0) {
            tts.speak(swingCount.toString());
          // }
          var curr = DateTime.now();
          var time = "$curr".substring(11, 23);
          recorders = time + ": " + acceleration.toString() 
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
    acceleration = 0;
    if (_accelSubscription == null) return;
    _accelSubscription?.cancel();
    _accelSubscription = null;
    acceleration = 0;
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Sensors'),
        ),
        body: Container(
          padding: EdgeInsets.all(16.0),
          alignment: AlignmentDirectional.topCenter,
          child: Column(
            children: <Widget>[
               Text(
                "acceleration = ${acceleration}",
                textAlign: TextAlign.center,
              ),
              Text(
                "swingCount = ${swingCount}",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Expanded(
                flex: 1, 
                child: 
                SingleChildScrollView(child: Text(recorders,
                maxLines: 30,
                textAlign: TextAlign.center,
              ),
                )
              ),
              Padding(padding: EdgeInsets.only(top: 16.0)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if(acceleration ==0 )
                      MaterialButton(
                      child: Text("Start"),
                      color: Colors.green,
                      onPressed:
                          _accelAvailable ? () => _startAccelerometer() : null,
                    )
                  else 
                    MaterialButton(
                      child: Text("Stop"),
                      color: Colors.red,
                      onPressed:
                          _accelAvailable ? () => _stopAccelerometer() : null,
                    ),
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 16.0)),
              
            ],
          ),
        ),
      ),
    );
  }
}