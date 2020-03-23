import 'dart:io';

import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

import 'updgrade_material_alert.dart';
import 'upgrade_cupertino_alert.dart';

class NativeUpdater {
  bool _forceUpdate;
  String _appName;
  String _appStoreUrl;
  String _playStoreUrl;
  String _titlePrefix;
  String _description;
  String _updateButtonLabel;
  String _closeButtonLabel;
  String _ignoreButtonLabel;

  /// Singleton related
  static final NativeUpdater _nativeUpdaterInstance = NativeUpdater._internal();
  factory NativeUpdater() => _nativeUpdaterInstance;
  NativeUpdater._internal();

  /// Displaying update alert
  static displayUpdateAlert(
    BuildContext context, {
    @required bool forceUpdate,
    String appStoreUrl,
    String playStoreUrl,
    String titlePrefix,
    String description,
    String updateButtonLabel,
    String closeButtonLabel,
    String ignoreButtonLabel,
  }) async {
    /// Get current installed version of app
    final PackageInfo info = await PackageInfo.fromPlatform();

    /// Set singleton properties
    _nativeUpdaterInstance._forceUpdate = forceUpdate;
    _nativeUpdaterInstance._appName = info.appName;
    _nativeUpdaterInstance._appStoreUrl = appStoreUrl;
    _nativeUpdaterInstance._playStoreUrl = playStoreUrl;
    _nativeUpdaterInstance._titlePrefix = titlePrefix;
    _nativeUpdaterInstance._description = description;
    _nativeUpdaterInstance._updateButtonLabel = updateButtonLabel;
    _nativeUpdaterInstance._closeButtonLabel = closeButtonLabel;
    _nativeUpdaterInstance._ignoreButtonLabel = ignoreButtonLabel;

    /// Call the singleton private method for showing the alert dialog
    _nativeUpdaterInstance._showUpdateAlertDialog(context);
  }

  /// Base alert dialog
  void _showUpdateAlertDialog(BuildContext context) {
    /// Switch description based on whether it is force update or not.
    String selectedDefaultDescription;

    if (_forceUpdate) {
      selectedDefaultDescription =
          '$_appName requires that you update to the latest version. You cannot use this app until it is updated.';
    } else {
      selectedDefaultDescription =
          '$_appName recommends that you update to the latest version. You can keep using this app while downloading the update.';
    }

    /// Set up the alert based on current platform
    Widget alert;

    if (_forceUpdate) {
      selectedDefaultDescription =
          '$_appName requires that you update to the latest version. You cannot use this app until it is updated.';
    } else {
      selectedDefaultDescription =
          '$_appName recommends that you update to the latest version. You can keep using this app while downloading the update.';
    }

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
        playStoreUrl: _playStoreUrl,
        titlePrefix: _titlePrefix ?? 'Update',
        description: _description ?? selectedDefaultDescription,
        updateButtonLabel: _updateButtonLabel ?? 'UPDATE',
        closeButtonLabel: _closeButtonLabel ?? 'CLOSE APP',
        ignoreButtonLabel: _ignoreButtonLabel ?? 'LATER',
      );
    }

    /// Show the dialog
    showDialog(
      context: context,
      barrierDismissible: _forceUpdate ? false : true,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
