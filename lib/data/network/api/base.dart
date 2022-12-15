import 'dart:io';

import 'package:http/http.dart';
import 'package:injectable/injectable.dart';

class _Constants{
  static const String baseURL = "https://coffee.alexflipnote.dev";
}
abstract class BaseApi {
  final Client client;

  BaseApi({
    @factoryParam required this.client,
  });

  Future<Response> get(String url) => client.get(
        Uri.parse("${_Constants.baseURL}$url"),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
      );
}

@module
abstract class HttpClientModule {
  @lazySingleton
  Client get httpClient => Client();
}
