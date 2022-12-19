part of network;

typedef FromJsonParser<T> = T Function(Map<String, dynamic> json);

class _Constants {
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

  T processAndParseResponse<T>({
    required http.Response response,
    required FromJsonParser<T> parser,
  }) {
    if (response.statusCode >= HttpStatus.ok &&
        response.statusCode <= HttpStatus.imUsed) {
      return parser.call(json.decode(response.body));
    } else {
      throw json.decode(response.body)["error"];
    }
  }

  http.Response processResponse(http.Response response) {
    if (response.statusCode >= HttpStatus.ok &&
        response.statusCode <= HttpStatus.imUsed) {
      return response;
    } else {
      throw json.decode(response.body)["error"];
    }
  }
}