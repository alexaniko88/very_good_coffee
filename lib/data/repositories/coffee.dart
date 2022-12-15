part of repositories;

@LazySingleton(as: CoffeeRepository)
class RealCoffeeRepository implements CoffeeRepository {
  const RealCoffeeRepository({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.coffeeMapper,
  });

  final CoffeeLocalDataSource localDataSource;
  final CoffeeRemoteDataSource remoteDataSource;
  final CoffeeMapper coffeeMapper;

  @override
  Future<Result<Coffee, Failure>> getRandomCoffee() async {
    try {
      final response = await remoteDataSource.getRandomCoffee();
      return response.fold(
        onSuccess: (coffeeResponse) => SuccessResult(
          coffeeMapper.coffee.fromEntity(coffeeResponse),
        ),
        onFailure: (failure) => FailureResult(failure),
      );
    } catch (e) {
      return FailureResult(UnexpectedFailure(e));
    }
  }
}

@LazySingleton(as: CoffeeLocalDataSource)
class RealCoffeeLocalDataSource implements CoffeeLocalDataSource {
  const RealCoffeeLocalDataSource();
}

@LazySingleton(as: CoffeeRemoteDataSource)
class RealCoffeeRemoteDataSource implements CoffeeRemoteDataSource {
  const RealCoffeeRemoteDataSource({
    @Named('CoffeeApi') required CoffeeApi api,
  }) : _api = api;

  final CoffeeApi _api;

  @override
  Future<Result<CoffeeResponse, Failure>> getRandomCoffee() async {
    try {
      final response = await _api.getRandomCoffee();
      return SuccessResult(response);
    } catch (e) {
      return FailureResult(UnexpectedFailure(e));
    }
  }
}
