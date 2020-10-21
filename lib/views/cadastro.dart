import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:martinsegagliotti/model/user.dart';
import 'package:martinsegagliotti/services/get_in_app_data.dart' as inapp;
import 'package:martinsegagliotti/services/login_service.dart';
import 'package:martinsegagliotti/services/responsive.dart';
import 'package:martinsegagliotti/services/theme.dart';
import 'novo_lancamento.dart';

Dio dio = new Dio();

Future<Response> cadastrar(Map<String, dynamic> body) async {
  return dio.post('$url/api/cadastro', data: FormData.fromMap(body));
}

Future<Response> editar(Map<String, dynamic> body) async {
  String token = await LoginService.token;
  return dio.post('$url/api/atualizar',
      data: FormData.fromMap(body),
      options: Options(headers: {'Authorization': 'Bearer $token'}));
}

class Cadastro extends StatefulWidget {
  final bool isEditing;
  Cadastro({Key key, this.isEditing = false}) : super(key: key);

  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  List<Map<String, dynamic>> hospitais;
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  User user;
  Map<String, dynamic> perfil;
  List<int> hospitaisSelecionados = [];
  @override
  void initState() {
    fetchHospitais() async {
      var h = await inapp.GetInAppData.hospitais;

      if (widget.isEditing) {
        User u = await LoginService.user;
        dynamic p = await inapp.GetInAppData.perfil(widget.isEditing);
        setState(() {
          perfil = p;
          user = u;
          if (p['hospitais'] != null) {
            for (var i in p['hospitais']) {
              hospitaisSelecionados.add(int.tryParse(i));
            }
          }
        });
      } else {
        setState(() {
          perfil = {};
        });
      }
      setState(() {
        hospitais = h;
      });
    }

    fetchHospitais();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Responsive(context);
    return Scaffold(
      appBar: CustomAppBar.semNotificacao(context),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: Responsive.width(8), bottom: Responsive.width(7)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'PREENCHA SUAS INFORMAÇÕES',
                    style: TextStyle(
                        fontSize: Responsive.width(4),
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(Responsive.width(5)),
              child: Builder(builder: (context) {
                if (perfil != null) {
                  return FormBuilder(
                    initialValue: {...perfil},
                    key: _fbKey,
                    child: Column(children: [
                      Builder(
                        builder: (_) {
                          if (user != null) {
                            return Container(
                              width: Responsive.width(40),
                              child: FormBuilderImagePicker(
                                maxWidth: 720,
                                imageHeight: Responsive.width(30),
                                imageWidth: Responsive.width(40),
                                maxImages: 1,
                                cameraLabel: Text('Câmera'),
                                galleryLabel: Text('Galeria'),
                                defaultImage: user.image,
                                attribute: 'photo',
                                valueTransformer: (value) {
                                  if (value.length > 0) {
                                    return MultipartFile.fromFileSync(
                                        value[0].path);
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            );
                          } else {
                            return SizedBox.shrink();
                          }
                        },
                      ),
                      SizedBox(height: 10),
                      FormBuilderTextField(
                        attribute: 'name',
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(labelText: 'Nome Completo'),
                        validators: [
                          FormBuilderValidators.required(
                              errorText: 'Campo obrigatório')
                        ],
                      ),
                      FormBuilderTextField(
                        attribute: 'speciality',
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(labelText: 'Especialidade'),
                        validators: [
                          FormBuilderValidators.required(
                              errorText: 'Campo obrigatório')
                        ],
                      ),
                      FormBuilderTextField(
                        attribute: 'cpf',
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(labelText: 'CPF'),
                        validators: [
                          FormBuilderValidators.required(
                              errorText: 'Campo obrigatório')
                        ],
                      ),
                      FormBuilderTextField(
                        attribute: 'crm',
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(labelText: 'CRM'),
                        validators: [
                          FormBuilderValidators.required(
                              errorText: 'Campo obrigatório')
                        ],
                      ),
                      hospitalsSelector(hospitais, (_) {}, true),
                      FormBuilderTextField(
                        attribute: 'mother',
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(labelText: 'Nome da Mãe'),
                        validators: [
                          FormBuilderValidators.required(
                              errorText: 'Campo obrigatório')
                        ],
                      ),
                      FormBuilderTextField(
                        attribute: 'pis_nit',
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(labelText: 'PIS/NIT'),
                        validators: [
                          FormBuilderValidators.required(
                              errorText: 'Campo obrigatório')
                        ],
                      ),
                      FormBuilderTextField(
                        attribute: 'rg',
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(labelText: 'RG'),
                        validators: [
                          FormBuilderValidators.required(
                              errorText: 'Campo obrigatório')
                        ],
                      ),
                      Builder(
                        builder: (_) {
                          if (widget.isEditing) {
                            return Column(
                              children: [
                                FormBuilderTextField(
                                  attribute: 'bank',
                                  keyboardType: TextInputType.text,
                                  decoration:
                                      InputDecoration(labelText: 'Banco'),
                                  validators: [
                                    FormBuilderValidators.required(
                                        errorText: 'Campo obrigatório')
                                  ],
                                ),
                                FormBuilderTextField(
                                  attribute: 'bank_branch',
                                  keyboardType: TextInputType.text,
                                  decoration:
                                      InputDecoration(labelText: 'Agência'),
                                  validators: [
                                    FormBuilderValidators.required(
                                        errorText: 'Campo obrigatório')
                                  ],
                                ),
                                FormBuilderTextField(
                                  attribute: 'checking_account',
                                  keyboardType: TextInputType.text,
                                  decoration:
                                      InputDecoration(labelText: 'Conta'),
                                  validators: [
                                    FormBuilderValidators.required(
                                        errorText: 'Campo obrigatório')
                                  ],
                                ),
                              ],
                            );
                          } else {
                            return SizedBox.shrink();
                          }
                        },
                      ),
                      FormBuilderTextField(
                        attribute: 'marital_status',
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(labelText: 'Estado Civil'),
                        validators: [
                          FormBuilderValidators.required(
                              errorText: 'Campo obrigatório')
                        ],
                      ),
                      FormBuilderTextField(
                        attribute: 'nationality',
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(labelText: 'Nacionalidade'),
                        validators: [
                          FormBuilderValidators.required(
                              errorText: 'Campo obrigatório')
                        ],
                      ),
                      Builder(
                        builder: (_) {
                          if (!widget.isEditing) {
                            return dateSelector(
                              atrribute: 'started_in',
                              labelText: 'Começou em',
                            );
                          } else {
                            return SizedBox.shrink();
                          }
                        },
                      ),
                      FormBuilderTextField(
                        keyboardType: TextInputType.phone,
                        attribute: 'cellphone_number',
                        decoration: InputDecoration(labelText: 'Celular'),
                        validators: [
                          FormBuilderValidators.required(
                              errorText: 'Campo obrigatório')
                        ],
                      ),
                      FormBuilderTextField(
                        attribute: 'address',
                        decoration: InputDecoration(labelText: 'Endereço'),
                        validators: [
                          FormBuilderValidators.required(
                              errorText: 'Campo obrigatório')
                        ],
                      ),
                      FormBuilderTextField(
                        attribute: 'rqe',
                        decoration: InputDecoration(labelText: 'RQE'),
                      ),
                      FormBuilderTextField(
                        attribute: 'email',
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(labelText: 'Email'),
                        validators: [
                          FormBuilderValidators.required(
                              errorText: 'Campo obrigatório'),
                          (value) {
                            bool emailValid = RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value);
                            if (!emailValid) {
                              return 'email inválido';
                            }
                            return null;
                          }
                        ],
                      ),
                      FormBuilderTextField(
                        attribute: 'password',
                        obscureText: true,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(labelText: 'Senha'),
                        validators: (widget.isEditing)
                            ? []
                            : [
                                FormBuilderValidators.required(
                                    errorText: 'Campo obrigatório')
                              ],
                      ),
                      FormBuilderTextField(
                        attribute: 'password_confirmation',
                        obscureText: true,
                        keyboardType: TextInputType.emailAddress,
                        decoration:
                            InputDecoration(labelText: 'Confirme a senha'),
                        validators: [
                          (value) {
                            if (value !=
                                _fbKey.currentState.fields['password']
                                    .currentState.value) {
                              return 'Senhas não coincidem';
                            }
                            return null;
                          }
                        ],
                      ),
                      Builder(
                        builder: (BuildContext _context) {
                          if (widget.isEditing) {
                            return SubmitButtom(
                              text: 'Salvar',
                              callback:
                                  callbackcadastrar(context, _fbKey, true),
                            );
                          } else {
                            return SubmitButtom(
                              text: 'Cadastrar',
                              callback: callbackcadastrar(context, _fbKey),
                            );
                          }
                        },
                      )
                    ]),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  callbackcadastrar(BuildContext context, _fbKey, [bool isediting = false]) {
    return () async {
      FocusScope.of(context).unfocus();
      if (_fbKey.currentState.saveAndValidate()) {
        Map<String, dynamic> body = _fbKey.currentState.value;

        _toDateString(DateTime date) {
          return '${date.day}/${date.month}/${date.year}';
        }

        if (!isediting) {
          body['started_in'] = _toDateString(body['started_in']);
        }

        showDialog(
          barrierDismissible: false,
          context: context,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );

        Response resposta;
        if (isediting) {
          body.addAll({'hospitais': hospitaisSelecionados});

          resposta = await editar(body).catchError((_) {
            print(_);
          });
        } else {
          resposta = await cadastrar(body).catchError((_) {
            print(_);
          });
        }

        if ((resposta?.statusCode == 200 ?? false) &&
            (resposta?.data['status'] == 'success' ?? false)) {
          Navigator.of(context).pop();
          statusmessage(
            context,
            Icon(Icons.warning),
            (isediting) ? 'Atualizado!' : 'Cadastro efetuado!',
          ).then((value) => Navigator.of(context).pop());
        } else {
          Navigator.of(context).pop();
          statusmessage(
            context,
            Icon(Icons.warning),
            (isediting) ? 'Erro ao atualizar!' : 'Erro ao efeturar cadastro!',
          );
        }
      }
    };
  }
}

class SubmitButtom extends StatelessWidget {
  final String text;
  final Function callback;
  const SubmitButtom({Key key, @required this.text, @required this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Responsive.width(5)),
      child: Container(
        height: Responsive.height(10),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(5)),
        child: FlatButton(
          onPressed: callback,
          child: Text(
            text,
            style: TextStyle(
                fontWeight: FontWeight.w300,
                color: Colors.white,
                fontSize: Responsive.width(5)),
          ),
        ),
      ),
    );
  }
}

idtoIndex({List<Map<String, dynamic>> hospitais, List<int> ids}) {
  List<int> index = [];
  List<dynamic> hospitalIds = hospitais.map((e) => e['id']).toList();
  ids.forEach((id) {
    int at = hospitalIds.indexOf(id);
    if (at != -1) {
      index.add(at);
    }
  });
  return index;
}

indexToId({List<Map<String, dynamic>> hospitais, List<int> index}) {
  List<int> ids = [];
  index.forEach((i) {
    ids.add(hospitais[i]['id']);
  });
  return ids;
}
