import 'package:flutter/material.dart';
import 'package:martinsegagliotti/services/login_service.dart';
import 'package:martinsegagliotti/services/responsive.dart';

class LoginView extends StatefulWidget {
  LoginView({Key key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

customButton(fn, BuildContext context, String texto, {Color color}) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
        color: color ?? Theme.of(context).accentColor.withAlpha(255),
        borderRadius: BorderRadius.circular(5)),
    child: FlatButton(
      onPressed: fn,
      child: Text(
        texto,
        style: TextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.white,
            fontSize: Responsive.width(5)),
      ),
    ),
  );
}

class _LoginViewState extends State<LoginView> with TickerProviderStateMixin {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  bool hasError = false;
  AnimationController _controller;
  Animation _animation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage('assets/images/loginbackground.jpg'), context);
    Responsive(context);
    return Scaffold(
      body: Stack(
        children: [
          FadeTransition(
            opacity: _animation,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                image: DecorationImage(
                  image: AssetImage('assets/images/loginbackground.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              width: double.infinity,
              child: Column(
                children: [
                  Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    width: Responsive.width(90),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).primaryColor.withAlpha(200),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image(
                          color: Colors.white,
                          image: AssetImage('assets/images/logo.png'),
                        ),
                        Builder(
                          builder: (_) {
                            if (hasError) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3),
                                    color: Colors.red.withAlpha(120),
                                  ),
                                  child: Text(
                                    'Usuário ou senha inválidos!',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: Responsive.width(4.5)),
                                  ),
                                ),
                              );
                            } else {
                              return SizedBox();
                            }
                          },
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(fontSize: Responsive.width(4.5)),
                          decoration: InputDecoration(
                            labelText: 'Email',
                            filled: true,
                            fillColor: Colors.white,
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            border: new OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(5.0),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          style: TextStyle(fontSize: Responsive.width(4.5)),
                          controller: passController,
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Senha',
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            filled: true,
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(5.0),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        customButton(() async {
                          loginLoad(true, context);
                          bool result = await LoginService.auth(
                              user: emailController.text,
                              password: passController.text);
                          if (result) {
                            loginLoad(false, context);
                            Navigator.of(context)
                                .pushReplacementNamed('/dashboard');
                          } else {
                            setState(() {
                              hasError = true;
                            });
                            loginLoad(false, context);
                          }
                        }, context, 'Entrar'),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: FlatButton(
                color: Colors.black45,
                child: Text(
                  'Cadastrar-me',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: Responsive.width(5),
                      fontWeight: FontWeight.w400),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed('/cadastro');
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

loginLoad(bool show, context) {
  if (show) {
    showDialog(
      context: context,
      barrierDismissible: false,
      child: Container(
          child: Center(
        child: CircularProgressIndicator(),
      )),
    );
  } else {
    Navigator.of(context).pop();
  }
}
