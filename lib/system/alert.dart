import 'dart:async';
import 'package:flutter/material.dart';

Future<void> alert(BuildContext context, String msg, {List<Widget>? btns}) {
  btns = btns ?? [
    TextButton(
      child: Text('確定'),
      onPressed: () async {
        Navigator.of(context).pop();
      },
    )
  ];
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('運動'),
        // barrierDismissible: false,
        content: Text(msg),
        actions: btns,
      );
    },
  );
}
  /*
  
  <Widget>[
            TextButton(
              child: Text('確定'),
              onPressed: () async {
                // list.removeAt(index);
                // await Storage.setJSON("swing", list);
                // active = -1;
                // setState(() {});
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ]

   */