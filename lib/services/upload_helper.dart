import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:martinsegagliotti/services/image_helper.dart';
import 'package:martinsegagliotti/services/login_service.dart';
import 'package:martinsegagliotti/services/offline_service.dart';

const url = 'http://hostmgm:8888';

class UploadHelperService {
  Map<String, dynamic> corpo = {};
  List<String> arquivos = [];
  List<int> team = [];

  addImagePath(String path) {
    this.arquivos.add(path);
  }

  Future<List<MultipartFile>> pathsToMultipart() async {
    List<MultipartFile> mf = [];
    for (var file in this.arquivos) {
      mf.add(MultipartFile.fromFileSync(file));
    }
    return mf;
  }

  Future<int> uploadForm([bool isediting]) async {
    OfflineService off = await OfflineService.instance();

    List<String> imagelist = [];

    Dio dio = new Dio(BaseOptions(connectTimeout: 5 * 1000));

    Response connectionresult;
    connectionresult = await dio
        .get('$url/test',
            options: Options(
              receiveTimeout: 1000,
              sendTimeout: 1000,
            ))
        .catchError((_) {
      print(_);
    });

    if ((connectionresult?.statusCode != 200 ?? true) && isediting == null) {
      for (var f in arquivos) {
        imagelist.add(await GetIt.I<ImageHelperService>().toDisk(f));
      }
      await off.appendRascunhos({...corpo, 'files': imagelist});
      return 3;
    }

    if ((connectionresult?.statusCode != 200 ?? true) && isediting != null) {
      return 3;
    }

    FormData data = FormData.fromMap({
      ...corpo,
      "files": await pathsToMultipart(),
    });

    String token = await LoginService.token;

    var response = await dio
        .post(
      '$url/api/newapp/reports',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
        receiveTimeout: 15 * 1000,
      ),
      data: data,
    )
        .catchError((_) async {
      print(_);
      if (isediting == null) {
        for (var f in arquivos) {
          imagelist.add(await GetIt.I<ImageHelperService>().toDisk(f));
        }
        await off.appendRascunhos({...corpo, 'files': imagelist});
      }
    });
    return (response?.statusCode == 200 ?? false) ? 1 : 3;
  }

  updateFiles(List<String> imageFiles) {
    this.arquivos = imageFiles;
  }

  Map<String, dynamic> updateBody(
      Map<String, dynamic> map, List<String> keysToKeep) {
    this.corpo.clear();
    this.corpo.addAll(map);
    this.corpo.addAll({'team': team});
    if (keysToKeep == null) {
      //
    } else {
      this.corpo = removeFromList(keysToKeep);
    }
    return {...this.corpo};
  }

  Map<String, dynamic> clearBody() {
    this.corpo.removeWhere((key, value) => value == '' || value == null);
    return {...this.corpo};
  }

  Map<String, dynamic> removeFromList(List<String> keys) {
    Map<String, dynamic> holder = {};
    List<String> keep = ['date', 'tipo', 'hospital', 'imagens']..addAll(keys);
    for (var k in keep) {
      if (this.corpo.containsKey(k)) {
        holder.addAll(<String, dynamic>{k: corpo[k]});
      }
    }
    return holder;
  }
}
