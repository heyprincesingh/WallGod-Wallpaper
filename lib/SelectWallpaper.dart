import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';


List<String> originalFavouriteUrls = [];
bool available = false;
class selectWallpaper extends StatefulWidget {
  final int? imagenum;
  final List? imagesUrl;
  const selectWallpaper({Key? key, this.imagenum, this.imagesUrl}) : super(key: key);

  @override
  State<selectWallpaper> createState() => _selectWallpaperState();
}

class _selectWallpaperState extends State<selectWallpaper> {

  getFavouritewallUrl(originalimagesUrl) async {
    SharedPreferences originalFavouriteUrlspref = await SharedPreferences.getInstance();
    List<String>? originaltemp = originalFavouriteUrlspref.getStringList("originalFavouriteUrls") ?? null;
    if(originaltemp != null){
      available = originaltemp.contains(originalimagesUrl);
    }
    available ? Fluttertoast.showToast(msg: 'Already available in Favourites',
        toastLength: Toast.LENGTH_SHORT) :
    {
      originalFavouriteUrls = originaltemp ?? [],
      saveFavouritewallUrl(originalimagesUrl),
      Fluttertoast.showToast(msg: 'Added to Favourites',
          toastLength: Toast.LENGTH_SHORT)
    };
  }

  saveFavouritewallUrl(originalimagesUrl) async {
    originalFavouriteUrls.add("$originalimagesUrl");
    SharedPreferences originalFavouriteUrlspref = await SharedPreferences.getInstance();
    originalFavouriteUrlspref.setStringList("originalFavouriteUrls", originalFavouriteUrls);
  }

  @override
  Widget build(BuildContext context) {
    int? downloadindex = widget.imagenum;
    return Scaffold(
      body: Swiper(
        index: widget.imagenum,
          itemCount: widget.imagesUrl!.length,
          scrollDirection: Axis.horizontal,
          loop: false,
          onIndexChanged: (index){
            downloadindex = index;
          },
          itemBuilder: (BuildContext context,index){
            return Container(
              color: Colors.black,
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    child: Image.network(
                        "${this.widget.imagesUrl?[index]["src"]["large2x"]}",
                        fit: BoxFit.fitHeight,

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
                  ),
                  Positioned(
                      bottom: 0,
                      child: Container(
                        color: Colors.black38,
                          width: MediaQuery.of(context).size.width,
                          child: Center(child: Text("Image By ${this.widget.imagesUrl?[index]["photographer"]} on Pexels.com",
                          style: TextStyle(
                            fontSize: 8,
                            color: Colors.white),)
                          )
                      )
                  ),
                ],
              )
            );
          }
      ),
      floatingActionButton: SpeedDial(
        backgroundColor: Color(0xff2b2b2b),
        renderOverlay: false,
        animationAngle: 2.2,
        closeDialOnPop: true,
        spacing: 15,
        useRotationAnimation: true,
        elevation: 15,
        spaceBetweenChildren: 10,
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
            elevation: 20,
            child: Tooltip(
                message: "Download Wallpaper",
                child: Icon(Icons.save)),
            backgroundColor: Color(0xffd5d5d5),
            onTap: ()async{
              var actionsheet = CupertinoActionSheet(
                title: Text("Download",style: TextStyle(color: Colors.black87,fontSize: 20,fontWeight: FontWeight.w500)),
                actions: [
                  CupertinoActionSheetAction(onPressed: ()async{
                    Fluttertoast.showToast(msg: 'Downloading...',
                      toastLength: Toast.LENGTH_SHORT);
                    Navigator.of(context).pop();
                    String url = widget.imagesUrl?[downloadindex!]["src"]["original"];
                    final time = DateTime.now().toIso8601String().replaceAll('.', '-').replaceAll(':', '-');
                    String name = "WallGod-$time";
                    var status = await Permission.storage.request();
                    if(status.isGranted){
                      var response = await Dio().get(url,
                          options: Options(responseType: ResponseType.bytes));
                      final result = await ImageGallerySaver.saveImage(Uint8List.fromList(response.data),name: name);
                      Fluttertoast.showToast(msg: 'Download Complete',
                        toastLength: Toast.LENGTH_SHORT);
                    }
                  }, child: Text("Original - 4K",style: TextStyle(color: Colors.black87),)),
                  CupertinoActionSheetAction(onPressed: ()async{
                    Fluttertoast.showToast(msg: 'Downloading...',
                      toastLength: Toast.LENGTH_SHORT);
                    Navigator.of(context).pop();
                    String url = widget.imagesUrl?[downloadindex!]["src"]["large2x"];
                    final time = DateTime.now().toIso8601String().replaceAll('.', '-').replaceAll(':', '-');
                    String name = "WallGod-$time";
                    var status = await Permission.storage.request();
                    if(status.isGranted){
                      var response = await Dio().get(url,
                          options: Options(responseType: ResponseType.bytes));
                      final result = await ImageGallerySaver.saveImage(Uint8List.fromList(response.data),name: name);
                      Fluttertoast.showToast(msg: 'Download Complete',
                        toastLength: Toast.LENGTH_SHORT);
                    }
                  }, child: Text("Full HD",style: TextStyle(color: Colors.black87))),
                ],
              );
              showCupertinoModalPopup(context: context, builder: (context) => actionsheet);
              },
          ),
          SpeedDialChild(
              elevation: 20,
              child: Tooltip(
                  message: "Set Wallpaper",
                  child: Icon(Icons.wallpaper)),
              backgroundColor: Color(0xffd5d5d5),
              onTap: () async{
                var actionsheet = CupertinoActionSheet(
                  title: Text("Set as",style: TextStyle(color: Colors.black87,fontSize: 20,fontWeight: FontWeight.w500)),
                  actions: [
                    CupertinoActionSheetAction(onPressed: ()async{
                      await setwallLocation(downloadindex, context , 1);
                      Navigator.of(context).pop();
                    }, child: Text("Home Screen",style: TextStyle(color: Colors.black87),)),
                    CupertinoActionSheetAction(onPressed: ()async{
                      await setwallLocation(downloadindex, context , 2);
                      Navigator.of(context).pop();
                    }, child: Text("Lock Screen",style: TextStyle(color: Colors.black87))),
                    CupertinoActionSheetAction(onPressed: ()async{
                      await setwallLocation(downloadindex, context , 3);
                      Navigator.of(context).pop();
                    }, child: Text("Both",style: TextStyle(color: Colors.black87))),
                  ],
                );
                showCupertinoModalPopup(context: context, builder: (context) => actionsheet);
              },
             // label: "Set Wallpaper"
          ),
          SpeedDialChild(
              elevation: 20,
              child: Tooltip(
                  message: "Add to Favourite",
                  child: Icon(CupertinoIcons.heart_fill,color: Colors.red,)),
              backgroundColor: Color(0xffd5d5d5),
              onTap: (){
                getFavouritewallUrl(widget.imagesUrl?[downloadindex!]["src"]["original"]);
                },
             // label: "Favourite"
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Future<void> setwallLocation(int? downloadindex, BuildContext context, int setwallpaperAs) async {
    Fluttertoast.showToast(msg: 'Loading...',
        toastLength: Toast.LENGTH_SHORT);
    int location = 0;
    String url = widget.imagesUrl?[downloadindex!]["src"]["large2x"];
    if(setwallpaperAs == 1){location = WallpaperManager.HOME_SCREEN;}
    else if(setwallpaperAs == 2){location = WallpaperManager.LOCK_SCREEN;}
    else if(setwallpaperAs == 3){location = WallpaperManager.BOTH_SCREEN;}
    var file = await DefaultCacheManager().getSingleFile(url);
    var cropperdImage = await ImageCropper.cropImage(sourcePath: file.path,
        aspectRatio: CropAspectRatio(
            ratioX: MediaQuery.of(context).size.width,
            ratioY: MediaQuery.of(context).size.height),
        androidUiSettings: AndroidUiSettings(
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          toolbarTitle: "Crop Image",
          showCropGrid: false,
        )
    );
    bool result = await WallpaperManager.setWallpaperFromFile(cropperdImage!.path, location);
    Fluttertoast.showToast(msg: 'New wallpaper set',
        toastLength: Toast.LENGTH_SHORT);
  }
}