import 'package:flutter/material.dart';
import 'package:martinsegagliotti/services/responsive.dart';
import 'package:martinsegagliotti/views/gallery_view.dart';

bottomModal(BuildContext context, Map<String, dynamic> lancamento) {
  showBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (ctx) => CustomBottomSheet(lancamento: lancamento),
  );
}

Future<bool> confirmar(BuildContext context,
    {String customText, IconData customIcon, Color customColor}) async {
  return await showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              customIcon ?? Icons.error_outline,
              color: customColor ?? Colors.red[300],
              size: Responsive.width(25),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  customText ?? 'TEM CERTEZA ?',
                  style: TextStyle(fontSize: Responsive.width(4)),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlatButton(
                  onPressed: () async {
                    Navigator.of(context).pop(true);
                  },
                  child: Text(
                    'SIM',
                    style: TextStyle(
                        fontSize: Responsive.width(4),
                        color: customColor ?? Colors.red[300]),
                  ),
                ),
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    'NÃO',
                    style: TextStyle(
                        fontSize: Responsive.width(4), color: Colors.blue[300]),
                  ),
                ),
              ],
            )
          ],
        ),
      );
    },
  );
}

successDialog(BuildContext context, {String customText}) {
  showDialog(
    context: context,
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.green[300],
            size: Responsive.width(20),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Material(
              color: Colors.transparent,
              child: Text(
                customText ?? 'Apagado com sucesso!',
                style: TextStyle(
                    color: Colors.white, fontSize: Responsive.width(6)),
              ),
            ),
          ),
        ],
      ),
    ),
  ).then((_) {
    if (customText != null) {
      Navigator.of(context).pop();
    }
  });
}

errorDialog(BuildContext context, {String customText}) {
  showDialog(
    context: context,
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red[300],
            size: Responsive.width(20),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Material(
              color: Colors.transparent,
              child: Text(
                customText ?? 'Erro ao apagar lançamento!',
                style: TextStyle(
                    color: Colors.white, fontSize: Responsive.width(6)),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class CustomBottomSheet extends StatelessWidget {
  final Map<String, dynamic> lancamento;

  const CustomBottomSheet({Key key, this.lancamento}) : super(key: key);

  celula(titulo, valor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
            fontSize: Responsive.width(5),
          ),
        ),
        SizedBox(
          height: Responsive.width(1),
        ),
        Text(
          valor,
          overflow: TextOverflow.fade,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w300,
            fontSize: Responsive.width(5),
          ),
        ),
        SizedBox(
          height: Responsive.width(5),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withAlpha(220),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      height: MediaQuery.of(context).size.height * 0.65,
      child: ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'DETALHES',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Responsive.width(5),
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
                SizedBox(
                  height: Responsive.width(5),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    celula('Data', lancamento['date']),
                    Spacer(),
                    celula('Tipo', lancamento['type']),
                  ],
                ),
                celula('Hospital', lancamento['hospital']),
                Builder(
                  builder: (_) {
                    if (lancamento.containsKey('paciente') &&
                        lancamento['paciente'] != null &&
                        lancamento['paciente'].isNotEmpty) {
                      return celula('Paciente', lancamento['paciente']);
                    } else {
                      return SizedBox();
                    }
                  },
                ),
                Builder(
                  builder: (_) {
                    if (lancamento.containsKey('procedure') &&
                        lancamento['procedure'] != null &&
                        lancamento['procedure'].isNotEmpty) {
                      return celula('Procedimento', lancamento['procedure']);
                    } else {
                      return SizedBox();
                    }
                  },
                ),
                Center(
                  child: Builder(
                    builder: (_) {
                      if (lancamento.containsKey('files') &&
                          lancamento['files'] != null) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: Responsive.width(4),
                            ),
                            RaisedButton(
                              elevation: 0,
                              color:
                                  Theme.of(context).primaryColor.withAlpha(240),
                              onPressed: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (ctx) {
                                  return GalleryPage(
                                    imageList: lancamento['files'],
                                  );
                                }));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'VER IMAGENS',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: Responsive.width(4),
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: Responsive.width(4),
                            ),
                          ],
                        );
                      } else {
                        return SizedBox();
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ],
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
    default:
      return avatar(Colors.red, 'Erro');
  }
}
