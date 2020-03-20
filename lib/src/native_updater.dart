import 'dart:io';

import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

import 'updgrade_material_alert.dart';
import 'upgrade_cupertino_alert.dart';

class NativeUpdater {
  bool _forceUpdate;
  String _appName;
  String _packageName;
  String _appStoreUrl;
  String _titlePrefix;
  String _description;
  String _updateButtonLabel;
  String _closeButtonLabel;
  String _ignoreButtonLabel;

  /// Singleton
  static final NativeUpdater _singleton = NativeUpdater._internal();
  factory NativeUpdater() => _singleton;
  NativeUpdater._internal();

  /// Checking New Version
  static displayUpdateAlert({
    @required BuildContext context,
    @required bool forceUpdate,
    String appStoreUrl,
    String titlePrefix,
    String description,
    String updateButtonLabel,
    String closeButtonLabel,
    String ignoreButtonLabel,
  }) async {
    /// Get Current installed version of app
    final PackageInfo info = await PackageInfo.fromPlatform();

    _singleton._forceUpdate = forceUpdate;
    _singleton._appName = info.appName;
    _singleton._packageName = info.packageName;
    _singleton._appStoreUrl = appStoreUrl;
    _singleton._titlePrefix = titlePrefix;
    _singleton._description = description;
    _singleton._updateButtonLabel = updateButtonLabel;
    _singleton._closeButtonLabel = closeButtonLabel;
    _singleton._ignoreButtonLabel = ignoreButtonLabel;
    _singleton._showUpdateAlertDialog(context);
  }

  /// Base Alert Dialog
  void _showUpdateAlertDialog(BuildContext context) {
    Widget alert;
    String selectedDefaultDescription;

    if (_forceUpdate) {
      selectedDefaultDescription =
          '$_appName requires that you update to the latest version. You cannot use this app until it is updated.';
    } else {
      selectedDefaultDescription =
          '$_appName recommends that you update to the latest version. You can keep using this app while downloading the update.';
    }

    /// Set up the AlertDialog
    if (Platform.isIOS) {
      alert = UpgradeCupertinoAlert(
        forceUpdate: _forceUpdate,
        appName: _appName,
        appStoreUrl: _appStoreUrl,
        description: _description ?? selectedDefaultDescription,
        updateButtonLabel: _updateButtonLabel ?? 'Update',
        closeButtonLabel: _closeButtonLabel ?? 'Close App',
        ignoreButtonLabel: _ignoreButtonLabel ?? 'Later',
      );
    } else {
      alert = UpgradeMaterialAlert(
        forceUpdate: _forceUpdate,
        appName: _appName,
        packageName: _packageName,
        titlePrefix: _titlePrefix ?? 'Update',
        description: _description ?? selectedDefaultDescription,
        updateButtonLabel: _updateButtonLabel ?? 'UPDATE',
        closeButtonLabel: _closeButtonLabel ?? 'CLOSE APP',
        ignoreButtonLabel: _ignoreButtonLabel ?? 'LATER',
      );
    }

    /// Show the Dialog
    showDialog(
      context: context,
      barrierDismissible: _forceUpdate ? false : true,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
