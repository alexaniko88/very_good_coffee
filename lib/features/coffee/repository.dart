part of coffee;

abstract class CoffeeRepository {
  Future<Result<Coffee, Failure>> getRandomCoffee();

  Future<Result<Coffee, Failure>> getFavoriteCoffee();

  Future<Result<String, Failure>> storeFavoriteCoffee(String url);
}

abstract class CoffeeLocalDataSource {
  Future<Result<String, Failure>> storeFavoriteCoffee(String url);

  Future<Result<CoffeeResponse, Failure>> getFavoriteCoffee();
}

abstract class CoffeeRemoteDataSource {
  Future<Result<CoffeeResponse, Failure>> getRandomCoffee();
}
