import 'package:flutter/material.dart';

class Setup extends StatefulWidget {
  // Setup({Key? key}) : super(key: key){
  // }
  @override
  _SetupState createState() => _SetupState();
}
class _SetupState extends State<Setup> {

  @override
  void initState() {
    super.initState();
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
          Text("設定",
              style: const TextStyle(
                // color:Colors.white,
                fontSize: 22
              ),),
          Row(
            children: [
              Text("語音播報：")
            ]
          ),Row(
            children: [
              Text("加速度：")
            ]
          ),Row(
            children: [
              Text("時間跨距：")
            ]
          ),
          SizedBox(height: 40),

        ]
      )
    );
  }
}
