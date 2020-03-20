import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UpgradeCupertinoAlert extends StatelessWidget {
  final bool forceUpdate;
  final String appName;
  final String appStoreUrl;
  final String description;
  final String updateButtonLabel;
  final String closeButtonLabel;
  final String ignoreButtonLabel;

  UpgradeCupertinoAlert({
    @required this.forceUpdate,
    @required this.appName,
    @required this.appStoreUrl,
    @required this.description,
    @required this.updateButtonLabel,
    @required this.closeButtonLabel,
    @required this.ignoreButtonLabel,
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
      child: Text('Update'),
      onPressed: () => launch(appStoreUrl),
    );

    return CupertinoAlertDialog(
      title: Text("Update Available"),
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
