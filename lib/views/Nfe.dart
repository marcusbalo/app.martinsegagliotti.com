import 'package:flutter/material.dart';
import 'package:martinsegagliotti/services/responsive.dart';
import 'package:martinsegagliotti/services/theme.dart';

class Nfe extends StatelessWidget {
  const Nfe({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.getbar(context),
      body: Center(
          child: Text(
        'NENHUMA NOTA',
        style: TextStyle(
            fontSize: Responsive.width(4),
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold),
      )),
    );
  }
}
