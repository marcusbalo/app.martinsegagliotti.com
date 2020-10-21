import 'package:flutter/material.dart';
import 'package:martinsegagliotti/services/get_in_app_data.dart';
import 'package:martinsegagliotti/services/responsive.dart';
import 'package:martinsegagliotti/views/ler_mensagem.dart';
import 'package:martinsegagliotti/widgets/DismissBackground.dart';
import 'package:martinsegagliotti/widgets/default_bottom_sheet.dart';

class ItemMensagem extends StatelessWidget {
  final String title;
  final int id;
  final String last;
  final Function callback;
  final photo;
  final int unread;
  const ItemMensagem({
    Key key,
    this.title,
    this.id,
    this.callback,
    this.last,
    this.photo,
    this.unread,
  }) : super(key: key);

  static ItemMensagem from(Map<String, dynamic> m, Function callback) {
    return ItemMensagem(
      photo: m['photo'],
      title: m['title'],
      id: m['id'],
      last: m['lastmessage'],
      unread: m['unread'],
      callback: callback,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      onDismissed: (_) async {
        showDialog(
          context: context,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
        var result = await GetInAppData.apagarMensagem(this.id);
        if (result) {
          callback();
          Navigator.of(context).pop();
          successDialog(context);
        } else {
          Navigator.of(context).pop();
          errorDialog(context);
        }
      },
      confirmDismiss: (_) async {
        return await confirmar(context);
      },
      direction: DismissDirection.startToEnd,
      background: DismissBackground(),
      key: ValueKey(this.id),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
              return LerMensagem(
                  id: this.id, photo: this.photo, name: this.title);
            }));
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).primaryColor.withAlpha(30),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                radius: Responsive.width(6),
                backgroundImage: NetworkImage(this.photo),
              ),
              title: Text(
                this.title,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Builder(
                builder: (context) {
                  if (this.unread > 0) {
                    return Container(
                      color: Colors.blue,
                      padding: EdgeInsets.all(4),
                      child: Text(
                        unread.toString(),
                        style: TextStyle(
                            color: Colors.white, fontSize: Responsive.width(4)),
                      ),
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(
                  this.last,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: Responsive.width(3.5),
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
