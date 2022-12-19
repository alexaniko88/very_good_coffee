part of network;

@named
@injectable
class CoffeeApi extends BaseApi {
  CoffeeApi({required super.client});

  Future<CoffeeResponse> getRandomCoffee() => get('/random.json').then(
        (response) => processAndParseResponse(
          response: response,
          parser: (json) => CoffeeResponse.fromJson(json),
        ),
      );

  Future<http.Response> getSpecificCoffee(String coffeeName) =>
      get("/$coffeeName").then((response) => processResponse(response));
}
