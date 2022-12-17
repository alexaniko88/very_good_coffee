part of result;

abstract class Failure<T> extends Equatable {
  const Failure(this.error);

  final T error;

  @override
  List<Object?> get props => [error];
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure(error) : super(error);
}

class FavoriteNotExistsFailure extends Failure {
  const FavoriteNotExistsFailure() : super('');
}

class UnableToStoreFavoriteFailure extends Failure {
  const UnableToStoreFavoriteFailure() : super('');
}
