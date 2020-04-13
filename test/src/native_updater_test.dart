import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
      bool tCupertinoForceUpdate;
      String tAppName = 'App Name';
      String tAppStoreUrl = 'https://anyurl.com';
      String tIOSDescription = 'App Description';
      String tIOSUpdateButtonLabel = 'Update';
      String tIOSCloseButtonLabel = 'Close';
      String tIOSIgnoreButtonLabel = 'Later';

      testWidgets(
          'iOS platform should do immediate update if forceUpdate is true',
          (WidgetTester tester) async {
        // arrange
        tCupertinoForceUpdate = true;

        await tester.pumpWidget(MaterialApp(
          home: Builder(
            builder: (BuildContext context) {
              nativeUpdater.setSingletonPrivatePropertiesForCupertino(
                context: context,
                forceUpdate: tCupertinoForceUpdate,
                appName: tAppName,
                appStoreUrl: tAppStoreUrl,
                iOSDescription: tIOSDescription,
                iOSUpdateButtonLabel: tIOSUpdateButtonLabel,
                iOSCloseButtonLabel: tIOSCloseButtonLabel,
                iOSIgnoreButtonLabel: tIOSIgnoreButtonLabel,
              );

              return Container();
            },
          ),
        ));
        // act
        nativeUpdater.showCupertinoAlertDialog();
        // assert
        expect(nativeUpdater.getIOSAlert(), isA<UpdateCupertinoAlert>());
        expect(nativeUpdater.getIOSAlert().forceUpdate, tCupertinoForceUpdate);
      });

      testWidgets(
          'iOS platform should do flexible update if forceUpdate is false',
          (WidgetTester tester) async {
        // arrange
        tCupertinoForceUpdate = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (BuildContext context) {
                nativeUpdater.setSingletonPrivatePropertiesForCupertino(
                  context: context,
                  forceUpdate: tCupertinoForceUpdate,
                  appName: tAppName,
                  appStoreUrl: tAppStoreUrl,
                  iOSDescription: tIOSDescription,
                  iOSUpdateButtonLabel: tIOSUpdateButtonLabel,
                  iOSCloseButtonLabel: tIOSCloseButtonLabel,
                  iOSIgnoreButtonLabel: tIOSIgnoreButtonLabel,
                );

                return Container();
              },
            ),
          ),
        );
        // act
        nativeUpdater.showCupertinoAlertDialog();
        // assert
        expect(nativeUpdater.getIOSAlert(), isA<UpdateCupertinoAlert>());
        expect(nativeUpdater.getIOSAlert().forceUpdate, tCupertinoForceUpdate);
      });
    });
  });

  tearDown(() {
    inAppUpdateChannel.setMockMethodCallHandler(null);
  });
}
