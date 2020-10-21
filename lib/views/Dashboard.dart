/* 
 *  Martins & Gagliotti, todos os direitos reservados.
 *  Desenvolvido por figueiredo@protonmail.com
 */
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:martinsegagliotti/services/get_in_app_data.dart';
import 'package:martinsegagliotti/services/image_helper.dart';
import 'package:martinsegagliotti/services/login_service.dart';
import 'package:martinsegagliotti/services/responsive.dart';
import 'package:martinsegagliotti/services/theme.dart';
import 'package:martinsegagliotti/widgets/PerfilMedico.dart';
import 'package:martinsegagliotti/widgets/DashboardMenu.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int totalDeNotificacoes = 0;
  bool temMensagemNaoLida = false;

  Future<void> fetchNotificacoes([bool indicator]) async {
    var fetched = await GetInAppData.totalDeNotificacoes;
    var naolidas = await GetInAppData.naoLidas;
    setState(() {
      temMensagemNaoLida = naolidas;
      totalDeNotificacoes = fetched;
    });
    return;
  }

  @override
  void initState() {
    fetchNotificacoes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage('assets/images/logo.png'), context);
    Responsive(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: CustomAppBar.paraDashboard(context, callback: () {
        setState(() {
          totalDeNotificacoes = 0;
        });
      }, count: totalDeNotificacoes),
      body: Container(
        child: RefreshIndicator(
          onRefresh: () async {
            LoginService.refreshUser();
            fetchNotificacoes();
          },
          child: ListView(
            shrinkWrap: true,
            children: [
              PerfilMedico(),
              Builder(
                builder: (context) {
                  if (totalDeNotificacoes > 0) {
                    return AlertaDeNotificacoes(totalDeNotificacoes);
                  } else {
                    return SizedBox();
                  }
                },
              ),
              Builder(
                builder: (_) {
                  if (temMensagemNaoLida) {
                    return AlertaDeNotificacoes();
                  } else {
                    return SizedBox();
                  }
                },
              ),
              SizedBox(
                height: Responsive.height(1),
              ),
              DashboardMenu(messageCallback: () {
                if (temMensagemNaoLida) {
                  setState(() {
                    temMensagemNaoLida = false;
                  });
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class AlertaDeNotificacoes extends StatelessWidget {
  final int totalDeNotificacoes;
  const AlertaDeNotificacoes([this.totalDeNotificacoes]);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.red[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Builder(builder: (_) {
                  if (totalDeNotificacoes != null) {
                    return Text(
                      (totalDeNotificacoes == 1)
                          ? '1 NOVA NOTIFICAÇÃO'
                          : '$totalDeNotificacoes NOVAS NOTIFICAÇÕES',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Responsive.width(4),
                      ),
                    );
                  } else {
                    return Text(
                      'VOCÊ TEM NOVAS MENSAGENS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Responsive.width(4),
                      ),
                    );
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Theme.of(context).primaryColor,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Image(
                    image: AssetImage('assets/images/logo.png'),
                    colorBlendMode: BlendMode.srcATop,
                    color: Colors.white,
                  )),
              Divider(
                color: Colors.white,
                height: 10,
              ),
              DrawerMenuIem(() {
                Navigator.of(context).pushNamed('/novolancamento');
              }, icondata: Icons.add, texto: 'Novo Lançamento'),
              SizedBox(height: 10),
              DrawerMenuIem(() {
                Navigator.of(context).pushNamed('/mensagens');
              }, icondata: Icons.mail_outline, texto: 'Mensagens'),
              SizedBox(height: 10),
              DrawerMenuIem(() {
                Navigator.of(context).pushNamed('/rascunhos');
              }, icondata: Icons.attach_file, texto: 'Rascunhos'),
              SizedBox(height: 10),
              DrawerMenuIem(() {
                Navigator.of(context).pushNamed('/perfil');
              }, icondata: Icons.person_outline, texto: 'Perfil'),
              Expanded(
                child: Container(),
              ),
              Divider(
                color: Colors.white,
                height: 10,
              ),
              DrawerMenuIem(() {
                LoginService.logout();
                ImageHelperService.clearTempFolder();
                Navigator.of(context).pushReplacementNamed('/login');
              }, icondata: Icons.close, texto: 'Sair'),
            ],
          ),
        ),
      ),
    );
  }
}

class DrawerMenuIem extends StatelessWidget {
  final IconData icondata;
  final String texto;
  final Function fn;
  const DrawerMenuIem(this.fn, {Key key, this.icondata, this.texto})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: Color(0x22FFFFFF),
        child: InkWell(
          onTap: fn,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                Icon(
                  icondata,
                  color: Colors.white,
                  size: Responsive.width(8),
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  texto,
                  style: TextStyle(
                      fontSize: Responsive.width(5),
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontFamily: 'Roboto'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
