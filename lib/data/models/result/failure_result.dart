part of models;

class FailureResult<S, F extends Failure> extends Result<S, F> {
  FailureResult(this._value);

  final F _value;

  @override
  R fold<R>({
    required R Function(S) onSuccess,
    required R Function(F) onFailure,
  }) =>
      onFailure(_value);
}
