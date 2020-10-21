import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:martinsegagliotti/services/login_service.dart';
import 'package:martinsegagliotti/services/responsive.dart';
import 'package:martinsegagliotti/services/theme.dart';
import 'package:martinsegagliotti/widgets/default_bottom_sheet.dart';

class FileUpload extends StatefulWidget {
  const FileUpload({Key key}) : super(key: key);

  @override
  _FileUploadState createState() => _FileUploadState();
}

class _FileUploadState extends State<FileUpload> {
  final GlobalKey<FormBuilderState> _fbKey2 = GlobalKey<FormBuilderState>();
  String filepath;
  String localFileName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.semNotificacao(context),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                top: Responsive.width(8), bottom: Responsive.width(7)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'ENVIAR DOCUMENTO',
                  style: TextStyle(
                    fontSize: Responsive.width(4),
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.width(5),
              vertical: Responsive.width(0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FormBuilder(
                    key: _fbKey2,
                    child: Column(
                      children: [
                        FormBuilderTextField(
                          validators: [
                            FormBuilderValidators.required(
                                errorText: 'Preencha este campo'),
                          ],
                          attribute: 'name',
                          decoration: InputDecoration(
                            labelText: 'Nome para o arquivo',
                          ),
                        ),
                      ],
                    )),
                SizedBox(height: Responsive.width(3)),
                Builder(
                  builder: (_) {
                    if (filepath != null) {
                      return Row(
                        children: [
                          Icon(
                            Icons.insert_drive_file,
                            color: Theme.of(context).accentColor,
                          ),
                          SizedBox(width: 10),
                          Flexible(
                            child: Text(
                              localFileName,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  },
                ),
                SizedBox(height: Responsive.width(3)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BotaoDocumentos(
                        texto: 'Selecionar',
                        callback: () async {
                          FilePickerResult result =
                              await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: [
                              "pdf",
                              "doc",
                              "docx",
                              "xls",
                              "xlsx",
                              "rtf",
                              "jpeg",
                              "png",
                              "jpg"
                            ],
                          );
                          if (result != null) {
                            setState(() {
                              filepath = result.files.single.path;
                              localFileName = result.files.single.name;
                            });
                          }
                        }),
                    SizedBox(width: Responsive.width(3)),
                    Builder(
                      builder: (context) {
                        if (filepath != null) {
                          return BotaoDocumentos(
                              texto: 'Enviar',
                              callback: () async {
                                if (_fbKey2.currentState.saveAndValidate()) {
                                  showDialog(
                                    context: context,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                  bool result = await sendFormData(
                                    name: _fbKey2.currentState.fields['name']
                                        .currentState.value,
                                    path: filepath,
                                  );
                                  if (result) {
                                    Navigator.of(context).pop();
                                    successDialog(
                                      context,
                                      customText:
                                          'Arquivo enviado com sucesso!',
                                    );
                                  } else {
                                    Navigator.of(context).pop();
                                    errorDialog(context,
                                        customText: 'Erro ao enviar arquivo!');
                                  }
                                }
                              });
                        } else {
                          return SizedBox.shrink();
                        }
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BotaoDocumentos extends StatelessWidget {
  final String texto;
  final Function callback;

  const BotaoDocumentos({Key key, this.texto, this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(top: Responsive.width(2)),
        child: Container(
          height: Responsive.height(10),
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(5)),
          child: FlatButton(
            onPressed: callback,
            child: Text(
              texto,
              style: TextStyle(
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                  fontSize: Responsive.width(5)),
            ),
          ),
        ),
      ),
    );
  }
}

Future<MultipartFile> getFile(String path) async {
  MultipartFile file = MultipartFile.fromFileSync(path);
  return file;
}

Future<bool> sendFormData({String name, String path}) async {
  try {
    String token = await LoginService.token;
    MultipartFile file = await getFile(path);
    FormData body = FormData.fromMap({
      'name': name,
      "file": file,
    });
    Dio uploader = Dio();
    var response = await uploader
        .post(
      '$url/api/files/uploadnew',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
      data: body,
    )
        .catchError((_) {
      print(_);
    });

    return (response?.statusCode == 200 ?? false) ? true : false;
  } catch (e) {
    return false;
  }
}
