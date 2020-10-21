/* 
 *  Martins & Gagliotti, todos os direitos reservados.
 *  Desenvolvido por figueiredo@protonmail.com
 */

import 'package:flutter/material.dart';
import 'package:martinsegagliotti/services/responsive.dart';

class DashboardMenuTile extends StatelessWidget {
  const DashboardMenuTile({Key key, this.title, this.icon, this.route})
      : super(key: key);

  final String title;
  final IconData icon;
  final String route;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Responsive.width(1.5)),
      child: Container(
        width: Responsive.width(45),
        height: Responsive.height(34),
        child: Material(
          color: Color(0xAAD0F1F1),
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            enableFeedback: true,
            onTap: () {
              Navigator.pushNamed(context, route);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(icon,
                    size: Responsive.width(12), color: Color(0xFF6085FF)),
                SizedBox(
                  height: Responsive.width(4),
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: Responsive.width(4),
                    color: Color(0xFF6085FF),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
