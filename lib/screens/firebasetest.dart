import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GetMealScreen extends StatefulWidget {
  @override
  _GetMealScreenState createState() => _GetMealScreenState();
}

class _GetMealScreenState extends State<GetMealScreen> {
  DatabaseReference itemRef5 =
      FirebaseDatabase.instance.reference().child("categories");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Example"),
        ),
        resizeToAvoidBottomPadding: false,
        body: Column(
          children: <Widget>[
            Flexible(
              child: FirebaseAnimatedList(
                  query: itemRef5, // use this just for test
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation<double> animation, int index) {
                    return Container(
                        child: Column(
                      children: <Widget>[
                        Text(snapshot.value['text']),
                      ],
                    ));
                  }),
            ),
          ],
        ));
  }
}
