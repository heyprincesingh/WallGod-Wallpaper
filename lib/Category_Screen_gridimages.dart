import 'package:darkwall/category_gridscreen.dart';
import 'package:flutter/material.dart';

class ImageGridScreen extends StatelessWidget {
  final String? categoryValue;
  const ImageGridScreen({Key? key, this.categoryValue}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          shadowColor: Colors.white38,
          centerTitle: true,
          automaticallyImplyLeading: false,
          toolbarHeight: 45,
          title: Text(
            "$categoryValue",
            style: TextStyle(
                decoration: TextDecoration.none,
                color: Colors.white,
                fontSize: 24,
                fontFamily: "Tiles",
                fontWeight: FontWeight.w500,
                letterSpacing: 1.5
            ),),
        ),
        body: gridscreen(categoryValue : categoryValue),
      ),
    );
  }
}

