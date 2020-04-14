import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:native_updater/src/native_updater.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  NativeUpdater nativeUpdater;
  MethodChannel inAppUpdateChannel = const MethodChannel("in_app_update");
  bool isImmediateUpdateInvoked;
  bool isFlexibleUpdateInvoked;

  setUp(() {
    nativeUpdater = NativeUpdater();
    isImmediateUpdateInvoked = false;
    isFlexibleUpdateInvoked = false;

    inAppUpdateChannel.setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'checkForUpdate') {
        return {
          'updateAvailable': true,
          'immediateAllowed': true,
          'flexibleAllowed': true,
          'availableVersionCode': 10,
        };
      }

      if (methodCall.method == 'performImmediateUpdate') {
        isImmediateUpdateInvoked = true;
      }

      if (methodCall.method == 'startFlexibleUpdate') {
        isFlexibleUpdateInvoked = true;
      }

      return null;
    });
  });

  group('Native Updater on Android API level >= 21 platform', () {
    bool forceUpdate;

    test('should do immediate update if forceUpdate is true', () async {
      forceUpdate = true;
      nativeUpdater.setForceUpdate(forceUpdate);

      nativeUpdater.showMaterialAlertDialog();

      Future.delayed(Duration(seconds: 2), () {
        expect(isImmediateUpdateInvoked, true);
      });
    });

    test('should do flexible update if forceUpdate is false', () async {
      forceUpdate = false;
      nativeUpdater.setForceUpdate(forceUpdate);

      nativeUpdater.showMaterialAlertDialog();

      Future.delayed(Duration(seconds: 2), () {
        expect(isFlexibleUpdateInvoked, true);
      });
    });
  });

  group('Native Updater on Android API level < 21 platform', () {
    group('if forceUpdate is true', () {
      test(
          'app pops up a material alert with 2 options (got to store and close app)',
          () async {
        /// To be implemented next
      });

      test('app exits after ignoring the update', () async {
        /// To be implemented next
      });
    });

    group('if forceUpdate is false', () {
      test(
          'app pops up a material alert with 2 options (dismiss and go to store)',
          () async {
        /// To be implemented next
      });

      test('dialogue is dismissable', () async {
        /// To be implemented next
      });
    });
  });

  tearDown(() {
    inAppUpdateChannel.setMockMethodCallHandler(null);
  });
}
