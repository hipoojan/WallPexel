import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:wall_pexel/models/models.dart';
import 'package:wall_pexel/utils/routes.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

const int WALL_AMOUNT = 40, MAX_PAGES = 200;
const platform = const MethodChannel("SET_WALLPAPER_CHANNEL");

class WallpaperProvider extends GetxController {
  ScrollController scrollController = ScrollController();
  List<Wallpaper> wallpapers = [];
  int _page = 1;
  Dio _dio = new Dio();

  void onInit() {
    _dio.options.headers["Authorization"] = API_KEY;
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent == scrollController.position.pixels) getWallpapersPerPage();
    });
  }

  Future<void> getWallpapers({isRandom = false}) async {
    try {
      final response = await _dio.get(getWallpaperRoute(isRandom ? Random().nextInt(100) : 0, WALL_AMOUNT));
      if (response.statusCode == 200) {
        wallpapers = Wallpaper.decode(response.data["photos"]);
        if (isRandom) _page = int.parse(response.data["next_page"].toString().split("?")[1].split("&")[0].split("=")[1]);
        update();
      }
    } on DioError catch (e) {
      print(e.message);
    }
  }

  Future<void> getWallpapersPerPage() async {
    try {
      final response = await _dio.get(getWallpaperRoute(_page, WALL_AMOUNT));
      if (response.statusCode == 200) {
        List<Wallpaper> _w = Wallpaper.decode(response.data["photos"]);
        _w.forEach((e) {
          if (wallpapers.any((ee) => ee.id != e.id)) wallpapers.add(e);
        });
        _page = int.parse(response.data["next_page"].toString().split("?")[1].split("&")[0].split("=")[1]);
        update();
      }
    } on DioError catch (e) {
      print(e.message);
    }
  }

  Future<void> setWallpaper(Wallpaper _, int type, BuildContext context) async {
    File file = await DefaultCacheManager().getSingleFile(_.original);
    try {
      await platform.invokeMethod('setWallpaper', [file.readAsBytesSync(), type]).then((value) {
        if (value == 0) {
          Fluttertoast.showToast(msg: "Wallpaper Changed!", backgroundColor: Colors.green);
          Navigator.pop(context);
          Navigator.pop(context);
        }
      });
    } on PlatformException catch (e) {
      print(e);
    }
  }
}
