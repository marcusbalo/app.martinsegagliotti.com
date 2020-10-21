import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class User {
  int id;
  String nome;
  String email;
  String photo;
  String especialidade;
  Map<String, int> indicadores;

  User.from(parse) {
    this.id = parse['id'];
    this.nome = parse['name'];
    this.email = parse['email'];
    this.photo = parse['photo'];
    this.especialidade = parse['especialidade'];
  }

  get image {
    if (this.photo != null && this.photo.isNotEmpty)
      return CachedNetworkImageProvider(
        "https://sistema.martinsegagliotti.com.br/profile_photo/${this.photo}",
      );
    else
      return AssetImage('assets/images/default.jpg');
  }
}
