part of coffee_mappers;

abstract class CoffeeMapper {
  Mapper<CoffeeResponse, Coffee> get coffee;
}

@LazySingleton(as: CoffeeMapper)
class RealCoffeeMapper implements CoffeeMapper {
  @override
  Mapper<CoffeeResponse, Coffee> get coffee => getIt<RandomCoffeeMapper>();
}
