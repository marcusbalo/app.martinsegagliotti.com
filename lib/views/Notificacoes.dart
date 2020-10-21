import 'package:flutter/material.dart';
import 'package:martinsegagliotti/services/get_in_app_data.dart';
import 'package:martinsegagliotti/services/responsive.dart';
import 'package:martinsegagliotti/services/theme.dart';
import 'package:martinsegagliotti/widgets/ItemNotificacao.dart';

class Notificacoes extends StatefulWidget {
  const Notificacoes({Key key}) : super(key: key);

  @override
  _NotificacoesState createState() => _NotificacoesState();
}

class _NotificacoesState extends State<Notificacoes> {
  List<Map<String, dynamic>> notificacoes;
  bool isloading = false;

  Future<void> fetchNotificacoes([bool indicator]) async {
    if (indicator != null) {
      setState(() {
        isloading = true;
      });
    }
    var fetched = await GetInAppData.listaDeNotificacoes;
    setState(() {
      isloading = false;
      notificacoes = fetched;
    });
    return;
  }

  @override
  void initState() {
    fetchNotificacoes(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.semNotificacao(context),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Builder(builder: (_) {
            if (this.notificacoes != null &&
                (notificacoes?.length != 0 ?? false)) {
              return Padding(
                padding: EdgeInsets.only(
                    top: Responsive.width(8), bottom: Responsive.width(7)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'ÚLTIMAS NOTIFICAÇÕES',
                      style: TextStyle(
                          fontSize: Responsive.width(4),
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              );
            } else {
              return SizedBox();
            }
          }),
          Builder(builder: (_) {
            if (notificacoes == null && !isloading) {
              return Flexible(
                child: Center(
                    child: Text(
                  'VOCÊ ESTÁ OFFLINE',
                  style: TextStyle(
                      fontSize: Responsive.width(4),
                      color: Colors.red[300],
                      fontWeight: FontWeight.bold),
                )),
              );
            } else if (isloading) {
              return Flexible(
                  child: Center(
                child: CircularProgressIndicator(),
              ));
            } else if (notificacoes?.length == 0 ?? false) {
              return Flexible(
                child: Center(
                    child: Text(
                  'NENHUMA NOTIFICAÇÃO',
                  style: TextStyle(
                      fontSize: Responsive.width(4),
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                )),
              );
            } else {
              return Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: RefreshIndicator(
                    onRefresh: fetchNotificacoes,
                    child: ListView.builder(
                      itemCount: notificacoes.length,
                      itemBuilder: (_, index) {
                        return ItemNotificacao.from(
                            notificacoes[index], fetchNotificacoes);
                      },
                    ),
                  ),
                ),
              );
            }
          }),
        ],
      ),
    );
  }
}
