/* 
 *  Martins & Gagliotti, todos os direitos reservados.
 *  Desenvolvido por figueiredo@protonmail.com
 */
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:martinsegagliotti/model/user.dart';
import 'package:martinsegagliotti/services/image_helper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Dio dio = Dio();

const url = 'http://sistema.martinsegagliotti.com.br';

class LoginService {
  static Future<bool> auth({String user, String password}) async {
    final storage = await SharedPreferences.getInstance();
    try {
      var response = await dio.post("$url/oauth/token",
          options: Options(
            headers: {'Accept': 'application/json'},
            receiveTimeout: 5 * 1000,
            sendTimeout: 5 * 1000,
          ),
          data: {
            "grant_type": 'password',
            "client_id": '2',
            "client_secret": 'T9ukUfzPWlXEG5Td2IwJhzeMlUxv2xtnWgoxKZDD',
            "username": user,
            "password": password
          });
      var content = response.data;
      String token = content['access_token'];
      await refreshUser(token, storage);
      return haslogin();
    } on Exception catch (_) {
      print(_);
      storage.remove('token');
      storage.remove('user');
      return false;
    }
  }

  static Future<void> refreshUser(
      [String token, SharedPreferences storage]) async {
    if (token == null) {
      token = await LoginService.token;
      storage = await SharedPreferences.getInstance();
      return;
    }
    try {
      var _user = await dio.get("$url/api/user",
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          }));
      storage.setString('token', token);
      storage.setString('user', json.encode(_user.data));
      return;
    } on Exception catch (_) {
      return;
    }
  }

  static Future<bool> haslogin() async {
    return await token != null;
  }

  static Future<void> logout() async {
    final storage = await SharedPreferences.getInstance();
    await ImageHelperService.clearTempFolder();
    var savepath;

    if (Platform.isAndroid) {
      savepath = (await getExternalStorageDirectory()).path + '/MGAPP/';
    } else {
      savepath = (await getApplicationDocumentsDirectory()).path + '/MGAPP/';
    }

    final Directory folder = Directory(savepath);

    if (await folder.exists()) {
      folder.delete(recursive: true);
    }
    storage.clear();
  }

  static get token async {
    final storage = await SharedPreferences.getInstance();
    var _token = storage.get('token');
    return _token;
  }

  static Future<User> get user async {
    final storage = await SharedPreferences.getInstance();
    var user = Map<String, dynamic>.from(json.decode(storage.get('user')));
    return User.from(user);
  }
}
