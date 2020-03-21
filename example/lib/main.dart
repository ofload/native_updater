import 'package:flutter/material.dart';
import 'package:native_updater/native_updater.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'native_updater example',
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    checkVersion();
  }

  Future<void> checkVersion() async {
    /// For example: You got status code of 412 from the
    /// response of HTTP request.
    /// Let's say the statusCode 412 is requires you to force update
    int statusCode = 412;

    /// This could be kept in our local
    int currentVersion = 1;

    /// This could get from the API
    int newVersion = 2;

    Future.delayed(Duration.zero, () {
      if (statusCode == 412) {
        NativeUpdater.displayUpdateAlert(
          context: context,
          forceUpdate: true,
          // appStoreUrl: '<Your App Store URL>',
          // titlePrefix: 'Perbaharui',
          // description: '<Your description>',
          // updateButtonLabel: 'Perbaharui',
          // closeButtonLabel: 'Tutup',
        );
      } else if (currentVersion < newVersion) {
        NativeUpdater.displayUpdateAlert(
          context: context,
          forceUpdate: false,
          // appStoreUrl: '<Your App Store URL>',
          // titlePrefix: 'Perbaharui',
          // description: '<Your description>',
          // updateButtonLabel: 'Perbaharui',
          // ignoreButtonLabel: 'Nanti',
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your App'),
      ),
      body: Center(
        child: Text('Testing...'),
      ),
    );
  }
}
