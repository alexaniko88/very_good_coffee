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
    final response = await remoteDataSource.getRandomCoffee();
    return response.fold(
      onSuccess: (coffeeResponse) => SuccessResult(
        coffeeMapper.coffee.fromEntity(coffeeResponse),
      ),
      onFailure: (failure) => FailureResult(failure),
    );
  }

  @override
  Future<Result<Coffee, Failure>> getFavoriteCoffee() async {
    final localResponse = await localDataSource.getFavoriteCoffee();
    return localResponse.fold(
      onSuccess: (coffeeResponse) => SuccessResult(
        coffeeMapper.favoriteCoffee.fromEntity(coffeeResponse),
      ),
      onFailure: (failure) async {
        final remoteResponse = await remoteDataSource.getRandomCoffee();
        return remoteResponse.fold(
          onSuccess: (coffeeResponse) => SuccessResult(
            coffeeMapper.coffee.fromEntity(coffeeResponse),
          ),
          onFailure: (failure) => FailureResult(failure),
        );
      },
    );
  }

  @override
  Future<Result<String, Failure>> storeFavoriteCoffee(String url) =>
      localDataSource.storeFavoriteCoffee(url);
}

@LazySingleton(as: CoffeeLocalDataSource)
class RealCoffeeLocalDataSource implements CoffeeLocalDataSource {
  const RealCoffeeLocalDataSource({
    @Named('CoffeeApi') required this.api,
    @Named('FileManager') required this.fileManager,
  });

  final CoffeeApi api;
  final FileManager fileManager;

  @override
  Future<Result<CoffeeResponse, Failure>> getFavoriteCoffee() async {
    final path = await fileManager.getFavorite();
    return path.isNotEmpty
        ? SuccessResult(CoffeeResponse(file: path))
        : FailureResult(const FavoriteNotExistsFailure());
  }

  @override
  Future<Result<String, Failure>> storeFavoriteCoffee(String url) async {
    final path = await fileManager.saveFavorite(
      url: url,
      onProcessBodyBytes: () => api.getSpecificCoffee(basename(url)),
    );
    return path != null
        ? SuccessResult(path)
        : FailureResult(const UnableToStoreFavoriteFailure());
  }
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
