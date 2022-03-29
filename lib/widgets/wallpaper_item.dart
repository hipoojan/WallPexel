import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:wall_pexel/models/models.dart';
import 'package:wall_pexel/ui/uis.dart';

class WallpaperItem extends StatelessWidget {
  final int index;
  final Wallpaper wallpaper;
  const WallpaperItem({required this.index, required this.wallpaper});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => WallpaperViewer(wallpaper: wallpaper)),
      child: SizedBox(
        height: index % 2 == 0 ? 200.sp : 300.sp,
        child: Hero(
          tag: "image#${wallpaper.id}",
          child: CachedNetworkImage(imageUrl: wallpaper.portrait, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
