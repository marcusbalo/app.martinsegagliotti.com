import 'package:flutter/material.dart';
import 'package:martinsegagliotti/services/responsive.dart';
import 'package:martinsegagliotti/widgets/default_bottom_sheet.dart';

class ItemDocumento extends StatelessWidget {
  final String name;
  final String data;
  final int id;
  final String categoria;
  final String path;

  final Function downloadcallback;
  const ItemDocumento(
      {Key key,
      this.data = '',
      this.name,
      this.id,
      this.categoria,
      this.downloadcallback,
      this.path})
      : super(key: key);

  static _toDateString(String ugly) {
    DateTime date = DateTime.parse(ugly);
    String beaulty = '${date.day}/${date.month}/${date.year}';
    return beaulty;
  }

  static ItemDocumento from(Map<String, dynamic> m,
      {Function downloadcallback}) {
    return ItemDocumento(
        data: _toDateString(m['created_at']),
        name: m['name'],
        id: m['id'],
        categoria: m['category'],
        path: m['path'],
        downloadcallback: downloadcallback);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () async {
          bool result = await confirmar(context,
              customText: 'FAZER DOWNLOAD?',
              customIcon: Icons.file_download,
              customColor: Theme.of(context).accentColor);
          if (result) {
            downloadcallback(this.id, this.path);
          }
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).primaryColor.withAlpha(30),
          ),
          child: ListTile(
            title: Text(this.name,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: Responsive.width(4),
                  fontWeight: FontWeight.w300,
                )),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(
                '${this.data} :: ${this.categoria}',
                style: TextStyle(
                  fontSize: Responsive.width(3.5),
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
