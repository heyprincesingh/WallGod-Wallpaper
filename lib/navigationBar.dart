import 'package:darkwall/Category_Screen.dart';
import 'package:darkwall/Favourite.dart';
import 'package:darkwall/common_gridscreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:share/share.dart';
import 'package:url_launcher/link.dart';

class myNavigationBar extends StatefulWidget {
  const myNavigationBar({Key? key}) : super(key: key);

  @override
  _myNavigationBarState createState() => _myNavigationBarState();
}

class _myNavigationBarState extends State<myNavigationBar> {

  int _currentIndex = 1;
  final screenIndex = [Category_screen(), common_gridscreen(), favourite()];
  @override
  Widget build(BuildContext context) {
    var device = MediaQuery.of(context).size;
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 5,
        actions: [
          GestureDetector(
            onTap: (){
              Share.share("WallGod - 4K wallpaper\nhttps://play.google.com/store/apps/details?id=com.spytech.darkwall");
              },
              child: Icon(Icons.share,size: device.width * 0.06,color: Colors.white,)),
          SizedBox(width: 20),
          GestureDetector(
              onTap: (){detailsAlertbox(context);},
              child: Image.asset("assets/!.png",color: Colors.white,height: device.width * 0.055,width: device.width * 0.055,)),
          SizedBox(width: 18)
        ],
        title: Text(
          "WallGod",
          style: TextStyle(
              decoration: TextDecoration.none,
              color: Colors.white,
              fontSize: 24,
              fontFamily: "Tiles",
              fontWeight: FontWeight.w500,
              letterSpacing: 2.5
          ),),
      ),
      body: screenIndex[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        animationCurve: Curves.fastLinearToSlowEaseIn,
        backgroundColor: Colors.transparent,
        color: Color(0xff2b2b2b),
        buttonBackgroundColor: Color(0xff2b2b2b),
        items: [
          Tooltip(
              message: "Categories",
              child: Icon(Icons.category_rounded,size: 25,color: Colors.white)),
          Tooltip(
              message: "Wallpapers",
              child: Icon(CupertinoIcons.photo_fill,size: 25,color: Colors.white)),
          Tooltip(
              message: "Favourite",
              child: Icon(CupertinoIcons.heart_fill,size: 25,color: Colors.white)),
        ],
        height: device.height * 0.06,
        index: 1,
        onTap: (index) => setState(() => _currentIndex = index),
      )
    );
  }
}

detailsAlertbox(BuildContext context){
  return showDialog(context: context, builder: (context){
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Row(
        children: [
          Icon(Icons.whatshot,color: Colors.deepOrangeAccent,),
          SizedBox(width: 5,),
          Text("WallGod",style: TextStyle(fontSize: 25,fontFamily: "Tiles"),)
        ],
      ),
      content: Card(
        color: Colors.white,
        elevation: 10,
        child: Container(
          height: 360,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("About This App",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18),),
                SizedBox(height: 5,),
                Text("This application has been designed to provide you the best 4k wallpapers for free of cost to light-up your mood and wall. The owner of the WallGod application never claims to be the owner of the wallpapers/images shown here.\n"),
                Text("You get the option to navigate through the categories of your choice, random wallpapers and the option to save it for later use as favourite.\n"),
                Text("We do not collect any information regarding the user of the application."),
                Text("By continuing, you argee to our "),
                Link(
                  target: LinkTarget.blank,
                    uri: Uri.parse("https://google.com"),
                    builder: (context, followLink)
                    {
                      return GestureDetector(
                        onTap: followLink,
                        child: Text("Terms & Conditions.",
                          style: TextStyle(
                            height: 1.5,
                              decoration: TextDecoration.underline
                    ),),
                  );
                }),
                SizedBox(height: 18,),
                Row(
                  children: [
                    Icon(CupertinoIcons.mail,size: 20,),
                    Text(" Contact : "),
                    Link(
                        target: LinkTarget.blank,
                        uri: Uri.parse("mailto:princesingh3632@gmail.com?subject=WallGod%20App%20Related"),
                        builder: (context, followLink)
                        {
                          return GestureDetector(
                            onTap: followLink,
                            child: Text("wallgod@gmail.com",
                              style: TextStyle(
                                  decoration: TextDecoration.underline
                              ),),
                          );
                        })
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      elevation: 10,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))
      ),
    );
  });
}