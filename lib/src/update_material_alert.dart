import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateMaterialAlert extends StatelessWidget {
  final bool forceUpdate;
  final String appName;
  final String playStoreUrl;
  final String titlePrefix;
  final String description;
  final String updateButtonLabel;
  final String closeButtonLabel;
  final String ignoreButtonLabel;

  UpdateMaterialAlert({
    required this.forceUpdate,
    required this.appName,
    required this.playStoreUrl,
    required this.titlePrefix,
    required this.description,
    required this.updateButtonLabel,
    required this.closeButtonLabel,
    required this.ignoreButtonLabel,
  });

  @override
  Widget build(BuildContext context) {
    /// Set up the Buttons
    Widget closeAppButton = FlatButton(
      child: Text(closeButtonLabel.toUpperCase()),
      onPressed: () => exit(0),
    );

    Widget ignoreButton = FlatButton(
      child: Text(ignoreButtonLabel.toUpperCase()),
      onPressed: () => Navigator.pop(context),
    );

    Widget updateButton = FlatButton(
      child: Text(updateButtonLabel.toUpperCase()),
      color: Colors.blue,
      textColor: Colors.white,
      onPressed: () => launch(playStoreUrl),
    );

    return AlertDialog(
      title: Text(
          forceUpdate ? "$titlePrefix $appName" : "$titlePrefix $appName?"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'New version available',
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(height: 24.0),
          Text(description),
          SizedBox(height: 24.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              forceUpdate ? closeAppButton : ignoreButton,
              updateButton,
            ],
          ),
          SizedBox(height: 16.0),
          Divider(),
          SizedBox(height: 16.0),
          Image.asset(
            'packages/native_updater/images/google_play.png',
            width: 120.0,
          ),
        ],
      ),
    );
  }
}
