part of api;

@named
@injectable
class CoffeeApi extends BaseApi {
  CoffeeApi({required super.client});

  Future<CoffeeResponse> getRandomCoffee() {
    return get('/random.json').then(
      (result) {
        if (result.statusCode == 200) {
          return CoffeeResponse.fromJson(json.decode(result.body));
        } else {
          throw json.decode(result.body)["error"];
        }
      },
    );
  }

  Future<http.Response> getSpecificCoffee(String coffeeName) {
    return get("/$coffeeName").then(
      (result) {
        if (result.statusCode == 200) {
          return result;
        } else {
          throw json.decode(result.body)["error"];
        }
      },
    );
  }
}
