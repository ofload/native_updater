import 'dart:io';

import 'package:flutter/material.dart';
import 'package:native_updater/native_updater.dart';
import 'package:dio/dio.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'native_updater DIO example',
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<void> checkVersion(int statusCode) async {
    /// For example: You got status code of 412 from the
    /// response of HTTP request.
    /// Let's say the statusCode 412 requires you to force update
    Future.delayed(Duration.zero, () {
      if (statusCode == HttpStatus.unauthorized) {
        NativeUpdater.displayUpdateAlert(
          context,
          forceUpdate: true,
          appStoreUrl: '<Your App Store URL>',
          iOSDescription: '<Your iOS description>',
          iOSUpdateButtonLabel: 'Upgrade',
          iOSCloseButtonLabel: 'Exit',
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
        child: TextButton(
            onPressed: requestAPI,
            child: Text('Request API')
        ),
      ),
    );
  }

  requestAPI() async {
    var dio = Dio(BaseOptions(
      baseUrl: 'http://httpbin.org/',
    ));

    try {
      Response response = await dio.get('/get');
    } on DioError catch (e) {
      checkVersion(e.response.statusCode);
    }
  }
}
