import 'package:flutter/material.dart';

class Setup extends StatefulWidget {
  double span, acceleration, speak ;
  Setup({Key? key, required this.span, required this.acceleration, required this.speak}) : super(key: key){
  }
  @override
  _SetupState createState() => _SetupState();
}
class _SetupState extends State<Setup> {
  double _currentSliderSpeak = 0.0, _currentSliderSpan = 0.0, _currentSliderAcceleration = 0.0;
  bool dirty = false;
  @override
  void initState() {
    super.initState();
    _currentSliderSpeak = widget.speak;
    _currentSliderSpan = widget.span;
    _currentSliderAcceleration = widget.acceleration;
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
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 250,
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      // alignment: AlignmentDirectional.topCenter,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text("設定",
            style: TextStyle(
              // color:Colors.white,
              fontSize: 22
            )
          ),
          if(widget.speak > -1)
            Row(
              children: [
                const Text("語音播報：",
                  style: TextStyle(
                    // color:Colors.white,
                    fontSize: 16
                  )
                ),
                Slider(
                  value: _currentSliderSpeak,
                  max: 10,
                  divisions: 2,
                  label: _currentSliderSpeak.round().toString(),
                  onChanged: (double value) {
                    dirty = true;
                    setState(() {
                      _currentSliderSpeak = value;
                    });
                  },
                ),
              ]
            ),
          Row(
            children: [
              const Text("加速度：",
                style: TextStyle(
                  // color:Colors.white,
                  fontSize: 16
                )
              ),
              Slider(
                value: _currentSliderAcceleration,
                max: 25,
                min: 15,
                divisions: 10,
                label: _currentSliderAcceleration.round().toString(),
                onChanged: (double value) {
                  dirty = true;
                  setState(() {
                    _currentSliderAcceleration = value;
                  });
                },
              ),
            ]
          ),
          Row(
            children: [
              const Text("時間跨距：",
                style: TextStyle(
                  // color:Colors.white,
                  fontSize: 16
                )
              ),
              Slider(
                value: _currentSliderSpan,
                max: 1000,
                min: 500,
                divisions: 50,
                label: _currentSliderSpan.round().toString(),
                onChanged: (double value) {
                  dirty = true;
                  setState(() {
                    _currentSliderSpan = value;
                  });
                },
              ),
            ]
          ),
          SizedBox(height: 0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if(dirty)
                TextButton(
                  child: const Text('確定',
                      style: TextStyle(
                        color:Colors.blue,
                        fontSize: 16
                      )),
                  onPressed: () async {
                    Navigator.of(context).pop({
                      "acceleration": _currentSliderAcceleration,
                      "span": _currentSliderSpan,
                      "speak": _currentSliderSpeak
                    });
                  },
                ),
              TextButton(
                child: const Text('取消',
                    style: TextStyle(
                      // color:Colors.blue,
                      fontSize: 16
                    )),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              )
            ]
          )
        ]
      )
    );
  }
}
