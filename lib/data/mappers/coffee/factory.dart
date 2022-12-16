part of coffee_mappers;

abstract class CoffeeMapper {
  Mapper<CoffeeResponse, Coffee> get coffee;

  Mapper<CoffeeResponse, Coffee> get favoriteCoffee;
}

@LazySingleton(as: CoffeeMapper)
class RealCoffeeMapper implements CoffeeMapper {
  @override
  Mapper<CoffeeResponse, Coffee> get coffee => getIt<RandomCoffeeMapper>();

  @override
  Mapper<CoffeeResponse, Coffee> get favoriteCoffee =>
      getIt<FavoriteCoffeeMapper>();
}
