import 'package:darkwall/SelectWallpaper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

List? imagesUrl = null;
int page = 2;

class common_gridscreen extends StatefulWidget {
  common_gridscreen({Key? key}) : super(key: key);

  @override
  State<common_gridscreen> createState() => _common_gridscreenState();
}

class _common_gridscreenState extends State<common_gridscreen> {
  int listcount = 81;
  @override
  void initState(){
    getApidata();
    super.initState();
  }

  getApidata() async{
    await http.get(Uri.parse("https://api.pexels.com/v1/curated?per_page=80&page=1"),
        headers: {
          "Authorization":"563492ad6f91700001000001cfa06beb513d43d4a2dc798579d74e17"
        }).then((value){
      Map result = jsonDecode(value.body);
      setState(() {
        imagesUrl = result["photos"];
        imagesUrl = List.from(imagesUrl!.reversed);
        listcount = imagesUrl!.length + 1;
      });
    });
  }

  loadmore() async{
    setState(() {
      page++;
    });
    await http.get(Uri.parse("https://api.pexels.com/v1/curated?per_page=80&page=$page"),
        headers: {
          "Authorization":"563492ad6f91700001000001cfa06beb513d43d4a2dc798579d74e17"
        }).then((value){
      Map result = jsonDecode(value.body);
      setState(() {
        imagesUrl!.addAll(result["photos"]);
        listcount = imagesUrl!.length + 1;
      });
    });
  }


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
                  Fluttertoast.showToast(msg: 'Loading...',
                      toastLength: Toast.LENGTH_SHORT);
                  loadmore();
                }
                else Navigator.push(context, MaterialPageRoute(builder: (context) => selectWallpaper(imagenum : index,imagesUrl : imagesUrl)));
              },
              child: Container(
                  alignment: Alignment.center,
                  child: Container(
                    height: device.width * 0.5,
                    width: device.width * 0.5,
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
                      child: imagesUrl == null ?
                          CircularProgressIndicator(
                            color: Color(0xff3d3d3d),
                          ) :
                      Image.network(
                        imagesUrl?[index]["src"]["tiny"],
                        fit: BoxFit.cover,
                        height: device.width * 0.5,
                        width: device.width * 0.5,),
                    ),
                  )
              ),
            );
          }),
    );
  }
}
