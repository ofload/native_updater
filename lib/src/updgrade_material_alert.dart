import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UpgradeMaterialAlert extends StatelessWidget {
  final String appName;
  final String newVersion;
  final String packageName;

  UpgradeMaterialAlert({
    @required this.appName,
    @required this.newVersion,
    @required this.packageName,
  });

  @override
  Widget build(BuildContext context) {
    /// Set up the Buttons
    Widget noThanksButton = FlatButton(
      child: Text("NO THANKS"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    Widget updateButton = FlatButton(
      child: Text("UPDATE"),
      color: Colors.blue,
      textColor: Colors.white,
      onPressed: () {
        String basePlayStoreUrl =
            'http://play.google.com/store/apps/details?id=';
        launch(basePlayStoreUrl + packageName);
      },
    );

    return AlertDialog(
      title: Text("Update $appName?"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Latest version: $newVersion',
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(height: 24.0),
          Text(
            "$appName recommends that you update to the latest version. You can keep using this app while downloading the update.",
          ),
          SizedBox(height: 24.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              noThanksButton,
              updateButton,
            ],
          ),
          SizedBox(height: 16.0),
          Divider(),
          SizedBox(height: 16.0),
          Image.network(
            'https://www.gstatic.com/android/market_images/web/play_prism_hlock_2x.png',
            width: 120.0,
          ),
        ],
      ),
    );
  }
}
