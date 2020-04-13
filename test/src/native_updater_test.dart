import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:native_updater/src/native_updater.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:native_updater/src/update_cupertino_alert.dart';

class MockNativeUpdater extends Mock implements NativeUpdater {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  MockNativeUpdater nativeUpdater;

  setUp(() {
    nativeUpdater = MockNativeUpdater();
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
        // act
        nativeUpdater.showMaterialAlertDialog();
        // assert
        if (tForceUpdate == true) {
          verify(InAppUpdate.performImmediateUpdate()).called(1);
        }
      });

      test('Android platform should do flexible update if forceUpdate is false',
          () async {
        // arrange
        tForceUpdate = false;
        // act
        nativeUpdater.showMaterialAlertDialog();
        // assert
        if (tForceUpdate == false) {
          verify(InAppUpdate.startFlexibleUpdate()).called(1);
        }
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
}
