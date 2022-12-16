part of coffee;

@immutable
abstract class CoffeeState extends Equatable {
  const CoffeeState({
    this.imagePath = '',
    this.filePath = '',
    this.isFavorite = false,
    this.isFavoriteVisible = false,
  });

  final String imagePath;
  final String filePath;
  final bool isFavorite;
  final bool isFavoriteVisible;

  @override
  List<Object?> get props => [
        imagePath,
        filePath,
        isFavorite,
        isFavoriteVisible,
      ];
}

class CoffeeInitialState extends CoffeeState {
  const CoffeeInitialState() : super();
}

class GetCoffeeSuccessState extends CoffeeState {
  const GetCoffeeSuccessState({
    required super.imagePath,
    required super.filePath,
    required super.isFavorite,
    super.isFavoriteVisible = true,
  });
}

class HideFavoriteState extends CoffeeState {
  HideFavoriteState(CoffeeState state)
      : super(
          imagePath: state.imagePath,
          filePath: state.filePath,
          isFavorite: state.isFavorite,
          isFavoriteVisible: false,
        );
}

class StoreFavoriteSuccessState extends CoffeeState {
  StoreFavoriteSuccessState({
    required CoffeeState state,
    required String imagePath,
    required String filePath,
  }) : super(
          imagePath: imagePath,
          filePath: filePath,
          isFavorite: !state.isFavorite,
          isFavoriteVisible: true,
        );
}

class StoreFavoriteFailureState extends CoffeeState {
  StoreFavoriteFailureState(CoffeeState state)
      : super(
          imagePath: state.imagePath,
          filePath: state.filePath,
          isFavorite: state.isFavorite,
          isFavoriteVisible: true,
        );
}

class GetCoffeeErrorState extends CoffeeState {
  GetCoffeeErrorState(
    CoffeeState state, {
    required this.failure,
  }) : super(
          imagePath: '',
          filePath: state.filePath,
          isFavorite: state.isFavorite,
          isFavoriteVisible: state.isFavoriteVisible,
        );

  final Failure failure;

  @override
  List<Object?> get props => [
        failure,
      ];
}
