import 'package:flutter/material.dart';
import 'package:martinsegagliotti/services/get_in_app_data.dart';
import 'package:martinsegagliotti/services/responsive.dart';
import 'package:martinsegagliotti/services/theme.dart';
import 'package:martinsegagliotti/widgets/ItemLancamento.dart';

class EmCurso extends StatefulWidget {
  const EmCurso({Key key}) : super(key: key);

  @override
  _EmCursoState createState() => _EmCursoState();
}

class _EmCursoState extends State<EmCurso> {
  List<Map<String, dynamic>> baseLancamentos;
  bool isloading = false;

  Future<void> fetchLancamentos([bool indicator]) async {
    if (indicator != null) {
      setState(() {
        isloading = true;
      });
    }
    var fetched = await GetInAppData.lancamentos();
    setState(() {
      isloading = false;
      baseLancamentos = fetched;
    });
    return;
  }

  @override
  void initState() {
    fetchLancamentos(true);
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
            if (this.baseLancamentos != null &&
                (baseLancamentos?.length != 0 ?? false)) {
              return Padding(
                padding: EdgeInsets.only(
                    top: Responsive.width(8), bottom: Responsive.width(7)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'LANÇAMENTOS EM CURSO',
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
            if (baseLancamentos == null && !isloading) {
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
            } else if (baseLancamentos?.length == 0 ?? false) {
              return Flexible(
                child: Center(
                    child: Text(
                  'NADA PARA EXIBIR',
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
                    onRefresh: fetchLancamentos,
                    child: ListView.builder(
                      itemCount: baseLancamentos.length,
                      itemBuilder: (_, index) {
                        return ItemLancamento.from(
                            baseLancamentos[index], fetchLancamentos);
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
