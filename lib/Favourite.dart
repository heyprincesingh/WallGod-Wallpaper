import 'package:darkwall/favourite_selectwallpaper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<String>? originalFavouriteUrls;
class favourite extends StatefulWidget {
  const favourite({Key? key}) : super(key: key);

  @override
  State<favourite> createState() => _favouriteState();
}

class _favouriteState extends State<favourite> {

  @override
  void initState() {
    setState(() {
      getFavouritewallUrl();
    });
    super.initState();
  }

  getFavouritewallUrl() async {
    SharedPreferences originalFavouriteUrlspref = await SharedPreferences.getInstance();
    setState(() {
      originalFavouriteUrls = originalFavouriteUrlspref.getStringList("originalFavouriteUrls") ?? null;
    });
  }

  @override
  Widget build(BuildContext context) {
    var device = MediaQuery.of(context).size;
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.black,
      child: originalFavouriteUrls == null || originalFavouriteUrls!.isEmpty == true?
      Center(child: Text("You don't have any saved favourites yet...",style: TextStyle(color: Colors.white,fontFamily: "Tiles",letterSpacing: 1.5,),)) :
        Container(
            color: Colors.black,
            child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 0.7,
                    crossAxisCount: 3,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2),
                itemCount: originalFavouriteUrls!.length,
                itemBuilder: (BuildContext ctx, index) {
                  return Center(
                      child: originalFavouriteUrls == null ?
                      CircularProgressIndicator(color: Color(0xff3d3d3d)) :
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => selectWallpaper(imagenum : index,imagesUrl : originalFavouriteUrls))).then((value) => {
                            setState((){getFavouritewallUrl();})
                          });
                        },
                        child: Image.network(
                            "${originalFavouriteUrls?[index]}?auto=compress&cs=tinysrgb&dpr=1&fit=crop&h=200&w=280",
                            fit: BoxFit.cover,
                            height: device.width * 0.5,
                            width: device.width * 0.5,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }
                              return Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xff3d3d3d),
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            }
                        ),
                      )
                  );
                }
            )
        )
    );
  }
}
