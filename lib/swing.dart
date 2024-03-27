import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_sensors/flutter_sensors.dart';
import 'package:./sport/tts.dart';

class Swing extends StatefulWidget {
  // Swing({Key? key}) : super(key: key){
  // }
  @override
  _SwingState createState() => _SwingState();
}
// Navigator.pop(context);

class _SwingState extends State<Swing> {
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

  void quit() {
    if(acceleration == 0) {
      Navigator.of(context).pop(); 
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
            // onPressed: () => Navigator.pop(context),
            onPressed: () => quit(),
          ),
          title: Text('擺手偵測',
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
            Text(
            "acceleration：${acceleration}",
            style: const TextStyle(
              // color:Colors.white,
              fontSize: 20
            ),
            textAlign: TextAlign.center,
          ),

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
    );
  }
}