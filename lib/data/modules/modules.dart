import 'package:http/http.dart';
import 'package:injectable/injectable.dart';
import 'package:very_good_coffee/data/managers/managers.dart';

@module
abstract class FileSourceModule {
  @lazySingleton
  FileSource get fileSource => const FileSource();
}

@module
abstract class HttpClientModule {
  @lazySingleton
  Client get httpClient => Client();
}