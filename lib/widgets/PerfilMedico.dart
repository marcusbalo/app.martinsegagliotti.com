import 'package:flutter/material.dart';
import 'package:martinsegagliotti/model/user.dart';
import 'package:martinsegagliotti/services/get_in_app_data.dart';
import 'package:martinsegagliotti/services/login_service.dart';
import 'package:martinsegagliotti/services/responsive.dart';

class PerfilMedico extends StatefulWidget {
  const PerfilMedico({Key key}) : super(key: key);

  @override
  _PerfilMedicoState createState() => _PerfilMedicoState();
}

class _PerfilMedicoState extends State<PerfilMedico> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: LoginService.user,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return DashboardProfile(user: snapshot.data);
        } else {
          return DashboardProfile();
        }
      },
    );
  }
}

class DashboardProfile extends StatelessWidget {
  final User user;
  const DashboardProfile({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          color: Theme.of(context).primaryColor,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: Responsive.width(11),
                  backgroundColor: Colors.white,
                  child: Builder(
                    builder: (_) {
                      if (user != null) {
                        return CircleAvatar(
                          radius: Responsive.width(10),
                          backgroundImage: this.user.image,
                          backgroundColor: Colors.transparent,
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                ),
                SizedBox(width: Responsive.width(5)),
                Builder(builder: (_) {
                  if (user != null) {
                    return Flexible(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            this.user.nome,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: Responsive.width(5.5)),
                          ),
                          Text(
                            this.user.especialidade,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                fontWeight: FontWeight.w200,
                                color: Colors.white,
                                fontSize: Responsive.width(4.5)),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            this.user.email,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                color: Colors.blue[100],
                                fontSize: Responsive.width(4.5)),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return TextPlaceholder();
                  }
                })
              ],
            ),
          ),
        ),
        DashboardReports(),
      ],
    );
  }
}

class DashboardReports extends StatefulWidget {
  const DashboardReports({Key key}) : super(key: key);

  @override
  _DashboardReportsState createState() => _DashboardReportsState();
}

class _DashboardReportsState extends State<DashboardReports> {
  @override
  void didUpdateWidget(DashboardReports oldWidget) {
    setState(() {});
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: GetInAppData.indicadores,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Indicadores(
            indicadores: snapshot.data,
          );
        } else {
          return Indicadores(
            indicadores: null,
          );
        }
      },
    );
  }
}

class Indicadores extends StatelessWidget {
  final Map<String, int> indicadores;
  const Indicadores({Key key, this.indicadores}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(30),
              bottomLeft: Radius.circular(30)),
          color: Theme.of(context).primaryColor),
      child: Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ReportCounter(
                count: (indicadores != null) ? indicadores['aprovados'] : 0,
                title: 'Aprovados',
                color: Colors.green[300]),
            ReportCounter(
                count: (indicadores != null) ? indicadores['negados'] : 0,
                title: 'Negados',
                color: Colors.red[300]),
            ReportCounter(
                count: (indicadores != null) ? indicadores['pendentes'] : 0,
                title: 'Pendentes',
                color: Colors.blue[300]),
          ],
        ),
      ),
    );
  }
}

class ReportCounter extends StatelessWidget {
  const ReportCounter({Key key, this.title, this.count, this.color})
      : super(key: key);

  final String title;
  final dynamic count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3), color: Color(0x22FFFFFF)),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 15,
            ),
            child: Text(
              this.title,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: Responsive.width(3.8),
                  fontWeight: FontWeight.w400),
            ),
          ),
        ),
        SizedBox(height: 10),
        Text(
          count.toString(),
          style: TextStyle(fontSize: Responsive.width(7), color: Colors.white),
        ),
      ],
    );
  }
}

class TextPlaceholder extends StatelessWidget {
  const TextPlaceholder({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: Responsive.height(4),
          width: Responsive.width(40),
          color: Colors.blue[100],
        ),
        SizedBox(height: Responsive.height(3)),
        Container(
          height: Responsive.height(3),
          width: Responsive.width(25),
          color: Colors.blue[100],
        ),
        SizedBox(height: Responsive.height(3)),
        Container(
          height: Responsive.height(3),
          width: Responsive.width(35),
          color: Colors.blue[100],
        ),
      ],
    );
  }
}
