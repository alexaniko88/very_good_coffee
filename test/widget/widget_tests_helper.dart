import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';

typedef OptionalWrapperCallback = Widget Function(Widget widget);

class WidgetTestsHelper {
  static bool runGoldenTests = true;

  static Future testWidget(
    WidgetTester tester,
    Widget widget, {
    required Future Function() doAfter,
    OptionalWrapperCallback? optionalWrapper,
    bool useScaffold = true,
    bool wrapWithMockNetworkImage = false,
  }) =>
      wrapWithMockNetworkImage
          ? mockNetworkImagesFor(
              () => _doPumpWidget(
                tester: tester,
                widget: widget,
                optionalWrapper: optionalWrapper,
                useScaffold: useScaffold,
                doAfter: doAfter,
              ),
            )
          : _doPumpWidget(
              tester: tester,
              widget: widget,
              optionalWrapper: optionalWrapper,
              useScaffold: useScaffold,
              doAfter: doAfter,
            );

  static Future _doPumpWidget({
    required WidgetTester tester,
    required Widget widget,
    required bool useScaffold,
    required Future Function() doAfter,
    OptionalWrapperCallback? optionalWrapper,
  }) async {
    await tester.pumpWidget(
      optionalWrapper != null
          ? optionalWrapper(
              _buildMaterialApp(
                tester: tester,
                useScaffold: useScaffold,
                widget: widget,
              ),
            )
          : _buildMaterialApp(
              tester: tester,
              useScaffold: useScaffold,
              widget: widget,
            ),
    );
    await doAfter.call();
  }

  static Widget _buildMaterialApp({
    required WidgetTester tester,
    required bool useScaffold,
    required Widget widget,
  }) {
    return MaterialApp(
      locale: const Locale('en', 'EN'),
      home: useScaffold
          ? Scaffold(
              body: widget,
            )
          : widget,
      debugShowCheckedModeBanner: false,
    );
  }

  static Future expectGolden(
    String name, {
    Type type = MaterialApp,
  }) async {
    if (runGoldenTests) {
      await expectLater(
        find.byType(type),
        matchesGoldenFile('golden/$name.png'),
      );
    }
  }
}
