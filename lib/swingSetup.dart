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
  @override
  void initState() {
    super.initState();
    _currentSliderSpeak = widget.speak as double;
    _currentSliderSpan = widget.span as double;
    _currentSliderAcceleration = widget.acceleration as double;
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
      height: 300,
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
                const Text("語音播報："),
                Slider(
                  value: _currentSliderSpeak,
                  max: 10,
                  divisions: 5,
                  label: _currentSliderSpeak.round().toString(),
                  onChanged: (double value) {
                    setState(() {
                      _currentSliderSpeak = value;
                    });
                  },
                ),
              ]
            ),
          Row(
            children: [
              const Text("加速度："),
              Slider(
                value: _currentSliderAcceleration,
                max: 25,
                min: 15,
                divisions: 1,
                label: _currentSliderAcceleration.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _currentSliderAcceleration = value;
                  });
                },
              ),
            ]
          ),Row(
            children: [
              const Text("時間跨距："),
              Slider(
                value: _currentSliderSpan,
                max: 1000,
                min: 500,
                divisions: 100,
                label: _currentSliderSpan.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _currentSliderSpan = value;
                  });
                },
              ),
            ]
          ),
          SizedBox(height: 40),

        ]
      )
    );
  }
}
