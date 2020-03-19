import 'dart:io';

import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

import 'updgrade_material_alert.dart';
import 'upgrade_cupertino_alert.dart';

class NativeUpdater {
  String _appName;
  String _latestVersion;
  String _packageName;
  String _appStoreUrl;

  /// Singleton
  static final NativeUpdater _singleton = NativeUpdater._internal();
  factory NativeUpdater() => _singleton;
  NativeUpdater._internal();

  /// Checking New Version
  static versionCheck({
    @required BuildContext context,
    String appStoreUrl,
  }) async {
    /// Get Current installed version of app
    final PackageInfo info = await PackageInfo.fromPlatform();
    String currentVersion = info.version.trim().replaceAll("[a-zA-Z]|-", "");

    // TODO: API call to server to get the latest App Version (sent in HTTP Headers)
    String latestVersion = '<Latest Version>';

    if (currentVersion != latestVersion) {
      _singleton._appName = info.appName;
      _singleton._latestVersion = latestVersion;
      _singleton._packageName = info.packageName;
      _singleton._appStoreUrl = appStoreUrl;
      _singleton._showUpgradeAlertDialog(context);
    }
  }

  /// Base Alert Dialog
  void _showUpgradeAlertDialog(BuildContext context) {
    Widget alert;

    /// Set up the AlertDialog
    if (Platform.isIOS) {
      alert = UpgradeCupertinoAlert(
        appName: _appName,
        newVersion: _latestVersion,
        appStoreUrl: _appStoreUrl,
      );
    } else {
      alert = UpgradeMaterialAlert(
        appName: _appName,
        newVersion: _latestVersion,
        packageName: _packageName,
      );
    }

    /// Show the Dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
