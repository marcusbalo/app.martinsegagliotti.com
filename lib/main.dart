/* 
 *  Martins & Gagliotti, todos os direitos reservados.
 *  Desenvolvido por figueiredo@protonmail.com
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:martinsegagliotti/services/login_service.dart';
import 'package:martinsegagliotti/services/service_locator.dart';
import 'package:martinsegagliotti/services/theme.dart';
import 'package:martinsegagliotti/views/Documentos.dart';
import 'package:martinsegagliotti/views/LoginView.dart';
import 'package:martinsegagliotti/views/Dashboard.dart';
import 'package:martinsegagliotti/views/EmCurso.dart';
import 'package:martinsegagliotti/views/Mensagens.dart';
import 'package:martinsegagliotti/views/Nfe.dart';
import 'package:martinsegagliotti/views/Notificacoes.dart';
import 'package:martinsegagliotti/views/cadastro.dart';
import 'package:martinsegagliotti/views/file_upload.dart';
import 'package:martinsegagliotti/views/novo_lancamento.dart';
import 'package:martinsegagliotti/views/rascunhos.dart';

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  Widget home = (await LoginService.haslogin()) ? Dashboard() : LoginView();
  runApp(MGApp(home: home));
}

class MGApp extends StatelessWidget {
  final Widget home;
  const MGApp({Key key, this.home}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage('assets/images/loginbackground.jpg'), context);
    return new MaterialApp(
      theme: AppTheme.data,
      debugShowCheckedModeBanner: false,
      title: 'Martins & Gagliotti',
      home: home,
      routes: {
        '/emcurso': (context) => EmCurso(),
        '/novolancamento': (context) => NovoLancamento(),
        '/mensagens': (context) => Mensagens(),
        '/documentos': (context) => Documentos(),
        '/nfe': (context) => Nfe(),
        '/notificacoes': (context) => Notificacoes(),
        '/login': (context) => LoginView(),
        '/dashboard': (context) => Dashboard(),
        '/rascunhos': (context) => Rascunhos(),
        '/uploadfile': (context) => FileUpload(),
        '/cadastro': (context) => Cadastro(),
        '/perfil': (context) => Cadastro(isEditing: true),
      },
    );
  }
}
