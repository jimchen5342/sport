import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_sensors/flutter_sensors.dart';
import 'package:sport/system/tts.dart';
import 'package:./sport/system/storage.dart';
import 'package:./sport/swingSetup.dart';

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
  int mAccelerationStand = 18, mAcceleration = 0, 
    mShakeTimeStand = 800, mShakeTimestamp = 0;
  TTS tts = TTS();
  String history = "", direction = "", mode = "";
  var dirty = false;
  var recorder = {"left": 0, "right": 0};
  List<dynamic> list = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      list = await Storage.getJSON("swing");
      var curr = DateTime.now();
      var today = "$curr".substring(0, 10);
      if(list.isEmpty || (list.isNotEmpty && list[0]["date"] != today)) {
        list.insert(0, {"date": today, "left": 0, "right": 0});
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
      history = "";
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
          history = "$swingCount. $time: $mAcceleration${history.isNotEmpty ? "\n" : ""}$history";

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

  void backTo() async {
    if(_accelSubscription == null) {
      var sum1 = (list[0]["left"] as int) + (list[0]["right"] as int);
      var sum2 = (recorder["left"] as int) + (recorder["right"] as int);
      if(sum1 == 0) {
        list.removeAt(0);
        await Storage.setJSON("swing", list);
      }
      if (!context.mounted) return;
      Navigator.of(context).pop(sum2 > 0 ? true : false); 
    }
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
          title: const Text('單腳擺動',
            style: TextStyle( color:Colors.white,)
          ),
          actions: [
            IconButton( icon: Icon( Icons.menu, color: Colors.white),
              onPressed: () {
                setup();
              },
            )
          ],
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
    int left = list.isNotEmpty ? (list[0]["left"] as int) - (recorder["left"] as int) : 0;
    int right = list.isNotEmpty ? (list[0]["right"] as int) - (recorder["right"] as int) : 0;
    return Container(
      padding: const EdgeInsets.all(10.0),
      alignment: AlignmentDirectional.topCenter,
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(5.0),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("左腳：",
                      style: TextStyle(
                        // color:Colors.white,
                        fontSize: 20
                      )
                    ),
                  if(list.isNotEmpty)                
                    borderOfText(left.toString(), disabled: true),
                  borderOfText((recorder["left"] as int).toString()),
                  IconButton(
                    iconSize: 30,
                    icon: Icon( 
                      Icons.highlight_remove, 
                      color: recorder["left"] as int > 0 ? Colors.orange : Colors.grey.shade400
                    ),
                    onPressed: () {
                      if(recorder["left"] as int > 0) {
                        reset("left");
                      }
                    },
                  )
                ]
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("右腳：",
                    style: TextStyle(
                      // color:Colors.white,
                      fontSize: 20
                    )
                  ),
                  if(list.isNotEmpty)                
                    borderOfText(right.toString(), disabled: true),
                  borderOfText((recorder["right"] as int).toString()),

                  IconButton(
                    iconSize: 30,
                    icon: Icon( 
                      Icons.highlight_remove, 
                      color: recorder["right"] as int > 0 ? Colors.orange : Colors.grey.shade400
                    ),
                    onPressed: () {
                      if(recorder["right"] as int > 0) {
                        reset("right");
                      }
                    },
                  )
                ]
              )
            ],)
          ),
          Expanded(
            flex: 1, 
            child: Container()
          ),
          Expanded(
            flex: 2, 
            child: Text(
              "次數：$swingCount",
              style: const TextStyle(
                // color:Colors.white,
                fontSize: 50
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 5.0)),
          if(_accelAvailable == true)
            footer(),
          // Padding(padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),),
        ],
      ),
    );
  }

  Widget footer() {
    bool mLeft = mAcceleration == 0 && mode != "left" ? true : false;
    bool mRight = mAcceleration == 0 && mode != "right" ? true : false;
    bool mStop = mAcceleration > 0 ? true : false;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        // Expanded( flex: 1,  child: Container() ),
          MaterialButton(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
            color: mLeft ? Colors.green : Colors.grey.shade100,
            onPressed: () {
              if(_accelAvailable && mLeft) {
                tts.speak("start");
                mode = "left";
                _startAccelerometer();
              }
            },
            child: Text("左腳",
              style: TextStyle(
                color: mLeft ? Colors.white : Colors.grey.shade400,
                fontSize: 18
              )
            )
          ),
        
          const SizedBox(width: 20,),
        
          MaterialButton(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
            color: mRight ? Colors.green : Colors.grey.shade100,
            onPressed: () {
                if(_accelAvailable && mRight) {
                  tts.speak("start");
                  mode = "right";
                  _startAccelerometer();
                }
            },
            child: Text("右腳",
              style: TextStyle(
                color:mRight ? Colors.white  : Colors.grey.shade400,
                fontSize: 18
              )
            )
          ),
          
          const SizedBox(width: 20,),
          
          MaterialButton(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 30.0),
            color: mStop ? Colors.red  : Colors.grey.shade100,
            onPressed: () async {
              if(mStop) {
                await stop();
              }
            },
            child: Text("結束",
              style: TextStyle(
                color: mStop ? Colors.white  : Colors.grey.shade400,
                fontSize: 18
              )
            )
          ),
      ],
    );
  }

  stop() async {
    if (_accelSubscription == null) return;

    if(_accelAvailable) {
      history = "swingCount: $swingCount\n$history";
      if(swingCount > 0) {
        int old = list[0][mode] as int;
        list[0][mode] = swingCount + old;
        // history = "list: " + old.toString() + ", " + (list[0][mode] as int).toString() + "\n" + history;

        old = recorder[mode] as int;
        recorder[mode] = swingCount + old;
        // history = "recorder: " + old.toString() + ", " + (recorder[mode] as int).toString() + "\n" + history;
        await Storage.setJSON("swing", list);
        swingCount = 0;
        setState(() {});
      }
      tts.speak("stop");
      _stopAccelerometer();
    }
  }
  
  reset(mode) async {
    int value1 = list[0][mode] as int;
    int value2 = recorder[mode] as int;
    list[0][mode] = value1 - value2;
    recorder[mode] = 0;
    await Storage.setJSON("swing", list);

    setState(() { });
  }

  Widget borderOfText(String text, {bool disabled = false}) {
    return Container(
      width: 80,
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
      margin: const EdgeInsets.only(left: 5.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade500),
          borderRadius: BorderRadius.circular(5),
          color: disabled ? Colors.grey.shade200 : Colors.transparent,
          // shape: BoxShape.circle
      ),
      child: Text(text,
        textAlign: TextAlign.right,
        style: TextStyle(
          color:disabled ? Colors.black38 : Colors.orangeAccent,
          fontSize: 20
        )
      )
    );
  }

  setup() async {
    // int? index = await showDialog<int>(
    // onTap: () => Navigator.of(context).pop(index),
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(child: Setup());
      },
    );
  }
}

