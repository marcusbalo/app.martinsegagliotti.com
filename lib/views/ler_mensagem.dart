import 'package:flutter/material.dart';
import 'package:martinsegagliotti/services/get_in_app_data.dart';
import 'package:martinsegagliotti/services/responsive.dart';
import 'package:martinsegagliotti/services/theme.dart';

class LerMensagem extends StatefulWidget {
  final int id;
  final String photo;
  final String name;
  LerMensagem({Key key, this.id, this.photo, this.name}) : super(key: key);

  @override
  _LerMensagemState createState() => _LerMensagemState();
}

class _LerMensagemState extends State<LerMensagem> {
  List<Map<String, dynamic>> mensagens;

  final scrollController = ScrollController();

  bool isloading = false;

  TextEditingController msgcontroller = TextEditingController();

  Future<void> fetchMensagem([bool indicator]) async {
    if (indicator != null) {
      setState(() {
        isloading = true;
      });
    }
    var fetched = await GetInAppData.mensagens(widget.id);
    setState(() {
      isloading = false;
      mensagens = fetched;
    });
    return;
  }

  @override
  void initState() {
    fetchMensagem(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFEE),
      appBar: CustomAppBar.semNotificacao(context),
      body: Builder(
        builder: (_) {
          if (mensagens == null && !isloading) {
            return Center(
                child: Text(
              'VOCÊ ESTÁ OFFLINE',
              style: TextStyle(
                  fontSize: Responsive.width(4),
                  color: Colors.red[300],
                  fontWeight: FontWeight.bold),
            ));
          } else if (isloading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(Responsive.width(2)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).primaryColor.withAlpha(30),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: Responsive.width(6),
                        backgroundImage: NetworkImage(widget.photo),
                      ),
                      title: Text(
                        widget.name,
                        style: TextStyle(fontSize: Responsive.width(4.5)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Responsive.width(5),
                          vertical: Responsive.width(8)),
                      child: ListView.builder(
                        controller: scrollController,
                        shrinkWrap: true,
                        itemBuilder: (_, index) {
                          return Bubble.from(mensagens[index]);
                        },
                        itemCount: mensagens.length,
                      ),
                    ),
                  ),
                  Container(
                    color: Theme.of(context).primaryColor.withAlpha(100),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: Responsive.width(5)),
                      child: SafeArea(
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: msgcontroller,
                                keyboardType: TextInputType.text,
                                style:
                                    TextStyle(fontSize: Responsive.width(4.5)),
                                decoration: InputDecoration(
                                  labelText: 'Digite sua Mensagem',
                                  filled: true,
                                  fillColor: Colors.white,
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
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
                            ),
                            SizedBox(
                              width: Responsive.width(2),
                            ),
                            FloatingActionButton(
                              backgroundColor: Theme.of(context).primaryColor,
                              onPressed: () async {
                                if (msgcontroller.text.isNotEmpty) {
                                  bool response =
                                      await GetInAppData.postarmensagem({
                                    'message': msgcontroller.text,
                                    'id': widget.id,
                                  });
                                  if (response) {
                                    setState(() {
                                      mensagens.add({
                                        'body': msgcontroller.text,
                                        'owner': 'me',
                                        'date': 'agora'
                                      });
                                    });
                                    msgcontroller.text = '';
                                    scrollController.jumpTo(
                                      scrollController
                                              .position.maxScrollExtent +
                                          50,
                                    );
                                  }
                                }
                              },
                              child: Icon(
                                Icons.send,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class Bubble extends StatelessWidget {
  final String body;
  final String date;
  final String owner;
  const Bubble({Key key, this.body, this.date, this.owner}) : super(key: key);

  static Bubble from(message) {
    return Bubble(
      body: message['body'],
      date: message['date'],
      owner: message['owner'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
              child: Align(
            alignment: (owner == 'me')
                ? AlignmentDirectional.centerEnd
                : AlignmentDirectional.centerStart,
            child: Container(
              decoration: BoxDecoration(
                color: (owner == 'me') ? Color(0xFFDFDFFF) : Color(0xFFDFFFFF),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(Responsive.width(3)),
              child: Text(
                body,
                style: TextStyle(
                  fontSize: Responsive.width(4),
                ),
              ),
            ),
          ))
        ],
      ),
    );
  }
}
