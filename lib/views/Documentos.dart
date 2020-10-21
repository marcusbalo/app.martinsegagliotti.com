import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:martinsegagliotti/services/get_in_app_data.dart';
import 'package:martinsegagliotti/services/login_service.dart';
import 'package:martinsegagliotti/services/responsive.dart';
import 'package:martinsegagliotti/services/theme.dart';
import 'package:martinsegagliotti/widgets/default_bottom_sheet.dart';
import 'package:martinsegagliotti/widgets/item_documento.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

Dio dio = Dio(BaseOptions(connectTimeout: 5 * 1000));

class Documentos extends StatefulWidget {
  const Documentos({Key key}) : super(key: key);

  @override
  _DocumentosState createState() => _DocumentosState();
}

class _DocumentosState extends State<Documentos> {
  List<Map<String, dynamic>> mensagens;
  bool isloading = false;
  bool isdownloading = false;

  Future<void> downloadFile(id, path) async {
    try {
      setState(() {
        isdownloading = true;
      });

      String savepath = "";

      if (Platform.isAndroid) {
        savepath =
            (await getExternalStorageDirectory()).path + '/MGAPP/' + path;
      } else {
        savepath =
            (await getApplicationDocumentsDirectory()).path + '/MGAPP/' + path;
      }

      String token = await LoginService.token;

      await dio.download(
        'http://hostmgm:8888/api/files/download/$id',
        savepath,
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: true,
            headers: {'Authorization': 'Bearer $token'}),
      );
      setState(() {
        isdownloading = false;
      });
      successDialog(context, customText: 'Download Concluído!');
      OpenFile.open(savepath);
    } catch (e) {
      setState(() {
        isdownloading = false;
      });
      errorDialog(context, customText: 'Erro no download!');
    }
  }

  Future<void> fetchDocumentos([bool indicator]) async {
    if (indicator != null) {
      setState(() {
        isloading = true;
      });
    }
    var fetched = await GetInAppData.documentos();
    setState(() {
      isloading = false;
      mensagens = fetched;
    });
    return;
  }

  @override
  void initState() {
    fetchDocumentos(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/uploadfile');
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: CustomAppBar.paraDocumentos(context, () {
        Navigator.of(context).pushNamed('/uploadfile');
      }),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Builder(builder: (_) {
            if (this.mensagens != null && (mensagens?.length != 0 ?? false)) {
              return Padding(
                padding: EdgeInsets.only(
                    top: Responsive.width(8), bottom: Responsive.width(7)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'DOCUMENTOS',
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
          Builder(
            builder: (context) {
              if (isdownloading) {
                return Column(
                  children: [
                    Text('Baixando arquivo...'),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10),
                      child: LinearProgressIndicator(
                        minHeight: 10,
                      ),
                    ),
                  ],
                );
              } else {
                return SizedBox();
              }
            },
          ),
          Builder(builder: (_) {
            if (mensagens == null && !isloading) {
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
            } else if (mensagens?.length == 0 ?? false) {
              return Flexible(
                child: Center(
                    child: Text(
                  'NENHUM DOCUMENTO',
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
                    shrinkWrap: true,
                    itemCount: mensagens.length,
                    itemBuilder: (_, index) {
                      return ItemDocumento.from(mensagens[index],
                          downloadcallback: downloadFile);
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
