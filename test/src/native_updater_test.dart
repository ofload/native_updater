import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:native_updater/src/native_updater.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:native_updater/src/update_cupertino_alert.dart';

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
    inAppUpdateChannel.setMockMethodCallHandler((MethodCall methodCall) async{
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

  group('Native Updater Test', () {
    bool tForceUpdate;

    group('Android', () {
      test('Android platform should integrate In App Update', () async {
        nativeUpdater.showMaterialAlertDialog();
        find.byElementType(InAppUpdate);
      });

      test('Android platform should do immediate update if forceUpdate is true',
          () async {
        // arrange
        tForceUpdate = true;
        nativeUpdater.setForceUpdate(tForceUpdate);
        // act
        nativeUpdater.showMaterialAlertDialog();
        // assert
        Future.delayed(Duration(seconds: 2), () {
          expect(isImmediateUpdateInvoked, true);
        });
      });

      test('Android platform should do flexible update if forceUpdate is false',
          () async {
        // arrange
        tForceUpdate = false;
        nativeUpdater.setForceUpdate(tForceUpdate);
        // act
        nativeUpdater.showMaterialAlertDialog();
        // assert
        Future.delayed(Duration(seconds: 2), () {
          expect(isFlexibleUpdateInvoked, true);
        });
      });
    });

    group('iOS', () {
      final String tAppName = 'App Name';
      final String tAppStoreUrl = 'https://anyurl.com';
      final String tDescription = 'App Description';
      final String tUpdateButtonLabel = 'Update';
      final String tCloseButtonLabel = 'Close';
      final String tIgnoreButtonLabel = 'Later';

      test('iOS platform should show Cupertino Alert Style', () async {
        nativeUpdater.showCupertinoAlertDialog();
        find.byElementType(UpdateCupertinoAlert);
      });

      test('iOS platform should do immediate update if forceUpdate is true',
          () async {
        // arrange
        tForceUpdate = true;

        final tCupertinoAlert = UpdateCupertinoAlert(
          forceUpdate: tForceUpdate,
          appName: tAppName,
          appStoreUrl: tAppStoreUrl,
          description: tDescription,
          updateButtonLabel: tUpdateButtonLabel,
          closeButtonLabel: tCloseButtonLabel,
          ignoreButtonLabel: tIgnoreButtonLabel,
        );
        // act
        nativeUpdater.showCupertinoAlertDialog();
        // assert
        expect(tCupertinoAlert, contains(tForceUpdate == true));
      });

      test('iOS platform should do flexible update if forceUpdate is false',
          () async {
        // arrange
        tForceUpdate = false;

        final tCupertinoAlert = UpdateCupertinoAlert(
          forceUpdate: tForceUpdate,
          appName: tAppName,
          appStoreUrl: tAppStoreUrl,
          description: tDescription,
          updateButtonLabel: tUpdateButtonLabel,
          closeButtonLabel: tCloseButtonLabel,
          ignoreButtonLabel: tIgnoreButtonLabel,
        );
        // act
        nativeUpdater.showCupertinoAlertDialog();
        // assert
        expect(tCupertinoAlert, contains(tForceUpdate == false));
      });
    });
  });

  tearDown(() {
    inAppUpdateChannel.setMockMethodCallHandler(null);
  });
}
