import 'package:flutter/material.dart';

class DismissBackground extends StatelessWidget {
  const DismissBackground({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.red[400],
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
          child: Icon(
            Icons.delete_outline,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
    );
  }
}
