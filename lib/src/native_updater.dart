import 'dart:io';

import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

import 'updgrade_material_alert.dart';
import 'upgrade_cupertino_alert.dart';

class NativeUpdater {
  String _appName;
  String _packageName;
  String _appStoreUrl;

  /// Singleton
  static final NativeUpdater _singleton = NativeUpdater._internal();
  factory NativeUpdater() => _singleton;
  NativeUpdater._internal();

  /// Checking New Version
  static displayUpdateAlert({
    @required BuildContext context,
    @required bool requiresUpdate,
    String appStoreUrl,
  }) async {
    /// Get Current installed version of app
    final PackageInfo info = await PackageInfo.fromPlatform();

    if (requiresUpdate) {
      _singleton._appName = info.appName;
      _singleton._packageName = info.packageName;
      _singleton._appStoreUrl = appStoreUrl;
      _singleton._showUpdateAlertDialog(context);
    }
  }

  /// Base Alert Dialog
  void _showUpdateAlertDialog(BuildContext context) {
    Widget alert;

    /// Set up the AlertDialog
    if (Platform.isIOS) {
      alert = UpgradeCupertinoAlert(
        appName: _appName,
        appStoreUrl: _appStoreUrl,
      );
    } else {
      alert = UpgradeMaterialAlert(
        appName: _appName,
        packageName: _packageName,
      );
    }

    /// Show the Dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
