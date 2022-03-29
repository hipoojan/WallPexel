import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:wall_pexel/utils/utilities.dart';
import 'ui/uis.dart';

void main() => runApp(GetMaterialApp(home: Main(), debugShowCheckedModeBanner: false, theme: THEME));

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(OVERLAY_STYLE);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizerUtil.setScreenSize(constraints, orientation);
        return Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          body: Splash(),
        );
      });
    });
  }
}
