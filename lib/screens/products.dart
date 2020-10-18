import 'package:butsi/screens/questions.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

final TextStyle nameTextStyle = TextStyle(fontSize: 25, color: Colors.black);
final TextAlign nameTextAlign = TextAlign.center;

final TextStyle descriptionTextStyle =
    TextStyle(fontSize: 20, color: Colors.black);
final TextAlign descriptionTextAlign = TextAlign.center;

final Color appbarColor = Colors.grey[400];
final Color backgroundColor = Colors.grey[200];

class Product {
  String text;
  String assetImagePath;
  String description;
  Product(String text, String descripion, String assetImagePath) {
    this.text = text;
    this.description = descripion;
    this.assetImagePath = assetImagePath;
  }
}

Widget _incrementButton() {
  return FloatingActionButton(
      child: Icon(
        Icons.add,
        color: Colors.black87,
      ),
      backgroundColor: Colors.white,
      elevation: 5,
      onPressed: () {});
}

Widget _decrementButton() {
  return FloatingActionButton(
      child: Icon(
        Icons.remove,
        color: Colors.black87,
      ),
      backgroundColor: Colors.white,
      elevation: 5,
      onPressed: () {});
}

Widget getProductCard(dynamic value, BuildContext context) {
  Product product =
      Product(value['name'], value['description'], value['image']);
  return Container(
    child: Card(
        color: backgroundColor,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: InkWell(
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return buildAboutDialog(context);
                });
          },
          onTapCancel: () => print("tapped-canceld"),
          child: Container(
            width: double.infinity,
            height: 140,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
                  //cart symbols
                  width: 40,
                  height: double.infinity,
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      _incrementButton(),
                      Text(
                        '0',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      _decrementButton()
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.transparent,
                    height: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          product.text,
                          style: nameTextStyle,
                          textAlign: nameTextAlign,
                        ),
                        Text(
                          product.description,
                          style: descriptionTextStyle,
                          textAlign: descriptionTextAlign,
                        ),
                      ],
                    ),
                  ),
                ),
                AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: FirebaseImage(product.assetImagePath,
                            shouldCache:
                                true, // The image should be cached (default: True)
                            maxSizeBytes: 3000 *
                                1000, // 3MB max file size (default: 2.5MB)
                            cacheRefreshStrategy: CacheRefreshStrategy
                                .NEVER // Switch off update checking
                            ),
                        fit: BoxFit.fitHeight,
                        alignment: Alignment.center,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        )),
  );
}

Widget getProductCardFromSnapshot(
    DataSnapshot snapshot, BuildContext context, int index) {
  print(snapshot.key);
  print(snapshot.value);
  print(snapshot.toString());
  return getProductCard(snapshot.value, context);
}

class ProductsPageArguments {
  final DatabaseReference dbRef;
  ProductsPageArguments(this.dbRef);
}

class ProductsPage extends StatelessWidget {
  Query productsQuery;
  String category = "";

  @override
  Widget build(BuildContext context) {
    final ProductsPageArguments args =
        ModalRoute.of(context).settings.arguments;

    this.category = category;

    if (args == null) {
      throw Exception("Product page without arguments");
    } else {
      this.productsQuery = args.dbRef.child("products");
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: appbarColor,
        elevation: 3,
        leading: Icon(Icons.menu),
        title: Text(
          this.category,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(10.0, 10, 10.0, 0),
        color: Colors.transparent,
        child: FirebaseAnimatedList(
          query: productsQuery,
          itemBuilder: (
            BuildContext context,
            DataSnapshot snapshot,
            Animation<double> animation,
            int index,
          ) =>
              getProductCardFromSnapshot(snapshot, context, index),
        ),
        //children: products.map((product) => getProductCard(product)).toList(),
      ),
    );
  }
}
