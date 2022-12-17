part of coffee_mappers;

@LazySingleton()
class RandomCoffeeMapper implements Mapper<CoffeeResponse, Coffee> {
  @override
  Coffee fromEntity(CoffeeResponse entity) => Coffee(
        file: entity.file ?? '',
        isFavorite: false,
      );
}
