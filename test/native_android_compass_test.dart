import "dart:io";

import "package:flutter_test/flutter_test.dart";

void main() {
  test("Android native compass bypasses the Flutter camera stream layer", () {
    final widgetSource =
        File("lib/src/widget/map_widget.dart").readAsStringSync();
    final platformViewSource =
        File("lib/src/widget/platform_view.dart").readAsStringSync();
    final nativeViewSource = File(
      "android/src/main/kotlin/dev/note11/flutter_naver_map/flutter_naver_map/view/NaverMapView.kt",
    ).readAsStringSync();

    expect(widgetSource, contains("androidUseNativeCompass"));
    expect(
      widgetSource,
      contains("Platform.isAndroid && widget.androidUseNativeCompass"),
      reason: "The Flutter StreamBuilder compass must not render on Android.",
    );
    expect(platformViewSource, contains('"nativeCompass"'));
    expect(nativeViewSource, contains("configureNativeCompass"));
    expect(nativeViewSource, contains("CompassView(flutterProvidedContext)"));
    expect(nativeViewSource, contains("mapView.addView(compass"));
    expect(nativeViewSource, isNot(contains("controls.layoutParams")));
  });

  test("Android-only creation args are removed before map option decoding", () {
    final factorySource = File(
      "android/src/main/kotlin/dev/note11/flutter_naver_map/flutter_naver_map/view/NaverMapViewFactory.kt",
    ).readAsStringSync();

    final nativeCompassRemoval = factorySource.indexOf(
      'convertedArgs.remove("nativeCompass")',
    );
    final glSurfaceRemoval = factorySource.indexOf(
      'convertedArgs.remove("glsurface")',
    );
    final optionDecoding = factorySource.indexOf(
      "NaverMapViewOptions.fromMessageable(convertedArgs)",
    );

    expect(nativeCompassRemoval, greaterThanOrEqualTo(0));
    expect(glSurfaceRemoval, greaterThanOrEqualTo(0));
    expect(nativeCompassRemoval, lessThan(optionDecoding));
    expect(glSurfaceRemoval, lessThan(optionDecoding));
  });
}
