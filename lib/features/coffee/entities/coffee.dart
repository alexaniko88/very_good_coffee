part of coffee;

@freezed
class Coffee with _$Coffee {
  const factory Coffee({
    required String file,
    required bool isFavorite,
  }) = _Coffee;

  factory Coffee.fromJson(Map<String, dynamic> json) =>
      _$CoffeeFromJson(json);
}
