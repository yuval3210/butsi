import 'dart:convert';

import 'package:butsi/screens/products.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';

class Category {
  String text;
  String assetImagePath;
  String category;
  bool hasProducts;
  Category(this.text, this.assetImagePath, this.category, this.hasProducts);
}

class CategoriesPageArguments {
  final DatabaseReference dbRef;
  CategoriesPageArguments(this.dbRef);
}

class CategoriesPage extends StatelessWidget {
  final String MAIN_CATEGORY = "main";
  final String categoriesKey = "categories";
  final String productsKey = "products";
  String category = "";
  List<Category> categories;
  DatabaseReference dbRef = null;

  Widget getCategoryWidget(Category category, BuildContext context) {
    return Card(
        color: Colors.transparent,
        elevation: 0,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                  image: FirebaseImage(category.assetImagePath),
                  fit: BoxFit.cover)),
          child: InkWell(
            splashColor: Colors.grey[300],
            onTap: () {
              if (category.hasProducts) {
                print("Going to products page bitcxh");
                Navigator.pushNamed(context, '/products',
                    arguments: ProductsPageArguments(
                        dbRef.child(categoriesKey).child(category.category)));
              } else {
                Navigator.pushNamed(context, '/categories',
                    arguments: CategoriesPageArguments(
                        dbRef.child(categoriesKey).child(category.category)));
              }
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 115, 0, 15),
              child: Center(
                child: Stack(
                  children: [
                    Text(
                      category.text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        //color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 2
                          ..color = Colors.black,
                      ),
                    ),
                    Text(
                      category.text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        //color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final CategoriesPageArguments args =
        ModalRoute.of(context).settings.arguments;

    if (args == null) {
      this.dbRef = FirebaseDatabase.instance.reference().child(MAIN_CATEGORY);
    } else {
      this.dbRef = args.dbRef;
    }

    return Scaffold(
      backgroundColor: Colors.grey[700],
      appBar: AppBar(
        backgroundColor: Colors.grey[400],
        elevation: 3,
        leading: Icon(Icons.menu),
        title: Text(
          "קטגוריות",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.fromLTRB(20.0, 10, 20.0, 0),
          child: getCategoriesDisplay(),
        ),
      ),
    );
  }

  Widget getCategoriesDisplay() => new StreamBuilder(
      stream: this.dbRef.onValue,
      builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
        if (snapshot.hasError) {
          return new Text('Error in receiving trip photos: ${snapshot.error}');
        }

        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return new Text('Not connected to the Stream or null');

          case ConnectionState.waiting:
            return new Text('Awaiting for interaction');

          case ConnectionState.active:
            print("Stream has started but not finished");

            if (snapshot.hasData) {
              Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
              if (map.containsKey(categoriesKey)) {
                String jsonString = json.encode(map);
                map = json.decode(jsonString);
                jsonString = json.encode(map[categoriesKey]);
                map = json.decode(jsonString);
                print(map.keys);

                List<Category> categories = [];

                map.forEach((key, value) {
                  bool hasProducts = value['products'] != null;
                  String storageFolder = "";
                  categories.add(Category(value['text'], value['image'],
                      key.toString(), hasProducts));
                });

                return new GridView.count(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  primary: false,
                  crossAxisCount: 2,
                  children: categories
                      .map((cat) => getCategoryWidget(cat, context))
                      .toList(),
                );
              }
            }

            return new Center(
                child: Column(
              children: <Widget>[
                new Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                ),
                new Text(
                  "No trip photos found.",
                  style: Theme.of(context).textTheme.title,
                )
              ],
            ));

          case ConnectionState.done:
            return new Text('Streaming is done');
        }
        return Text("HOWDIDIGETHERE");
      });
}
