import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:package_info/package_info.dart';

import 'error_material_alert.dart';
import 'update_cupertino_alert.dart';

class NativeUpdater {
  BuildContext _context;
  bool _forceUpdate;
  String _appName;
  String _appStoreUrl;
  String _playStoreUrl;
  String _iOSDescription;
  String _iOSUpdateButtonLabel;
  String _iOSCloseButtonLabel;
  String _iOSIgnoreButtonLabel;
  String _iOSCustomTitle;

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
    String iOSDescription,
    String iOSUpdateButtonLabel,
    String iOSCloseButtonLabel,
    String iOSIgnoreButtonLabel,
    String iOSCustomTitle,
  }) async {
    /// Get current installed version of app
    final PackageInfo info = await PackageInfo.fromPlatform();

    /// Set singleton properties
    _nativeUpdaterInstance._context = context;
    _nativeUpdaterInstance._forceUpdate = forceUpdate;
    _nativeUpdaterInstance._appName = info.appName;
    _nativeUpdaterInstance._appStoreUrl = appStoreUrl;
    _nativeUpdaterInstance._playStoreUrl = playStoreUrl;
    _nativeUpdaterInstance._iOSDescription = iOSDescription;
    _nativeUpdaterInstance._iOSUpdateButtonLabel = iOSUpdateButtonLabel;
    _nativeUpdaterInstance._iOSCloseButtonLabel = iOSCloseButtonLabel;
    _nativeUpdaterInstance._iOSIgnoreButtonLabel = iOSIgnoreButtonLabel;
    _nativeUpdaterInstance._iOSCustomTitle = iOSCustomTitle;

    /// Show the alert based on current platform
    if (Platform.isIOS) {
      _nativeUpdaterInstance._showCupertinoAlertDialog();
    } else {
      _nativeUpdaterInstance._showMaterialAlertDialog();
    }
  }

  void _showCupertinoAlertDialog() {
    /// Switch description based on whether it is force update or not.
    String selectedDefaultDescription;

    if (_forceUpdate) {
      selectedDefaultDescription =
          '$_appName requires that you update to the latest version. You cannot use this app until it is updated.';
    } else {
      selectedDefaultDescription =
          '$_appName recommends that you update to the latest version. You can keep using this app while downloading the update.';
    }

    Widget alert = UpdateCupertinoAlert(
      forceUpdate: _forceUpdate,
      appName: _appName,
      appStoreUrl: _appStoreUrl,
      description: _iOSDescription ?? selectedDefaultDescription,
      updateButtonLabel: _iOSUpdateButtonLabel ?? 'Update',
      closeButtonLabel: _iOSCloseButtonLabel ?? 'Close App',
      ignoreButtonLabel: _iOSIgnoreButtonLabel ?? 'Later',
      customTitle: _iOSCustomTitle ?? 'Update Available',
    );

    showDialog(
      context: _context,
      barrierDismissible: _forceUpdate ? false : true,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _showMaterialAlertDialog() async {
    developer.log('Playstore URL: ${_playStoreUrl ?? ''}');

    /// In App Update Related
    try {
      AppUpdateInfo _updateInfo = await InAppUpdate.checkForUpdate();

      if (_updateInfo?.updateAvailable == true) {
        if (_forceUpdate == true) {
          InAppUpdate.performImmediateUpdate()
              .catchError((e) => developer.log(e.toString()));
        } else if (_forceUpdate == false) {
          InAppUpdate.startFlexibleUpdate()
              .catchError((e) => developer.log(e.toString()));
        }
      }
    } on PlatformException catch (e) {
      developer.log(e.code.toString());

      showDialog(
        context: _context,
        builder: (BuildContext context) {
          return ErrorMaterialAlert(
            appName: _appName,
            description:
                'This version of $_appName was not installed from Google Play Store.',
          );
        },
      );
    }
  }
}
