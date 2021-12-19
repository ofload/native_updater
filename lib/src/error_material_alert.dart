import 'package:flutter/material.dart';

class ErrorMaterialAlert extends StatelessWidget {
  final String appName;
  final String description;
  final String? errorCloseButtonLabel;
  final String? errorSubtitle;

  ErrorMaterialAlert({
    required this.appName,
    required this.description,
    this.errorCloseButtonLabel,
    this.errorSubtitle,
  });

  @override
  Widget build(BuildContext context) {
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: Colors.green,
    );

    Widget closeButton = TextButton(
      child: Text(errorCloseButtonLabel ?? 'CLOSE', style: TextStyle(color: Colors.white)),
      onPressed: () => Navigator.pop(context),
      style: flatButtonStyle,
    );

    return AlertDialog(
      title: Text(appName),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            errorSubtitle ?? 'Can\'t perform update.',
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(height: 24.0),
          Text(description),
          SizedBox(height: 24.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              closeButton,
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
