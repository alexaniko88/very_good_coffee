part of models;

@freezed
class CoffeeResponse with _$CoffeeResponse {
  const factory CoffeeResponse({
    String? file,
  }) = _CoffeeResponse;

  factory CoffeeResponse.fromJson(Map<String, dynamic> json) =>
      _$CoffeeResponseFromJson(json);
}