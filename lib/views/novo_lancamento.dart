import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get_it/get_it.dart';
import 'dart:io' show Platform;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:martinsegagliotti/services/get_in_app_data.dart';
import 'package:martinsegagliotti/services/offline_service.dart';
import 'package:martinsegagliotti/services/responsive.dart';
import 'package:martinsegagliotti/services/theme.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:martinsegagliotti/services/upload_helper.dart';
import 'package:martinsegagliotti/views/gallery_view.dart';
import 'package:martinsegagliotti/widgets/forms/FormAmbulatorio.dart';
import 'package:martinsegagliotti/widgets/forms/FormCirurgias.dart';
import 'package:martinsegagliotti/widgets/forms/FormPlantao.dart';
import 'dart:math' as math;
import 'package:searchable_dropdown/searchable_dropdown.dart';

class NovoLancamento extends StatefulWidget {
  final Map<String, dynamic> rascunho;
  const NovoLancamento({Key key, this.rascunho}) : super(key: key);

  @override
  _NovoLancamentoState createState() => _NovoLancamentoState();
}

class _NovoLancamentoState extends State<NovoLancamento>
    with TickerProviderStateMixin {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  List<Map<String, dynamic>> hospitais;
  List<Map<String, dynamic>> medicos;
  TextEditingController hourController = TextEditingController();
  String tipoDoLancamento = '';
  List<String> actualTypeKeys = [];
  AnimationController _controller;
  int imagecounter = 0;
  bool isediting = false;

  final picker = ImagePicker();

  static const List<IconData> icons = const [
    Icons.camera_alt,
    Icons.image,
    Icons.remove_red_eye
  ];

  Function getImage(int buttonIndex) {
    if (buttonIndex == 2) {
      return () {
        Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
          return GalleryPage(
              imageList: GetIt.I<UploadHelperService>().arquivos,
              fn: () {
                setState(() {
                  imagecounter = GetIt.I<UploadHelperService>().arquivos.length;
                });
              });
        }));
      };
    }
    return () async {
      PickedFile pickedFile;
      switch (buttonIndex) {
        case 0:
          pickedFile = await picker.getImage(
              source: ImageSource.camera, imageQuality: 40, maxWidth: 1920);
          break;
        case 1:
          if (Platform.isAndroid) {
            pickedFile = await picker.getImage(
                source: ImageSource.gallery, imageQuality: 40, maxWidth: 1920);
          } else if (Platform.isIOS) {
            try {
              List<Asset> images = await MultiImagePicker.pickImages(
                maxImages: 15,
                enableCamera: false,
              );
              for (var image in images) {
                String path =
                    await FlutterAbsolutePath.getAbsolutePath(image.identifier);
                GetIt.I<UploadHelperService>().addImagePath(path);
              }
            } catch (e) {
              print(e);
            }
          }
          break;
      }
      if (pickedFile != null) {
        GetIt.I<UploadHelperService>().addImagePath(pickedFile.path);
      }
      setState(() {
        imagecounter = GetIt.I<UploadHelperService>().arquivos.length;
      });
    };
  }

  @override
  void dispose() {
    GetIt.I<UploadHelperService>().arquivos = [];
    super.dispose();
  }

  @override
  void initState() {
    fetchHospitais() async {
      var h = await GetInAppData.userHospitais;
      setState(() {
        hospitais = h;
      });
    }

    fetchTeam() async {
      var m = await GetInAppData.medicos;
      setState(() {
        medicos = m;
      });
    }

    fetchHospitais();

    fetchTeam();

    isediting = (widget.rascunho != null) ? true : false;

    if (isediting) {
      if (widget.rascunho.containsKey('files')) {
        imagecounter = widget.rascunho['files'].length;
        GetIt.I<UploadHelperService>().arquivos =
            List<String>.from(widget.rascunho['files']);
      }
      if (widget.rascunho.containsKey('hora')) {
        hourController.text = widget.rascunho['hora'];
      }
    }
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Theme.of(context).cardColor;
    Color foregroundColor = Theme.of(context).accentColor;
    return Scaffold(
      floatingActionButton: new Column(
        mainAxisSize: MainAxisSize.min,
        children: new List.generate(icons.length, (int index) {
          Widget child = new Container(
            height: 70.0,
            width: 56.0,
            alignment: FractionalOffset.topCenter,
            child: new ScaleTransition(
              scale: new CurvedAnimation(
                parent: _controller,
                curve: new Interval(0.0, 1.0 - index / icons.length / 2.0,
                    curve: Curves.easeOut),
              ),
              child: new FloatingActionButton(
                heroTag: null,
                backgroundColor: backgroundColor,
                mini: true,
                child: new Icon(icons[index], color: foregroundColor),
                onPressed: getImage(index),
              ),
            ),
          );
          return child;
        }).toList()
          ..add(
            new FloatingActionButton(
              heroTag: null,
              child: new AnimatedBuilder(
                animation: _controller,
                builder: (BuildContext context, Widget child) {
                  return new Transform(
                    transform: new Matrix4.rotationZ(
                        _controller.value * 0.5 * math.pi),
                    alignment: FractionalOffset.center,
                    child: new Icon(
                      _controller.isDismissed ? Icons.camera_alt : Icons.close,
                      color: Colors.white,
                    ),
                  );
                },
              ),
              onPressed: () {
                if (_controller.isDismissed) {
                  _controller.forward();
                } else {
                  _controller.reverse();
                }
              },
            ),
          ),
      ),
      appBar: CustomAppBar.getbar(context),
      body: Column(
        children: [
          header(context, isediting),
          Flexible(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(Responsive.width(7)),
                child: Column(
                  children: <Widget>[
                    FormBuilder(
                      key: _fbKey,
                      initialValue: (!isediting)
                          ? {'date': DateTime.now()}
                          : {
                              ...widget.rascunho,
                              ...{
                                'date': DateTime.parse(widget.rascunho['date'])
                              }
                            },
                      child: Column(
                        children: [
                          dateSelector(),
                          typeSelector((value) {
                            setState(() {
                              tipoDoLancamento = value;
                            });
                          }),
                          hospitalsSelector(hospitais, (value) {}),
                          setformtypeinputs(
                            editable: widget.rascunho,
                            setkeystate: (List<String> keys) {
                              setState(() {
                                this.actualTypeKeys = keys;
                              });
                            },
                            formKey: _fbKey,
                            type: tipoDoLancamento,
                            team: medicos ?? [],
                            context: context,
                            timerController: hourController,
                            fnTimer: (selectedTime) {
                              setState(() {
                                hourController.text = selectedTime;
                              });
                            },
                          ),
                          submitButton(() async {
                            if (_fbKey.currentState.saveAndValidate()) {
                              var instance = GetIt.I<UploadHelperService>();
                              if (isediting) {
                                instance.updateBody(
                                    _fbKey.currentState.value, null);
                              } else {
                                instance.updateBody(
                                    _fbKey.currentState.value, actualTypeKeys);
                              }

                              var tipo = _fbKey.currentState.value['tipo'];
                              if (tipo == 'CIRPS' || tipo == 'CIRELT') {
                                if (instance.arquivos.length < 1) {
                                  statusmessage(
                                    context,
                                    Icon(Icons.warning),
                                    'Falta descrição cirúrgica!',
                                  );
                                  return;
                                }
                              }
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                              int response;
                              if (isediting) {
                                response = await instance.uploadForm(true);
                              } else {
                                response = await instance.uploadForm();
                              }
                              if (response == 3) {
                                Navigator.of(context).pop();
                                if (isediting) {
                                  statusmessage(
                                    context,
                                    Icon(Icons.warning),
                                    'Falha ao enviar lançamento!',
                                  );
                                } else {
                                  statusmessage(
                                    context,
                                    Icon(
                                      Icons.save,
                                      color: Colors.blue[300],
                                    ),
                                    'Salvo em rascunhos',
                                  );
                                }
                              } else if (response == 1) {
                                Navigator.of(context).pop();
                                statusmessage(
                                  context,
                                  Icon(
                                    Icons.check_circle,
                                    color: Colors.green[300],
                                  ),
                                  'Lançamento enviado com sucesso!',
                                );
                                ;
                                if (isediting) {
                                  (await OfflineService.instance())
                                      .removerRascunhoPeloId(
                                          widget.rascunho['id']);
                                }
                              } else {
                                Navigator.of(context).pop();
                                statusmessage(
                                  context,
                                  Icon(Icons.warning),
                                  'Falha ao enviar lançamento!',
                                );
                              }
                            }
                          }, context),
                          Builder(
                            builder: (_) {
                              if (imagecounter == 1) {
                                return Text('Uma imagem adicionada.');
                              }
                              if (imagecounter > 1) {
                                return Text(
                                    '$imagecounter imagens adicionadas.');
                              }
                              return SizedBox();
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

setformtypeinputs(
    {editable,
    String type,
    team,
    BuildContext context,
    Function fnTimer,
    TextEditingController timerController,
    GlobalKey<FormBuilderState> formKey,
    Function setkeystate}) {
  switch ((editable != null) ? editable['tipo'] : type) {
    case 'AMB':
      setkeystate(keysAmbulatorio);
      return formAmbulatorio();
      break;
    case 'PLT':
      setkeystate(keysPlantao);
      return formPlantao(context, fnTimer, timerController);
    case 'CIRELT':
    case 'CIRPS':
      setkeystate(keysCirurgias);
      return Column(
        children: [
          formCirurgias(),
          SearchableDropdown.multiple(
            selectedItems: GetIt.I<UploadHelperService>().team,
            doneButton: 'Okay',
            closeButton: 'Salvar',
            onChanged: (value) {
              print(value);
              GetIt.I<UploadHelperService>().team = value;
            },
            underline: Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.black12, width: 3.0))),
            ),
            searchFn: searchFuntion(team),
            displayClearIcon: true,
            validator: (List selected) {
              if (selected == null) {
                return null;
              }
              if (selected.length > 3) {
                return 'Selecione só 3';
              }
              return null;
            },
            hint: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Text('Selecione a equipe'),
            ),
            items: team.map<DropdownMenuItem>(
              (team) {
                return DropdownMenuItem(
                  child: Text(team['name']),
                  value: team['id'],
                );
              },
            ).toList(),
            searchHint: "Escolha só 3",
            isExpanded: true,
          )
        ],
      );
    default:
      setkeystate(<String>[]);
      return SizedBox();
  }
}

typeSelector(fn) {
  return FormBuilderDropdown(
    attribute: "tipo",
    decoration: InputDecoration(labelText: "Tipo"),
    validators: [FormBuilderValidators.required()],
    onChanged: fn,
    items: [
      {'tipo': 'Plantão', 'value': 'PLT'},
      {'tipo': 'Ambulatório', 'value': 'AMB'},
      {'tipo': 'Cirurgia Eletiva', 'value': 'CIRELT'},
      {'tipo': 'Cirurgia PS', 'value': 'CIRPS'},
    ]
        .map(
          (entries) => DropdownMenuItem(
            value: entries['value'],
            child: Text("${entries['tipo']}"),
          ),
        )
        .toList(),
  );
}

submitButton(fn, BuildContext context) {
  return Padding(
    padding: EdgeInsets.all(Responsive.width(5)),
    child: Container(
      height: Responsive.height(10),
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(5)),
      child: FlatButton(
        onPressed: fn,
        child: Text(
          'Enviar',
          style: TextStyle(
              fontWeight: FontWeight.w300,
              color: Colors.white,
              fontSize: Responsive.width(5)),
        ),
      ),
    ),
  );
}

hospitalsSelector(List<Map<String, dynamic>> hospitais, Function fn,
    [bool isCadastro = false]) {
  return Builder(builder: (_) {
    if (hospitais != null) {
      return FormBuilderDropdown(
        onChanged: fn,
        attribute: (isCadastro) ? 'hospital_id' : 'hospital',
        isExpanded: true,
        validators: [
          FormBuilderValidators.required(errorText: 'Campo obrigatório')
        ],
        decoration: InputDecoration(labelText: 'Hospital'),
        items: hospitais.map(
          (hospital) {
            return DropdownMenuItem(
              child: Text(hospital['name']),
              value: hospital['id'],
            );
          },
        ).toList(),
      );
    } else {
      return DropdownButtonFormField(
        onChanged: (_) => null,
        isExpanded: true,
        decoration: InputDecoration(labelText: 'Hospital', suffix: null),
        items: [],
      );
    }
  });
}

dateSelector({atrribute = 'date', labelText = 'Data'}) {
  return FormBuilderDateTimePicker(
    firstDate: DateTime.now().subtract(Duration(days: 5)),
    lastDate: DateTime.now(),
    resetIcon: null,
    attribute: atrribute,
    inputType: InputType.date,
    format: DateFormat("dd/MM/yyyy"),
    decoration: InputDecoration(labelText: labelText),
    validators: [
      FormBuilderValidators.required(errorText: 'Campo obrigatório')
    ],
  );
}

header(context, bool isediting) {
  return Padding(
    padding: EdgeInsets.only(top: Responsive.width(5)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          (!isediting) ? 'NOVO LANÇAMENTO' : 'EDITAR LANÇAMENTO',
          style: TextStyle(
              fontSize: Responsive.width(4),
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold),
        )
      ],
    ),
  );
}

searchFuntion(list) {
  return (key, items) {
    List<int> shownIndexes = [];
    int i = 0;
    items.forEach((item) {
      matchFn(item, keyword) {
        Map<String, dynamic> hospital = list
            .where((Map<String, dynamic> map) => map.containsValue(item.value))
            .toList()[0];
        return (hospital['name'].toLowerCase().contains(keyword.toLowerCase()));
      }

      if (matchFn(item, key) || (key?.isEmpty ?? true)) {
        shownIndexes.add(i);
      }
      i++;
    });
    return (shownIndexes);
  };
}

Future<void> statusmessage(BuildContext context, Icon icon, String message,
    [Function callback]) {
  return showDialog(
    context: context,
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Material(
              color: Colors.transparent,
              child: Text(
                message,
                style: TextStyle(
                    color: Colors.white, fontSize: Responsive.width(6)),
              ),
            ),
          ),
        ],
      ),
    ),
  ).then((value) {
    if (callback != null) callback(value);
  });
}
