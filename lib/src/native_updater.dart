import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:package_info/package_info.dart';

import 'error_material_alert.dart';
import 'update_cupertino_alert.dart';

class NativeUpdater {
  late BuildContext _context;
  late bool _forceUpdate;
  late String _appName;
  String? _appStoreUrl;
  String? _iOSDescription;
  String? _iOSUpdateButtonLabel;
  String? _iOSCloseButtonLabel;
  String? _iOSIgnoreButtonLabel;
  String? _iOSAlertTitle;
  String? _requireUpdateText;
  String? _recommendUpdateText;
  String? _errorText;
  String? _errorCloseButtonLabel;
  String? _errorSubtitle;

  /// Singleton related
  static final NativeUpdater _nativeUpdaterInstance = NativeUpdater._internal();
  factory NativeUpdater() => _nativeUpdaterInstance;
  NativeUpdater._internal();

  /// Displaying update alert
  static displayUpdateAlert(
    BuildContext context, {
    required bool forceUpdate,
    String? appStoreUrl,
    String? iOSDescription,
    String? iOSUpdateButtonLabel,
    String? iOSCloseButtonLabel,
    String? iOSIgnoreButtonLabel,
    String? iOSAlertTitle,
    String? requireUpdateText,
    String? recommendUpdateText,
    String? errorText,
    String? errorCloseButtonLabel,
    String? errorSubtitle,
  }) async {
    /// Get current installed version of app
    final PackageInfo info = await PackageInfo.fromPlatform();

    /// Set singleton properties
    _nativeUpdaterInstance._context = context;
    _nativeUpdaterInstance._forceUpdate = forceUpdate;
    _nativeUpdaterInstance._appName = info.appName;
    _nativeUpdaterInstance._appStoreUrl = appStoreUrl;
    _nativeUpdaterInstance._iOSDescription = iOSDescription;
    _nativeUpdaterInstance._iOSUpdateButtonLabel = iOSUpdateButtonLabel;
    _nativeUpdaterInstance._iOSCloseButtonLabel = iOSCloseButtonLabel;
    _nativeUpdaterInstance._iOSIgnoreButtonLabel = iOSIgnoreButtonLabel;
    _nativeUpdaterInstance._iOSAlertTitle = iOSAlertTitle;
    _nativeUpdaterInstance._requireUpdateText = requireUpdateText ?? 'requires that you update to the latest version. You cannot use this app until it is updated.';
    _nativeUpdaterInstance._recommendUpdateText = recommendUpdateText ?? 'recommends that you update to the latest version. You can keep using this app while downloading the update.';
    _nativeUpdaterInstance._errorText = errorText;
    _nativeUpdaterInstance._errorCloseButtonLabel = errorCloseButtonLabel;
    _nativeUpdaterInstance._errorSubtitle = errorSubtitle;
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
          '$_appName $_requireUpdateText';
    } else {
      selectedDefaultDescription =
          '$_appName $_recommendUpdateText';
    }

    Widget alert = UpdateCupertinoAlert(
      forceUpdate: _forceUpdate,
      appName: _appName,
      appStoreUrl: _appStoreUrl!,
      description: _iOSDescription ?? selectedDefaultDescription,
      updateButtonLabel: _iOSUpdateButtonLabel ?? 'Update',
      closeButtonLabel: _iOSCloseButtonLabel ?? 'Close App',
      ignoreButtonLabel: _iOSIgnoreButtonLabel ?? 'Later',
      alertTitle: _iOSAlertTitle ?? 'Update Available',
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
    /// In App Update Related
    try {
      AppUpdateInfo _updateInfo = await InAppUpdate.checkForUpdate();

      if (_updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
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
                _errorText ?? 'This version of $_appName was not installed from Google Play Store.',
            errorCloseButtonLabel:_errorCloseButtonLabel,
            errorSubtitle: _errorSubtitle,
          );
        },
      );
    }
  }
}
