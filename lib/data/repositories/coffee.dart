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

  @override
  Future<Result<Coffee, Failure>> getFavoriteCoffee() async {
    try {
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
    } catch (e) {
      return FailureResult(UnexpectedFailure(e));
    }
  }

  @override
  Future<Result<String, Failure>> storeFavoriteCoffee(String url) =>
      localDataSource.storeFavoriteCoffee(url);
}

@LazySingleton(as: CoffeeLocalDataSource)
class RealCoffeeLocalDataSource implements CoffeeLocalDataSource {
  final String _favoriteDir = 'favorite';

  const RealCoffeeLocalDataSource({
    @Named('CoffeeApi') required CoffeeApi api,
  }) : _api = api;

  final CoffeeApi _api;

  @override
  Future<Result<CoffeeResponse, Failure>> getFavoriteCoffee() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final favoritesDir =
          await Directory("${appDir.path}/$_favoriteDir").create();
      final favorite = await favoritesDir.list().first;
      return (await favorite.exists())
          ? SuccessResult(CoffeeResponse(file: favorite.path))
          : FailureResult(const FavoriteNotExistsFailure());
    } catch (e) {
      return FailureResult(UnexpectedFailure(e));
    }
  }

  @override
  Future<Result<String, Failure>> storeFavoriteCoffee(String url) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final favoritesDir =
          await Directory("${appDir.path}/$_favoriteDir").create();
      final file = File(join(favoritesDir.path, basename(url)));
      if (await favoritesDir.list().isEmpty) {
        await _storeFile(file: file, url: url);
        return SuccessResult(file.path);
      } else {
        if (await file.exists()) {
          await file.delete();
          return SuccessResult('');
        } else {
          await favoritesDir.listSync().first.delete();
          await _storeFile(file: file, url: url);
          return SuccessResult(file.path);
        }
      }
    } catch (e) {
      return FailureResult(UnexpectedFailure(e));
    }
  }

  Future<void> _storeFile({
    required File file,
    required String url,
  }) async {
    final coffeeResponse = await _api.getSpecificCoffee(basename(url));
    await file.writeAsBytes(coffeeResponse.bodyBytes);
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
