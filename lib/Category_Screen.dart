import 'dart:convert';
import 'package:darkwall/Category_Screen_gridimages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Category_screen extends StatelessWidget {
  const Category_screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var device = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder(
          future: DefaultAssetBundle.of(context).loadString("assets/category.json"),
          builder: (context, snapshot) {
          var categorydata = json.decode(snapshot.data.toString());
          final categorylength = categorydata?.length;
          if (categorydata == null) {
            return const Center(
              child: Text("Loading...")
            );
          }
          else {
            return GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2),
              itemCount: categorylength,
              itemBuilder: (BuildContext ctx, index) {
                return GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ImageGridScreen(categoryValue : categorydata["name$index"])));
                    },
                  child: Container(
                      alignment: Alignment.center,
                      child: Container(
                        height: device.width * 0.5,
                        width: device.width * 0.5,
                        decoration: BoxDecoration(
                            image: DecorationImage(fit: BoxFit.fitWidth,
                                image: AssetImage("assets/world.jpeg")
                            )
                        ),
                        child: Center(
                            child: Text(
                              categorydata["name$index"],
                              style: const TextStyle(
                                  decoration: TextDecoration.none,
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontFamily: "Tiles",
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1.5
                              ),)),
                      )
                  ),
                );
              });
          }
    }),
    );
  }
}