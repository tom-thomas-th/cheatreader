import 'package:cheatreader/src/platform_window_controller_desktop.dart';
import 'package:cheatreader/src/reader_settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

final _fakeDisplayJson = <String, dynamic>{
  'id': '0',
  'name': 'fakeDisplay',
  'size': {'width': 1920.0, 'height': 1080.0},
  'visiblePosition': {'dx': 0.0, 'dy': 0.0},
  'visibleSize': {'width': 1280.0, 'height': 720.0},
  'scaleFactor': 1,
};

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const windowManagerChannel = MethodChannel('window_manager');
  const screenRetrieverChannel = MethodChannel(
    'dev.leanflutter.plugins/screen_retriever',
  );
  late List<MethodCall> calls;

  setUp(() {
    calls = <MethodCall>[];
    debugDefaultTargetPlatformOverride = TargetPlatform.windows;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(windowManagerChannel, (call) async {
          calls.add(call);
          return switch (call.method) {
            'isFullScreen' || 'isMaximized' || 'isMinimized' => false,
            'isVisible' || 'isFocused' => true,
            'getBounds' => <String, double>{
              'x': 0,
              'y': 0,
              'width': 760,
              'height': 308,
            },
            'setResizable' ||
            'setAsFrameless' ||
            'setOpacity' ||
            'setHasShadow' ||
            'show' ||
            'focus' ||
            'setTitleBarStyle' ||
            'setBounds' ||
            'setMinimumSize' ||
            'setTitle' ||
            'setIcon' ||
            'setAlwaysOnTop' ||
            'setSkipTaskbar' ||
            'setIgnoreMouseEvents' ||
            'hide' => null,
            _ => null,
          };
        });
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(screenRetrieverChannel, (call) async {
          return switch (call.method) {
            'getPrimaryDisplay' => _fakeDisplayJson,
            'getAllDisplays' => {
              'displays': [_fakeDisplayJson],
            },
            'getCursorScreenPoint' => {'dx': 0.0, 'dy': 0.0},
            _ => null,
          };
        });
  });

  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(windowManagerChannel, null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(screenRetrieverChannel, null);
  });

  test('initialization applies the preset window and taskbar icon', () async {
    final controller = DesktopPlatformWindowController();
    final settings = ReaderSettings.defaults.copyWith(
      appDisguisePreset: ReaderAppDisguisePreset.terminal,
    );

    await controller.initialize(settings: settings);

    final setIconCall = calls.firstWhere((call) => call.method == 'setIcon');
    expect(
      (setIconCall.arguments as Map<Object?, Object?>)['iconPath'],
      contains('assets/disguise/terminal.ico'),
    );
  });

  test('boss key hides the window and removes it from the taskbar', () async {
    final controller = DesktopPlatformWindowController();

    await controller.hideForBossKey(ReaderSettings.defaults);

    expect(
      calls
          .where((call) => call.method == 'setSkipTaskbar')
          .map((call) => call.arguments as Map<Object?, Object?>),
      contains(containsPair('isSkipTaskbar', true)),
    );
    expect(calls.map((call) => call.method), contains('hide'));
    expect(
      calls
          .where((call) => call.method == 'setOpacity')
          .map((call) => call.arguments as Map<Object?, Object?>),
      isNot(contains(<Object?, Object?>{'opacity': 0.0})),
    );
  });

  test(
    'restoring boss key returns taskbar visibility to the saved setting',
    () async {
      final controller = DesktopPlatformWindowController();

      await controller.hideForBossKey(ReaderSettings.defaults);
      calls.clear();
      await controller.restoreFromBossKey(ReaderSettings.defaults);

      expect(
        calls
            .where((call) => call.method == 'setSkipTaskbar')
            .map((call) => call.arguments as Map<Object?, Object?>),
        contains(containsPair('isSkipTaskbar', false)),
      );
      expect(calls.map((call) => call.method), contains('show'));
    },
  );
}
