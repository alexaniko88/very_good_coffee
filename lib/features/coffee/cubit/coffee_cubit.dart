part of coffee;

@LazySingleton()
class CoffeeCubit extends Cubit<CoffeeState> {
  CoffeeCubit({
    required this.repository,
  }) : super(const CoffeeInitialState());

  final CoffeeRepository repository;

  Future<void> getRandomCoffee({bool removeFavorite = false}) async {
    emit(HideFavoriteState(state));
    final result = await repository.getRandomCoffee();
    result.fold(
      onSuccess: (coffee) => emit(
        GetCoffeeSuccessState(
          imagePath: coffee.file,
          filePath: removeFavorite ? '' : state.filePath,
          isFavorite: coffee.isFavorite,
        ),
      ),
      onFailure: (failure) => emit(
        GetCoffeeErrorState(
          state,
          failure: failure,
        ),
      ),
    );
  }

  Future<void> getFavoriteCoffee() async {
    emit(HideFavoriteState(state));
    final result = await repository.getFavoriteCoffee();
    result.fold(
      onSuccess: (coffee) => emit(
        GetCoffeeSuccessState(
          imagePath: coffee.file,
          filePath: coffee.isFavorite ? coffee.file : '',
          isFavorite: coffee.isFavorite,
        ),
      ),
      onFailure: (failure) => emit(
        GetCoffeeErrorState(
          state,
          failure: failure,
        ),
      ),
    );
  }

  Future<void> storeFavoriteCoffee() async {
    final result = await repository.storeFavoriteCoffee(state.imagePath);
    result.fold(
      onSuccess: (path) => state.isFavorite
          ? getRandomCoffee(removeFavorite: true)
          : emit(
              StoreFavoriteSuccessState(
                state: state,
                imagePath: path,
                filePath: path,
              ),
            ),
      onFailure: (_) => emit(StoreFavoriteFailureState(state)),
    );
  }
}
