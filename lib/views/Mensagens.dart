import 'package:flutter/material.dart';
import 'package:martinsegagliotti/services/get_in_app_data.dart';
import 'package:martinsegagliotti/services/responsive.dart';
import 'package:martinsegagliotti/services/theme.dart';
import 'package:martinsegagliotti/widgets/item_mensagem.dart';

class Mensagens extends StatefulWidget {
  const Mensagens({Key key}) : super(key: key);

  @override
  _MensagensState createState() => _MensagensState();
}

class _MensagensState extends State<Mensagens> {
  List<Map<String, dynamic>> conversas;
  bool isloading = false;

  Future<void> fetchMensagens([bool indicator]) async {
    if (indicator != null) {
      setState(() {
        isloading = true;
      });
    }
    var fetched = await GetInAppData.conversas();
    setState(() {
      isloading = false;
      conversas = fetched;
    });
    return;
  }

  @override
  void initState() {
    fetchMensagens(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.getbar(context),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Builder(builder: (_) {
            if (this.conversas != null && (conversas?.length != 0 ?? false)) {
              return Padding(
                padding: EdgeInsets.only(
                    top: Responsive.width(8), bottom: Responsive.width(7)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'SUAS MENSAGENS',
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
            if (conversas == null && !isloading) {
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
            } else if (conversas?.length == 0 ?? false) {
              return Flexible(
                child: Center(
                    child: Text(
                  'NENHUMA MENSAGEM',
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
                  child: ListView.builder(
                    physics: PageScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: conversas.length,
                    itemBuilder: (_, index) {
                      return ItemMensagem.from(conversas[index], () {
                        fetchMensagens();
                      });
                    },
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
