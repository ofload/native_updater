import 'package:flutter/material.dart';

class ErrorMaterialAlert extends StatelessWidget {
  final String appName;
  final String description;

  ErrorMaterialAlert({
    @required this.appName,
    @required this.description,
  });

  @override
  Widget build(BuildContext context) {
    Widget closeButton = FlatButton(
      child: Text('CLOSE'),
      color: Colors.green,
      textColor: Colors.white,
      onPressed: () => Navigator.pop(context),
    );

    return AlertDialog(
      title: Text(appName),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Can\'t perform update.',
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
