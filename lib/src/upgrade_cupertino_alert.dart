import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UpgradeCupertinoAlert extends StatelessWidget {
  final String appName;
  final String appStoreUrl;

  UpgradeCupertinoAlert({
    @required this.appName,
    @required this.appStoreUrl,
  });

  @override
  Widget build(BuildContext context) {
    /// Set up the Buttons
    Widget closeAppButton = CupertinoDialogAction(
      child: Text('Close App'),
      onPressed: () => exit(0),
    );

    Widget updateButton = CupertinoDialogAction(
      child: Text('Update'),
      onPressed: () => launch(appStoreUrl),
    );

    return CupertinoAlertDialog(
      title: Text("Update Available"),
      content: Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Text(
          "$appName requires that you update to the latest version. You cannot use this app until it is updated.",
        ),
      ),
      actions: [
        closeAppButton,
        updateButton,
      ],
    );
  }
}
