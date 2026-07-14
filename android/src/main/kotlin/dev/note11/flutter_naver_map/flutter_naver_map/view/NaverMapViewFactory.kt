package dev.note11.flutter_naver_map.flutter_naver_map.view

import android.app.Activity
import android.content.Context
import dev.note11.flutter_naver_map.flutter_naver_map.FlutterNaverMapPlugin
import dev.note11.flutter_naver_map.flutter_naver_map.controller.overlay.OverlayController
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asNullableMap
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.NaverMapViewOptions
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

internal class NaverMapViewFactory(
    private val activity: Activity,
    private val messenger: BinaryMessenger,
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        val channel =
            MethodChannel(messenger, FlutterNaverMapPlugin.createViewMethodChannelName(viewId))
        val overlayChannel =
            MethodChannel(messenger, FlutterNaverMapPlugin.createOverlayMethodChannelName(viewId))
        val overlayController = OverlayController(overlayChannel, context)

        val convertedArgs = args!!.asNullableMap().toMutableMap()
        val usingGLSurfaceView = convertedArgs.remove("glsurface") as? Boolean
        val usingNativeCompass = convertedArgs.remove("nativeCompass") as? Boolean ?: false
        val options = NaverMapViewOptions.fromMessageable(convertedArgs)

        return NaverMapView(
            activity = activity,
            flutterProvidedContext = context,
            naverMapViewOptions = options,
            channel = channel,
            overlayController = overlayController,
            usingGLSurfaceView = usingGLSurfaceView,
            usingNativeCompass = usingNativeCompass,
        )
    }
}
