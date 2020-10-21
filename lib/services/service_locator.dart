import 'package:get_it/get_it.dart';
import 'package:martinsegagliotti/services/image_helper.dart';
import 'package:martinsegagliotti/services/upload_helper.dart';

Future<void> setupLocator() async {
  GetIt.I.registerLazySingleton<ImageHelperService>(() => ImageHelperService());
  GetIt.I
      .registerLazySingleton<UploadHelperService>(() => UploadHelperService());
}
