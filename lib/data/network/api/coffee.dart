import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:very_good_coffee/data/models/coffee/coffee_models.dart';
import 'package:very_good_coffee/data/network/api/base.dart';

@named
@injectable
class CoffeeApi extends BaseApi {
  CoffeeApi({required super.client});

  Future<CoffeeResponse> getRandomCoffee() {
    return get('/random.json').then(
      (loginResult) {
        if (loginResult.statusCode == 200) {
          return CoffeeResponse.fromJson(json.decode(loginResult.body));
        } else {
          throw json.decode(loginResult.body)["error"];
        }
      },
    );
  }
}
