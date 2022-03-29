import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:wall_pexel/models/models.dart';
import 'package:wall_pexel/providers/wallpaper_provider.dart';
import 'package:wall_pexel/utils/utilities.dart';

class WallpaperViewer extends StatefulWidget {
  final Wallpaper wallpaper;
  const WallpaperViewer({required this.wallpaper});

  @override
  State<WallpaperViewer> createState() => _WallpaperViewerState();
}

class _WallpaperViewerState extends State<WallpaperViewer> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp, DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(fit: StackFit.expand, children: [
      Hero(tag: "image#${widget.wallpaper.id}", child: CachedNetworkImage(imageUrl: widget.wallpaper.portrait, fit: BoxFit.cover)),
      Padding(
          padding: EdgeInsets.all(20.sp),
          child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(onTap: () => Get.back(), child: Icon(Icons.cancel, color: Theme.of(context).primaryColor, size: 25.sp)),
                InkWell(
                    onTap: () => _showWallpaperDetailsSheet(),
                    child: Icon(Icons.info_outline_rounded, color: Theme.of(context).primaryColor, size: 25.sp)),
              ],
            ),
            InkWell(
                onTap: () => _showWallpaperTypeDialog(widget.wallpaper),
                child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10.sp),
                    width: double.maxFinite,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(10.sp)),
                    child: Text("Set as Wallpaper",
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14.sp))))
          ]))
    ]));
  }

  void _showWallpaperTypeDialog(Wallpaper _) {
    final wallpaperProvider = Get.put(WallpaperProvider());
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return Dialog(
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
                padding: EdgeInsets.all(20.sp),
                child: Text('Set Wallpaper', style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.bold, fontSize: 14.sp))),
            ListTile(
                title: Text('Home Screen', style: Theme.of(context).textTheme.bodyText1),
                leading: Icon(Icons.home),
                onTap: () => wallpaperProvider.setWallpaper(_, 1, context)),
            ListTile(
                title: Text('Lock Screen', style: Theme.of(context).textTheme.bodyText1),
                leading: Icon(Icons.lock),
                onTap: () => wallpaperProvider.setWallpaper(_, 2, context)),
            ListTile(
                title: Text('Home screen and lock screen', style: Theme.of(context).textTheme.bodyText1),
                leading: Icon(Icons.phone_android),
                onTap: () => wallpaperProvider.setWallpaper(_, 3, context))
          ]));
        });
  }

  void _showWallpaperDetailsSheet() => showModalBottomSheet(
      context: context,
      builder: (context) => _WallpaperDetails(wallpaper: widget.wallpaper),
      elevation: 10.sp,
      isScrollControlled: true,
      barrierColor: Colors.black12,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true);
}

class _WallpaperDetails extends StatelessWidget {
  final Wallpaper wallpaper;
  const _WallpaperDetails({required this.wallpaper});

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 30.h,
      padding: EdgeInsets.symmetric(vertical: 20.sp, horizontal: 10.sp),
      decoration: BoxDecoration(borderRadius: BorderRadius.vertical(top: Radius.circular(20.sp)), color: Theme.of(context).backgroundColor),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [_contentWithTitle(context, "id", "#${wallpaper.id}"), _colorBox(wallpaper.averageColor)],
            ),
            if (wallpaper.alt.isNotEmpty) _contentWithTitle(context, "tags", wallpaper.alt),
            _contentWithTitle(context, "dimensions", "${wallpaper.height}x${wallpaper.width}"),
            if (wallpaper.photographer_name != null && wallpaper.photographer_id != null)
              _contentWithTitle(context, "photographer", wallpaper.photographer_name! + "#" + wallpaper.photographer_id!.toString()),
          ],
        ),
      ),
    );
  }

  Widget _contentWithTitle(BuildContext context, String title, String content) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.sp),
      child: RichText(
          text: TextSpan(children: [
        TextSpan(
            text: title.toUpperCase() + " : ", style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 10.sp, fontWeight: FontWeight.bold)),
        TextSpan(text: content, style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 14.sp))
      ])),
    );
  }

  Widget _colorBox(String color) {
    return Container(
      height: 25.sp,
      width: 25.sp,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.sp),
        color: fromHex(color),
        border: Border.all(color: Colors.black38, width: 2.sp),
      ),
    );
  }
}
