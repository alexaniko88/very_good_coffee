// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:http/http.dart' as _i3;
import 'package:injectable/injectable.dart' as _i2;
import 'package:very_good_coffee/data/mappers/coffee/coffee_mappers.dart'
    as _i7;
import 'package:very_good_coffee/data/network/api/coffee.dart' as _i4;
import 'package:very_good_coffee/data/repositories/repositories.dart' as _i6;
import 'package:very_good_coffee/features/coffee/coffee.dart' as _i5;

import '../data/network/api/base.dart' as _i8;

/// ignore_for_file: unnecessary_lambdas
/// ignore_for_file: lines_longer_than_80_chars
extension GetItInjectableX on _i1.GetIt {
  /// initializes the registration of main-scope dependencies inside of [GetIt]
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final httpClientModule = _$HttpClientModule();
    gh.lazySingleton<_i3.Client>(() => httpClientModule.httpClient);
    gh.factory<_i4.CoffeeApi>(
      () => _i4.CoffeeApi(client: gh<_i3.Client>()),
      instanceName: 'CoffeeApi',
    );
    gh.lazySingleton<_i5.CoffeeLocalDataSource>(
        () => _i6.RealCoffeeLocalDataSource());
    gh.lazySingleton<_i7.CoffeeMapper>(() => _i7.RealCoffeeMapper());
    gh.lazySingleton<_i5.CoffeeRemoteDataSource>(() =>
        _i6.RealCoffeeRemoteDataSource(
            api: gh<_i4.CoffeeApi>(instanceName: 'CoffeeApi')));
    gh.lazySingleton<_i5.CoffeeRepository>(() => _i6.RealCoffeeRepository(
          localDataSource: gh<_i5.CoffeeLocalDataSource>(),
          remoteDataSource: gh<_i5.CoffeeRemoteDataSource>(),
          coffeeMapper: gh<_i7.CoffeeMapper>(),
        ));
    gh.lazySingleton<_i7.RandomCoffeeMapper>(() => _i7.RandomCoffeeMapper());
    gh.lazySingleton<_i5.CoffeeCubit>(
        () => _i5.CoffeeCubit(repository: gh<_i5.CoffeeRepository>()));
    return this;
  }
}

class _$HttpClientModule extends _i8.HttpClientModule {}
