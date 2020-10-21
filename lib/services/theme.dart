import 'package:flutter/material.dart';

abstract class AppTheme {
  static get data {
    return ThemeData(
      fontFamily: 'Roboto',
      primaryColor: Color(0xFF6085FF),
      accentColor: Color(0xAA18B8B8),
    );
  }
}

get primeiraCor => Color(0xFF6085FF);

var appBarTitle = Row(
  mainAxisAlignment: MainAxisAlignment.center,
  mainAxisSize: MainAxisSize.min,
  children: [
    Text('M', style: TextStyle(fontWeight: FontWeight.bold)),
    Text('&',
        style: TextStyle(fontWeight: FontWeight.w300, fontFamily: 'Google')),
    Text('G', style: TextStyle(fontWeight: FontWeight.bold)),
  ],
);

class CustomAppBar {
  static getbar(context) {
    return AppBar(
        elevation: 0,
        brightness: Brightness.dark,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_none,
              size: 26,
            ),
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).pushNamed('/notificacoes');
            },
          ),
        ],
        backgroundColor: Theme.of(context).primaryColor,
        title: appBarTitle);
  }

  static paraDashboard(context, {Function callback, count}) {
    return AppBar(
      elevation: 0,
      brightness: Brightness.dark,
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(
            (count > 0) ? Icons.notifications_active : Icons.notifications_none,
            size: 26,
          ),
          color: Colors.white,
          onPressed: () {
            callback();
            Navigator.of(context).pushNamed('/notificacoes');
          },
        ),
      ],
      backgroundColor: Theme.of(context).primaryColor,
      title: appBarTitle,
    );
  }

  static paraDocumentos(context, Function callback) {
    return AppBar(
      elevation: 0,
      brightness: Brightness.dark,
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(
            Icons.add,
            size: 26,
          ),
          color: Colors.white,
          onPressed: callback,
        ),
      ],
      backgroundColor: Theme.of(context).primaryColor,
      title: appBarTitle,
    );
  }

  static semNotificacao(context) {
    return AppBar(
      brightness: Brightness.dark,
      centerTitle: true,
      backgroundColor: Theme.of(context).primaryColor,
      title: appBarTitle,
    );
  }
}
