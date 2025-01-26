import 'package:flutter/material.dart';

class AppDetails {
  final Color _color;
  final Image _icon;
  String _name;
  String _shortDescription;
  String _appstore_url;
  String _playstore_url;

  Color get color {
    return _color;
  }

  Image get icon {
    return _icon;
  }

  String get name {
    return _name;
  }

  String get descr {
    return _shortDescription;
  }

  String get appstore_url {
    return _appstore_url;
  }

  String get playstore_url {
    return _playstore_url;
  }

  AppDetails(Color color, String name, Image icon, String shortDescription,
      String url1, url2)
      : _color = color,
        _name = name,
        _icon = icon,
        _shortDescription = shortDescription,
        _appstore_url = url1,
        _playstore_url = url2;
}

class Constants {
  static List<AppDetails> apps = [
    AppDetails(
        Colors.blue,
        "Sewa Health",
        const Image(image: AssetImage('assets/images/training_log.png')),
        "Physical fitness is important for a good life. This app enables you to track your activities.",
        "https://apps.apple.com/us/app/sewa-health/id1611594622",
        "https://play.google.com/store/apps/details?id=app.sewausa.self"),

  ];
}
