part of api;

class _Constants{
  static const String baseURL = "https://coffee.alexflipnote.dev";
}
abstract class BaseApi {
  final http.Client client;

  BaseApi({
    @factoryParam required this.client,
  });

  Future<http.Response> get(String url) => client.get(
        Uri.parse("${_Constants.baseURL}$url"),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
      ).timeout(const Duration(seconds: 1));
}

@module
abstract class HttpClientModule {
  @lazySingleton
  http.Client get httpClient => http.Client();
}
