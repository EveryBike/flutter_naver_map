import "dart:io";

import "package:flutter_test/flutter_test.dart";

void main() {
  test("hybrid composition skips the TLHC frame-copy invalidator", () {
    final platformView = File(
      "lib/src/widget/platform_view.dart",
    ).readAsStringSync();
    final factory = File(
      "android/src/main/kotlin/dev/note11/flutter_naver_map/"
      "flutter_naver_map/view/NaverMapViewFactory.kt",
    ).readAsStringSync();
    final mapView = File(
      "android/src/main/kotlin/dev/note11/flutter_naver_map/"
      "flutter_naver_map/view/NaverMapView.kt",
    ).readAsStringSync();

    expect(platformView, contains('"hybrid": forceHybridComposition == true'));
    expect(factory, contains("usingHybridComposition"));
    expect(mapView, contains("if (!usingHybridComposition)"));
    expect(
      mapView.indexOf("if (!usingHybridComposition)"),
      lessThan(mapView.indexOf("TextureSurfaceViewUtil.installInvalidator")),
    );
  });
}
