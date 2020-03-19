import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UpgradeCupertinoAlert extends StatelessWidget {
  final String appName;
  final String newVersion;
  final String appStoreUrl;

  UpgradeCupertinoAlert({
    @required this.appName,
    @required this.newVersion,
    @required this.appStoreUrl,
  });

  @override
  Widget build(BuildContext context) {
    /// Set up the Buttons
    Widget laterButton = CupertinoDialogAction(
      child: Text('Later'),
      onPressed: () {
        Navigator.of(context).pop();
      },
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
          "A new version of $appName is available. Please update to version $newVersion now.",
        ),
      ),
      actions: [
        laterButton,
        updateButton,
      ],
    );
  }
}
