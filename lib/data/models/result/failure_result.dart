part of result;

class FailureResult<S, F extends Failure> extends Result<S, F> {
  FailureResult(this._value);

  final F _value;

  @override
  R fold<R>({
    required R Function(S) onSuccess,
    required R Function(F) onFailure,
  }) =>
      onFailure(_value);

  @override
  bool operator ==(dynamic other) =>
      other is FailureResult && other._value == _value;

  @override
  int get hashCode => _value.hashCode;
}
