import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:wall_pexel/providers/wallpaper_provider.dart';
import 'package:wall_pexel/widgets/widgets.dart';

class Home extends StatelessWidget {
  final wallpaperProvider = Get.put(WallpaperProvider());

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Column(
          children: [
            _appBar(context),
            Expanded(child: _wallpaperGrid(context)),
          ],
        ),
        _lineOverlay(context),
        _randomizeFAB()
      ],
    );
  }

  Widget _wallpaperGrid(BuildContext context) {
    return Container(
        color: Theme.of(context).backgroundColor,
        child: FutureBuilder(
            future: wallpaperProvider.getWallpapers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return GetBuilder(
                  init: wallpaperProvider,
                  builder: (controller) => MasonryGridView.count(
                    crossAxisCount: 2,
                    controller: wallpaperProvider.scrollController,
                    crossAxisSpacing: 5.sp,
                    itemCount: wallpaperProvider.wallpapers.length,
                    physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                    itemBuilder: (BuildContext context, int index) => WallpaperItem(index: index, wallpaper: wallpaperProvider.wallpapers[index]),
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting)
                return Center(
                  child: SizedBox(
                    height: 50.sp,
                    width: 50.sp,
                    child: CircularProgressIndicator(color: Color(0xff0044e5), strokeWidth: 5.sp),
                  ),
                );
              else
                return _emptyWidget(context);
            }));
  }

  Widget _randomizeFAB() {
    return Container(
      margin: EdgeInsets.only(bottom: 20.sp),
      child: FloatingActionButton(
        onPressed: () => wallpaperProvider.getWallpapers(isRandom: true),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.sp)),
        child: Icon(FontAwesomeIcons.shuffle),
      ),
    );
  }

  Widget _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).backgroundColor,
      toolbarHeight: 8.h,
      elevation: 0,
      leadingWidth: 0,
      automaticallyImplyLeading: false,
      title: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.sp),
        child: RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 18.sp, fontWeight: FontWeight.bold),
            children: [
              TextSpan(text: "WallPexe"),
              TextSpan(
                  text: "!",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: Theme.of(context).primaryColor, fontSize: 18.sp, fontWeight: FontWeight.bold))
            ],
          ),
        ),
      ),
    );
  }

  Widget _lineOverlay(BuildContext context) {
    return GetBuilder(
        init: wallpaperProvider,
        builder: (controller) {
          if (wallpaperProvider.wallpapers.isNotEmpty)
            return IgnorePointer(
              child: Container(height: 100.h, width: 5.sp, color: Theme.of(context).primaryColor),
            );
          else
            return Container();
        });
  }

  Widget _emptyWidget(BuildContext context) {
    return Center(
      child: Text(
        "Couldn't fetch any Wallpapers\n\n😞",
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 18.sp),
      ),
    );
  }
}
