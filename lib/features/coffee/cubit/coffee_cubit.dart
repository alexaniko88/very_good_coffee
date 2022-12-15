part of coffee;

@LazySingleton()
class CoffeeCubit extends Cubit<CoffeeState> {
  CoffeeCubit({
    required this.repository,
  }) : super(const CoffeeInitialState());

  final CoffeeRepository repository;

  Future<void> getCoffee() async {
    _hideFavoriteIndicator();
    final result = await repository.getRandomCoffee();
    result.fold(
      onSuccess: (coffee) => emit(
        GetCoffeeSuccessState(
          imagePath: coffee.file,
          isFavorite: coffee.isFavorite,
        ),
      ),
      onFailure: (failure) => emit(GetCoffeeErrorState(failure: failure)),
    );
  }

  void _hideFavoriteIndicator() => emit(HideFavoriteState(state));
}
