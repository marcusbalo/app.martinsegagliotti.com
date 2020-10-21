import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:martinsegagliotti/services/image_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

const url = 'http://hostmgm:8888';

int backgroundtask(List items) {
  int index = items[0].indexWhere(
      (element) => Map.from(json.decode(element))['id'] == items[1]);
  return index;
}

class OfflineService {
  SharedPreferences storage;
  static OfflineService _instance;
  OfflineService._(SharedPreferences st) {
    this.storage = st;
  }

  static Future<OfflineService> instance() async {
    if (_instance == null) {
      _instance = OfflineService._(await SharedPreferences.getInstance());
      return _instance;
    } else {
      return _instance;
    }
  }

  appendRascunhos(Map newEntry) async {
    List<String> lista = this.storage.getStringList('rascunhos') ?? <String>[];
    newEntry['date'] = newEntry['date'].toString();
    newEntry.addAll({"id": lista.length * 11});
    if (newEntry['files'].length == 0) {
      newEntry.remove('files');
    }
    lista.add(json.encode(newEntry));
    return await this.storage.setStringList('rascunhos', lista);
  }

  Future<bool> removerRascunhoPeloId(int id) async {
    List<String> rascunhos =
        this.storage.getStringList('rascunhos') ?? <String>[];

    int position = await compute(backgroundtask, <dynamic>[rascunhos, id]);

    if (position != -1) {
      Map rasc = Map<String, dynamic>.from(jsonDecode(rascunhos[position]));
      if (rasc.containsKey('files')) {
        if (rasc['files'] != null) {
          ImageHelperService.deleteFromList(List<String>.from(rasc['files']));
        }
      }
      rascunhos.removeAt(position);
      this.storage.setStringList('rascunhos', rascunhos);
      return true;
    } else {
      return false;
    }
  }

  clearRascunhos() {
    this.storage.clear();
  }

  salvarHospitais(hospitais) async {
    return this.storage.setString('hospitais', json.encode(hospitais));
  }

  salvarMedicos(medicos) async {
    return this.storage.setString('medicos', json.encode(medicos));
  }

  getHospitais() {
    try {
      return jsonDecode(this.storage.get('hospitais'));
    } catch (e) {
      return [];
    }
  }

  getMedicos() {
    try {
      return jsonDecode(this.storage.get('medicos'));
    } catch (e) {
      return [];
    }
  }

  getAny(String key) {
    return this.storage.get(key);
  }

  setAny(String key, String value) async {
    return this.storage.setString(key, value);
  }

  getStorage() {
    return this.storage;
  }
}
