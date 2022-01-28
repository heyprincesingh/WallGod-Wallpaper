import 'package:darkwall/SelectWallpaper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class gridscreen extends StatefulWidget {
  gridscreen({Key? key}) : super(key: key);

  @override
  State<gridscreen> createState() => _gridscreenState();
}

class _gridscreenState extends State<gridscreen> {
  int listcount = 48;

  @override
  Widget build(BuildContext context) {
    var device = MediaQuery.of(context).size;
    return Container(
      color: Colors.black,
      child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 0.7,
              crossAxisCount: 3,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2),
          itemCount: listcount,
          itemBuilder: (BuildContext ctx, index) {
            return GestureDetector(
              onTap: (){
                if(index == listcount-1){
                  setState(() {
                    listcount+= 48;
                  });
                }
                else Navigator.push(context, MaterialPageRoute(builder: (context) => selectWallpaper(imagenum : index)));
              },
              child: Container(
                  alignment: Alignment.center,
                  child: Container(
                    height: device.width * 0.5,
                    width: device.width * 0.5,
                    decoration: const BoxDecoration(
                        //color: Colors.orange
                      image: DecorationImage(
                                fit: BoxFit.fitHeight,
                                image: AssetImage("assets/world.jpeg")
                            )
                    ),
                    child: index == listcount - 1 ?
                    Container(
                      color: Color(0x97000000),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.plus_circle,
                            color: Colors.white,
                            size: device.width * 0.08,
                          ),
                          Text(
                            "More",
                            style: TextStyle(
                                decoration: TextDecoration.none,
                                color: Colors.white,
                                fontSize: device.width * 0.05,
                                fontFamily: "Tiles",
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1.5),)
                        ],
                      ),
                    ) :
                    Center(
                      child: Text(
                        "$index",
                        style: const TextStyle(
                            decoration: TextDecoration.none,
                            color: Colors.white,
                            fontSize: 22,
                            fontFamily: "Tiles",
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.5
                        ),),
                    ),
                  )
              ),
            );
          }),
    );
  }
}
