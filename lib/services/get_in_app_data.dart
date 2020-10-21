/* 
 *  Martins & Gagliotti, todos os direitos reservados.
 *  Desenvolvido por figueiredo@protonmail.com
 */
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:martinsegagliotti/services/offline_service.dart';
import 'login_service.dart';

const url = 'http://sistema.martinsegagliotti.com.br';

Dio dio = Dio(BaseOptions(connectTimeout: 5 * 1000));

backgroundTask(List<String> lista) {
  List<Map<String, dynamic>> output = [];
  for (var item in lista) {
    output.add(json.decode(item));
  }
  return output;
}

abstract class GetInAppData {
  static Future<List<Map<String, dynamic>>> get hospitais async {
    try {
      String token = await LoginService.token;
      final response = await dio.get("$url/api/hospitals",
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      return List<Map<String, dynamic>>.from((response.data));
    } catch (e) {
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> get userHospitais async {
    var off = await OfflineService.instance();
    try {
      String token = await LoginService.token;
      final response = await dio.get("$url/api/perfil/hospitais",
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      off.salvarHospitais(response.data);
      print(response.data);
      return List<Map<String, dynamic>>.from((response.data));
    } catch (e) {
      print('Error');
      print(e);
      return List<Map<String, dynamic>>.from((off.getHospitais()));
    }
  }

  static Future<List<Map<String, dynamic>>> get medicos async {
    var off = await OfflineService.instance();
    try {
      String token = await LoginService.token;
      final response = await dio.get("$url/api/doctors",
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      off.salvarMedicos(response.data);
      return List<Map<String, dynamic>>.from((response.data));
    } catch (e) {
      print(e);
      return List<Map<String, dynamic>>.from((off.getMedicos()));
    }
  }

  static Future<Map<String, dynamic>> perfil(bool isediting) async {
    if (isediting) {
      String token = await LoginService.token;
      final response = await dio.get("$url/api/perfil",
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      return Map<String, dynamic>.from(response.data)
        ..remove('id')
        ..remove('user_id')
        ..remove('started_in');
    } else {
      return {};
    }
  }

  static Future<int> get totalDeNotificacoes async {
    String token = await LoginService.token;
    final response = await dio
        .get("$url/api/notificacoes/total",
            options: Options(headers: {'Authorization': 'Bearer $token'}))
        .catchError((_) {
      print(_);
    });

    return (response?.statusCode == 200 ?? false)
        ? (response?.data['notificacoes'] ?? 0)
        : 0;
  }

  static Future<List<Map<String, dynamic>>> get listaDeNotificacoes async {
    String token = await LoginService.token;
    final response = await dio
        .get("$url/api/notificacoes/listar",
            options: Options(headers: {'Authorization': 'Bearer $token'}))
        .catchError((_) {
      print(_);
    });
    return (response?.statusCode == 200 ?? false)
        ? List<Map<String, dynamic>>.from((response.data))
        : null;
  }

  static Future<bool> confirmarNotificacao(id) async {
    String token = await LoginService.token;
    final response = await dio
        .get("$url/api/notificacoes/confirmar/$id",
            options: Options(headers: {'Authorization': 'Bearer $token'}))
        .catchError((_) {
      print(_);
    });
    return (response?.statusCode == 200 ?? false) ? true : false;
  }

  static Future<List<Map<String, dynamic>>> lancamentos(
      {bool rascunhos}) async {
    if (rascunhos == null) {
      try {
        String token = await LoginService.token;
        final response = await dio.get("$url/api/reports",
            options: Options(headers: {'Authorization': 'Bearer $token'}));
        final result = List<Map<String, dynamic>>.from((response.data));
        return result;
      } catch (e) {
        return null;
      }
    } else {
      var off = await OfflineService.instance();
      List<String> rascunhos = off.storage.getStringList('rascunhos');
      if (rascunhos != null) {
        var result = await compute(backgroundTask, rascunhos);
        return result;
      }
    }
    return [];
  }

  static Future<Map<String, int>> get indicadores async {
    try {
      String token = await LoginService.token;
      final response = await dio.get("$url/api/indicadores",
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      return Map<String, int>.from((response.data));
    } catch (e) {
      return null;
    }
  }

  static Future<Map<String, dynamic>> apagarLancamento(int id) async {
    String token = await LoginService.token;
    final response = await dio.delete("$url/api/newapp/reports/$id",
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        }));
    return Map<String, dynamic>.from((response.data));
  }

  static Future<List<Map<String, dynamic>>> conversas() async {
    String token = await LoginService.token;
    final response = await dio
        .get(
      "$url/api/messages",
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    )
        .catchError((_) {
      print(_);
    });
    print(response.data);
    return (response?.statusCode == 200 ?? false)
        ? List<Map<String, dynamic>>.from((response.data))
        : null;
  }

  static Future<List<Map<String, dynamic>>> mensagens(int id) async {
    String token = await LoginService.token;
    final response = await dio
        .get(
      "$url/api/messages/$id",
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    )
        .catchError((_) {
      print(_);
    });
    return (response?.statusCode == 200 ?? false)
        ? List<Map<String, dynamic>>.from((response.data))
        : null;
  }

  static Future<bool> postarmensagem(Map<String, dynamic> message) async {
    String token = await LoginService.token;
    final response = await dio
        .post(
      "$url/api/messages",
      data: message,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    )
        .catchError((_) {
      print(_);
    });
    return (response?.statusCode == 200 ?? false) ? response.data : false;
  }

  static Future<bool> get naoLidas async {
    String token = await LoginService.token;
    final response = await dio
        .get(
      "$url/api/messages/has-unread",
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    )
        .catchError((_) {
      print(_);
    });
    return (response?.statusCode == 200 ?? false) ? response.data : false;
  }

  static Future<bool> apagarMensagem(id) async {
    String token = await LoginService.token;
    final response = await dio
        .delete(
      "$url/api/messages/$id",
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    )
        .catchError((_) {
      print(_);
    });
    return (response?.statusCode == 200 ?? false) ? true : false;
  }

  static Future<List<Map<String, dynamic>>> documentos() async {
    String token = await LoginService.token;
    final response = await dio
        .get(
      "$url/api/files",
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    )
        .catchError((_) {
      print(_);
    });
    return (response?.statusCode == 200 ?? false)
        ? List<Map<String, dynamic>>.from((response.data))
        : null;
  }
}
