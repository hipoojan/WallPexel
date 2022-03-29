package com.hi.wall_pexel

import java.io.IOException
import android.app.WallpaperManager
import android.os.Build
import android.annotation.TargetApi
import android.content.Context
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

private const val CHANNEL = "SET_WALLPAPER_CHANNEL"
class MainActivity: FlutterActivity() {

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "setWallpaper") {
                val arguments = call.arguments as ArrayList<*>
                val setWallpaper = setWallpaper(arguments[0] as ByteArray, applicationContext, arguments[1] as Int)
                if (setWallpaper == 0) {
                    result.success(setWallpaper)
                } else {
                    result.error("Failed to set wallpaper!", "", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    @TargetApi(Build.VERSION_CODES.N)
    private fun setWallpaper(imageByte: ByteArray, applicationContext: Context, wallpaperType: Int): Int {
        var setWallpaper = 1
        val stream = imageByte.inputStream()
        val wallpaperManager: WallpaperManager? = WallpaperManager.getInstance(applicationContext)
        setWallpaper = try {
            wallpaperManager?.setStream(stream, null, false, wallpaperType)
            0
        } catch (e: IOException) {
            1
        }

        return setWallpaper
    }
}
