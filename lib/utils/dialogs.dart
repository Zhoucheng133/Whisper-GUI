import 'package:flutter/material.dart';

Future<void> showOkDialog(BuildContext context, String title, String content, {String okText="好的"}) async {
  await showDialog(
    context: context, 
    builder: (BuildContext context)=>AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        ElevatedButton(
          onPressed: ()=>Navigator.pop(context), 
          child: Text(okText)
        )
      ],
    )
  );
}