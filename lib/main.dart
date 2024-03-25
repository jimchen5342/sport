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
  double acceleration = 0;

  int SHAKE_SLOP_TIME_MS = 500;
  int mShakeTimestamp = 0;
  TTS tts = TTS();
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      await tts.initial();
      _checkAccelerometerStatus();
      tts.count();
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
    });
  }

  Future<void> _startAccelerometer() async {
    if (_accelSubscription != null) return;
    if (_accelAvailable) {
      swingCount = 0;
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
        // 檢測加速度變化，這裡可以自行調整閾值
        double x = event[0];
        double y = event[1];
        double z = event[2];
        double xyz = sqrt(x*x + y*y + z*z);

        // // 如果檢測到手擺動，增加手擺動次數
        // if (acceleration > 15) {  // 這個閾值可能需要調整
        //     swingCount++;
        //     // tts.speak(swingCount.toString());
        // }
        
        if (acceleration < xyz && acceleration > 15) {
          int now = DateTime.now().millisecondsSinceEpoch;
          if (mShakeTimestamp + 300 < now) {
            swingCount++;
            if(swingCount % 5 == 0) {
              tts.speak(swingCount.toString());
            }
          }
          mShakeTimestamp = now;
        }
        acceleration = xyz;
    }


  void _stopAccelerometer() {
    if (_accelSubscription == null) return;
    _accelSubscription?.cancel();
    _accelSubscription = null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Sensors Example'),
        ),
        body: Container(
          padding: EdgeInsets.all(16.0),
          alignment: AlignmentDirectional.topCenter,
          child: Column(
            children: <Widget>[
              Text(
                "Accelerometer Enabled: $_accelAvailable",
                textAlign: TextAlign.center,
              ),
              Padding(padding: EdgeInsets.only(top: 16.0)),
              Text(
                "X = ${_accelData[0]}",
                textAlign: TextAlign.center,
              ),
              Padding(padding: EdgeInsets.only(top: 16.0)),
              Text(
                "Y = ${_accelData[1]}",
                textAlign: TextAlign.center,
              ),
              Padding(padding: EdgeInsets.only(top: 16.0)),
              Text(
                "Z = ${_accelData[2]}",
                textAlign: TextAlign.center,
              ),
               Text(
                "acceleration = ${acceleration}",
                textAlign: TextAlign.center,
              ),
              Text(
                "swingCount = ${swingCount}",
                textAlign: TextAlign.center,
              ),
              Padding(padding: EdgeInsets.only(top: 16.0)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  MaterialButton(
                    child: Text("Start"),
                    color: Colors.green,
                    onPressed:
                        _accelAvailable ? () => _startAccelerometer() : null,
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
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