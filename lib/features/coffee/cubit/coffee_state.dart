part of coffee;

@immutable
abstract class CoffeeState extends Equatable {
  const CoffeeState({
    this.imagePath = '',
    this.isFavorite = false,
    this.isFavoriteVisible = false,
  });

  final String imagePath;
  final bool isFavorite;
  final bool isFavoriteVisible;

  @override
  List<Object?> get props => [imagePath, isFavorite, isFavoriteVisible];
}

class CoffeeInitialState extends CoffeeState {
  const CoffeeInitialState() : super();
}

class GetCoffeeSuccessState extends CoffeeState {
  const GetCoffeeSuccessState({
    required super.imagePath,
    required super.isFavorite,
    super.isFavoriteVisible = true,
  });
}

class HideFavoriteState extends CoffeeState {
  HideFavoriteState(CoffeeState state)
      : super(
          imagePath: state.imagePath,
          isFavorite: state.isFavorite,
          isFavoriteVisible: false,
        );
}

class GetCoffeeErrorState extends CoffeeState {
  const GetCoffeeErrorState({
    required this.failure,
  }) : super();

  final Failure failure;

  @override
  List<Object?> get props => [
        failure,
      ];
}
