import 'package:butsi/screens/categories.dart';
import 'package:butsi/screens/firebasetest.dart';
import 'package:butsi/screens/home/myhome.dart';
import 'package:butsi/screens/products.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      routes: {
        '/home': (context) => MyHome(),
        // When navigating to the "/" route, build the FirstScreen widget.
        '/categories': (context) => CategoriesPage(),
        '/categories1': (context) => CategoriesPage(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/products': (context) => ProductsPage(),
        '/test': (context) => GetMealScreen(),
      },
    ));

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
