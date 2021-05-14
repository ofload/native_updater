import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateCupertinoAlert extends StatelessWidget {
  final bool forceUpdate;
  final String appName;
  final String appStoreUrl;
  final String description;
  final String updateButtonLabel;
  final String closeButtonLabel;
  final String ignoreButtonLabel;
  final String alertTitle;

  UpdateCupertinoAlert({
    required this.forceUpdate,
    required this.appName,
    required this.appStoreUrl,
    required this.description,
    required this.updateButtonLabel,
    required this.closeButtonLabel,
    required this.ignoreButtonLabel,
    required this.alertTitle,
  });

  @override
  Widget build(BuildContext context) {
    /// Set up the Buttons
    Widget closeAppButton = CupertinoDialogAction(
      child: Text(closeButtonLabel),
      onPressed: () => exit(0),
    );

    Widget ignoreButton = CupertinoDialogAction(
      child: Text(ignoreButtonLabel),
      onPressed: () => Navigator.pop(context),
    );

    Widget updateButton = CupertinoDialogAction(
      child: Text(updateButtonLabel),
      onPressed: () => launch(appStoreUrl),
    );

    return CupertinoAlertDialog(
      title: Text(alertTitle),
      content: Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Text(description),
      ),
      actions: [
        forceUpdate ? closeAppButton : ignoreButton,
        updateButton,
      ],
    );
  }
}
