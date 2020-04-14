import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:native_updater/src/native_updater.dart';
import 'package:native_updater/src/update_cupertino_alert.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  NativeUpdater nativeUpdater;
  bool forceUpdate;
  String anyString = 'Thundercats Hoo';
  String appStoreUrl = 'https://anyurl.xyz';

  setUp(() {
    nativeUpdater = NativeUpdater();
  });

  setSingletonPrivatePropertiesForCupertino(
    BuildContext context,
    bool forceUpdate,
  ) {
    nativeUpdater.setSingletonPrivatePropertiesForCupertino(
      context: context,
      forceUpdate: forceUpdate,
      appName: anyString,
      appStoreUrl: appStoreUrl,
      iOSDescription: anyString,
      iOSUpdateButtonLabel: anyString,
      iOSCloseButtonLabel: anyString,
      iOSIgnoreButtonLabel: anyString,
    );
  }

  group('Native Updater on iOS platform', () {
    testWidgets('should do immediate update if forceUpdate is true',
        (WidgetTester tester) async {
      forceUpdate = true;
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            setSingletonPrivatePropertiesForCupertino(context, forceUpdate);
            return Container();
          },
        ),
      ));

      nativeUpdater.showCupertinoAlertDialog();

      expect(nativeUpdater.getIOSAlert(), isA<UpdateCupertinoAlert>());
      expect(nativeUpdater.getIOSAlert().forceUpdate, forceUpdate);
    });

    testWidgets('should do flexible update if forceUpdate is false',
        (WidgetTester tester) async {
      forceUpdate = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (BuildContext context) {
              setSingletonPrivatePropertiesForCupertino(context, forceUpdate);
              return Container();
            },
          ),
        ),
      );

      nativeUpdater.showCupertinoAlertDialog();

      expect(nativeUpdater.getIOSAlert(), isA<UpdateCupertinoAlert>());
      expect(nativeUpdater.getIOSAlert().forceUpdate, forceUpdate);
    });

    testWidgets('should close the app if forceUpdate is refused by the user',
        (WidgetTester tester) async {
      /// To be implemented next
    });

    testWidgets(
        'should show a dialog with a button that links to store and a close app button if forceUpdate is true',
        (WidgetTester tester) async {
      /// To be implemented next
    });

    testWidgets(
        'should be able to dismiss the update dialog that contains link to the store if forceUpdate is false',
        (WidgetTester tester) async {
      /// To be implemented next
    });
  });
}
