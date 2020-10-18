import 'dart:convert';
import 'dart:math';

import 'package:butsi/screens/products.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';

final Color backgroundColor = Colors.blueGrey[50];
final TextStyle headerTextStyle =
    TextStyle(fontWeight: FontWeight.bold, fontSize: 40);

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class Category {
  String text;
  String assetImagePath;
  String category;
  bool hasProducts;
  bool answered;
  Category(this.text, this.assetImagePath, this.category, this.hasProducts,
      this.answered);
}

class CategoriesPageArguments {
  final DatabaseReference dbRef;
  CategoriesPageArguments(this.dbRef);
}

class _MyHomeState extends State<MyHome> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  final String MAIN_CATEGORY = "main";
  final String categoriesKey = "categories";
  final String productsKey = "products";
  String category = "";
  List<Category> categories;
  DatabaseReference dbRef = null;

  Widget getCategoryWidget(Category category, BuildContext context) {
    IconData cardIcon = category.answered ? Icons.check : Icons.add;
    Color cardIconColor = category.answered ? Colors.blue[400] : Colors.black;

    Color cardColor = category.answered ? Colors.white : Colors.white;

    return Card(
      margin: EdgeInsets.all(10),
      color: cardColor,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
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
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: FirebaseImage(category.assetImagePath,
                                shouldCache:
                                    true, // The image should be cached (default: True)
                                maxSizeBytes: 3000 *
                                    1000, // 3MB max file size (default: 2.5MB)
                                cacheRefreshStrategy: CacheRefreshStrategy
                                    .NEVER // Switch off update checking
                                ),
                            fit: BoxFit.fitHeight,
                            alignment: Alignment.center,
                          ))),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: Text(
                    category.text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      //color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
                top: 8,
                right: 8,
                child: Icon(
                  cardIcon,
                  size: 30,
                  color: cardIconColor,
                )),
          ],
        ),
      ),
    );
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
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              left: 10,
              top: 10,
              child: IconButton(
                icon: Icon(Icons.menu),
                onPressed: () => scaffoldKey.currentState.openDrawer(),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Text(
                      "הבית שלי",
                      style: headerTextStyle,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(20.0, 10, 20.0, 0),
                    child: getCategoriesDisplay(),
                  ),
                ),
                Container(
                  height: 90,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(40, 0, 40, 10),
                    child: Center(
                        child: RaisedButton(
                      color: Colors.lightBlue[100],
                      child: Text(
                        "לסיכום והמשך לקבלת הצעת מחיר",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                        textAlign: TextAlign.center,
                      ),
                    )),
                  ),
                )
              ],
            ),
          ],
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
                  Random r = new Random();
                  categories.add(Category(value['text'], value['image'],
                      key.toString(), hasProducts, r.nextBool()));
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
