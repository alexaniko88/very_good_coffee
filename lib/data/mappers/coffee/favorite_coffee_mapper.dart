part of coffee_mappers;

@LazySingleton()
class FavoriteCoffeeMapper implements Mapper<CoffeeResponse, Coffee> {
  @override
  Coffee fromEntity(CoffeeResponse entity) => Coffee(
        file: entity.file ?? '',
        isFavorite: true,
      );
}
