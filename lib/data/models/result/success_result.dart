part of models;

class SuccessResult<S, F extends Failure> extends Result<S, F> {
  SuccessResult(this._value);

  final S _value;

  @override
  R fold<R>({
    required R Function(S) onSuccess,
    required R Function(F) onFailure,
  }) =>
      onSuccess(_value);
}
