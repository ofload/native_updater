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
  final String newVersionLabel;

  UpdateMaterialAlert({
    required this.forceUpdate,
    required this.appName,
    required this.playStoreUrl,
    required this.titlePrefix,
    required this.description,
    required this.updateButtonLabel,
    required this.closeButtonLabel,
    required this.ignoreButtonLabel,
    this.newVersionLabel = 'New version available'
  });

  @override
  Widget build(BuildContext context) {
    /// Set up the Buttons
    Widget closeAppButton = TextButton(
      child: Text(closeButtonLabel.toUpperCase()),
      onPressed: () => exit(0),
    );

    Widget ignoreButton = TextButton(
      child: Text(ignoreButtonLabel.toUpperCase()),
      onPressed: () => Navigator.pop(context),
    );

    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: Colors.blue,
    );

    Widget updateButton = TextButton(
      child: Text(updateButtonLabel.toUpperCase(),
          style: TextStyle(color: Colors.white)),
      style: flatButtonStyle,
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
            newVersionLabel,
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
