import 'package:flutter/material.dart';
import 'package:martinsegagliotti/services/get_in_app_data.dart';
import 'package:martinsegagliotti/services/responsive.dart';
import 'DismissBackground.dart';
import 'default_bottom_sheet.dart';

class ItemNotificacao extends StatefulWidget {
  final String status;
  final int id;
  final String procedimento;
  final String data;
  final String tipo;
  final List<dynamic> files;
  final Map<String, dynamic> lancamento;
  final Function fn;
  const ItemNotificacao({
    Key key,
    this.status = '',
    this.id = 0,
    this.procedimento = '',
    this.data = '',
    this.tipo = '',
    this.files = const [],
    this.lancamento,
    this.fn,
  }) : super(key: key);

  static ItemNotificacao from(Map<String, dynamic> d, Function fn) {
    return ItemNotificacao(
      data: d['date'],
      id: d['id'],
      procedimento: d['procedure'],
      status: d['status'],
      tipo: d['type'],
      files: d['files'],
      lancamento: d,
      fn: fn,
    );
  }

  @override
  _ItemNotificacaoState createState() => _ItemNotificacaoState();
}

class _ItemNotificacaoState extends State<ItemNotificacao> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(this.widget.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (_) async {
        showDialog(
          barrierDismissible: false,
          context: context,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
        var result = await GetInAppData.confirmarNotificacao(widget.id);
        if (result) {
          widget.fn();
          Navigator.of(context).pop();
          successDialog(context);
        } else {
          widget.fn();
          Navigator.of(context).pop();
          errorDialog(context);
        }
      },
      confirmDismiss: (_) async {
        return await confirmar(context);
      },
      background: DismissBackground(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: InkWell(
          onTap: () {
            Navigator.of(context)
                .popUntil(ModalRoute.withName('/notificacoes'));
            bottomModal(context, widget.lancamento);
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).primaryColor.withAlpha(30),
            ),
            child: ListTile(
              leading: statusColor(this.widget.status, context),
              title: Builder(builder: (context) {
                if (this.widget.procedimento?.isNotEmpty ?? false) {
                  return Text(
                    '${this.widget.status} :: ${this.widget.procedimento}',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: Responsive.width(4.5),
                      fontWeight: FontWeight.w300,
                    ),
                  );
                } else {
                  return Text(
                    '${this.widget.status} :: ${this.widget.tipo}',
                    style: TextStyle(
                      fontSize: Responsive.width(4.5),
                      fontWeight: FontWeight.w300,
                    ),
                  );
                }
              }),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(
                  this.widget.data,
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
