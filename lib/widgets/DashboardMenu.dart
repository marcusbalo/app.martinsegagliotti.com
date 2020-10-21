/* 
 *  Martins & Gagliotti, todos os direitos reservados.
 *  Desenvolvido por figueiredo@protonmail.com
 */

import 'package:flutter/material.dart';
import 'DashboardMenuTile.dart';

class DashboardMenu extends StatelessWidget {
  final Function messageCallback;
  const DashboardMenu({Key key, this.messageCallback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              new DashboardMenuTile(
                icon: Icons.show_chart,
                title: 'Em curso',
                route: '/emcurso',
              ),
              GestureDetector(
                onTapDown: (_) {
                  messageCallback();
                },
                child: new DashboardMenuTile(
                  icon: Icons.mail_outline,
                  title: 'Mensagens',
                  route: '/mensagens',
                ),
              ),
              new DashboardMenuTile(
                icon: Icons.filter_none,
                title: 'Notas Fiscais',
                route: '/nfe',
              )
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              new DashboardMenuTile(
                icon: Icons.content_paste,
                title: 'Novo lançamento',
                route: '/novolancamento',
              ),
              new DashboardMenuTile(
                icon: Icons.folder_open,
                title: 'Documentos',
                route: '/documentos',
              ),
              new DashboardMenuTile(
                icon: Icons.attach_file,
                title: 'Rascunhos',
                route: '/rascunhos',
              )
            ],
          ),
        ],
      ),
    );
  }
}
