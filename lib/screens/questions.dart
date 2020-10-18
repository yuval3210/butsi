import 'package:flutter/material.dart';

Widget buildAboutDialog(BuildContext context) {
  return AlertDialog(
    content: Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        Positioned(
          right: -40.0,
          top: -40.0,
          child: InkResponse(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: CircleAvatar(
              child: Icon(Icons.close),
              backgroundColor: Colors.red,
            ),
          ),
        ),
        Form(
          //key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    "שאלה שאלה שאלה שאלה שאלה שאלה שאלה שאלה שאלה שאלה שאלה שאלה שאלה שאלה שאלה שאלה שאלה שאלה "),
              )
            ],
          ),
        ),
      ],
    ),
  );
}
