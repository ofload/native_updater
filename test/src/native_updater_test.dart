import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:native_updater/src/native_updater.dart';
import 'package:in_app_update/in_app_update.dart';

class MockNativeUpdater extends Mock implements NativeUpdater {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  MockNativeUpdater nativeUpdater;

  setUp(() {
    nativeUpdater = MockNativeUpdater();
  });

  group('Native Updater Test', () {
    bool tForceUpdate;

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
      if (tForceUpdate == true) {
        verify(InAppUpdate.startFlexibleUpdate()).called(1);
      }
    });
  });
}
