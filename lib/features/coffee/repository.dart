part of coffee;

abstract class CoffeeRepository {
  const CoffeeRepository();

  Future<Result<Coffee, Failure>> getRandomCoffee();
}

abstract class CoffeeLocalDataSource {
  const CoffeeLocalDataSource();
}

abstract class CoffeeRemoteDataSource {
  const CoffeeRemoteDataSource();

  Future<Result<CoffeeResponse, Failure>> getRandomCoffee();
}
