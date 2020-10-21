import 'package:flutter/material.dart';
import 'package:martinsegagliotti/services/get_in_app_data.dart';
import 'package:martinsegagliotti/services/offline_service.dart';
import 'package:martinsegagliotti/services/responsive.dart';
import 'package:martinsegagliotti/views/gallery_view.dart';
import 'package:martinsegagliotti/views/novo_lancamento.dart';
import 'package:martinsegagliotti/widgets/DismissBackground.dart';
import 'package:martinsegagliotti/widgets/default_bottom_sheet.dart';

class ItemLancamento extends StatefulWidget {
  final String status;
  final int id;
  final String procedimento;
  final String data;
  final String tipo;
  final List<dynamic> files;
  final Map<String, dynamic> lancamento;
  final Function fn;
  final bool isRascunho;
  const ItemLancamento({
    Key key,
    this.isRascunho = false,
    this.status = '',
    this.id = 0,
    this.procedimento = '',
    this.data = '',
    this.tipo = '',
    this.files = const [],
    this.lancamento,
    this.fn,
  }) : super(key: key);

  static ItemLancamento from(Map<String, dynamic> d, Function fn) {
    return ItemLancamento(
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

  static ItemLancamento forRascunho(Map<String, dynamic> d, {Function fn}) {
    String tipo = d['tipo'];

    switch (tipo) {
      case 'PLT':
        tipo = 'Plantão';
        break;
      case 'AMB':
        tipo = 'Ambulatório';
        break;
      case 'CIRELT':
      case 'CIRPS':
        tipo = d['procedimento'];
        break;
      default:
        tipo = 'Lançamento com erros';
    }
    return ItemLancamento(
      data: d['date'],
      procedimento: d['procedure'] ?? '',
      tipo: tipo,
      files: d['files'],
      lancamento: d,
      isRascunho: true,
      fn: fn,
    );
  }

  @override
  _ItemLancamentoState createState() => _ItemLancamentoState();
}

class _ItemLancamentoState extends State<ItemLancamento> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(this.widget.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (_) async {
        if (!widget.isRascunho) {
          showDialog(
            barrierDismissible: false,
            context: context,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
          Map<String, dynamic> response =
              await GetInAppData.apagarLancamento(this.widget.id)
                  .catchError((_) {
            print(_);
            Navigator.of(context).pop();
            errorDialog(context);
          });

          if (response != null && response['status'] == 'sucesso') {
            widget.fn();
            Navigator.of(context).pop();
            successDialog(context);
          } else {
            Navigator.of(context).pop();
            errorDialog(context);
          }
        } else {
          var off = await OfflineService.instance();
          var result = await off.removerRascunhoPeloId(widget.lancamento['id']);
          if (result) {
            widget.fn();
            successDialog(context);
          } else {
            widget.fn();
            errorDialog(context);
          }
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
            if (widget.isRascunho) {
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                return NovoLancamento(
                  //VERIFICAR POSSÍVEL ERRO
                  rascunho: widget.lancamento,
                );
              }));
            } else {
              Navigator.of(context).popUntil(ModalRoute.withName('/emcurso'));
              bottomModal(context, widget.lancamento);
            }
          },
          onLongPress: () {
            if (widget.isRascunho) {
              if (widget.lancamento['files'] != null) {
                Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                  return GalleryPage(
                    fn: () {
                      //callback function from rascunhos.dart
                    },
                    imageList: widget.lancamento['files'],
                    isRascunho: widget.isRascunho,
                  );
                }));
              }
            } else {
              bottomModal(context, widget.lancamento);
              Navigator.of(context).popUntil(ModalRoute.withName('/emcurso'));
            }
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).primaryColor.withAlpha(30),
            ),
            child: ListTile(
              leading: (widget.isRascunho)
                  ? null
                  : statusColor(this.widget.status, context),
              title: Builder(builder: (context) {
                if (this.widget.procedimento?.isNotEmpty ?? false) {
                  return Text(
                    this.widget.procedimento,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: Responsive.width(4.5),
                      fontWeight: FontWeight.w300,
                    ),
                  );
                } else {
                  return Text(
                    this.widget.tipo,
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

Widget statusColor(String status, BuildContext context) {
  Widget avatar(color, text) {
    return Container(
      width: Responsive.width(10),
      height: Responsive.width(10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white.withAlpha(200),
      ),
      child: Text(text,
          style: TextStyle(color: color, fontSize: Responsive.width(6))),
    );
  }

  switch (status) {
    case 'Aprovado':
      return avatar(Colors.green[400], 'A');
      break;
    case 'Negado':
      return avatar(Colors.red[400], 'N');
      break;
    case 'Pendente':
      return avatar(Colors.blue[400], 'P');
      break;
    default:
      return avatar(Colors.white, '');
  }
}
