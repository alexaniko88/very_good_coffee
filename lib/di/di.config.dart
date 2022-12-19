// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:http/http.dart' as _i3;
import 'package:injectable/injectable.dart' as _i2;
import 'package:very_good_coffee/data/managers/managers.dart' as _i8;
import 'package:very_good_coffee/data/mappers/mappers.dart' as _i5;
import 'package:very_good_coffee/data/network/network.dart' as _i4;
import 'package:very_good_coffee/data/repositories/repositories.dart' as _i7;
import 'package:very_good_coffee/features/coffee/coffee.dart' as _i6;

import '../data/modules/modules.dart' as _i9;

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
    final fileSourceModule = _$FileSourceModule();
    gh.lazySingleton<_i3.Client>(() => httpClientModule.httpClient);
    gh.factory<_i4.CoffeeApi>(
      () => _i4.CoffeeApi(client: gh<_i3.Client>()),
      instanceName: 'CoffeeApi',
    );
    gh.lazySingleton<_i5.CoffeeMapper>(() => _i5.RealCoffeeMapper());
    gh.lazySingleton<_i6.CoffeeRemoteDataSource>(() =>
        _i7.RealCoffeeRemoteDataSource(
            api: gh<_i4.CoffeeApi>(instanceName: 'CoffeeApi')));
    gh.lazySingleton<_i5.FavoriteCoffeeMapper>(
        () => _i5.FavoriteCoffeeMapper());
    gh.lazySingleton<_i8.FileSource>(() => fileSourceModule.fileSource);
    gh.lazySingleton<_i5.RandomCoffeeMapper>(() => _i5.RandomCoffeeMapper());
    gh.factory<_i8.FileManager>(
      () => _i8.FileManager(fileSource: gh<_i8.FileSource>()),
      instanceName: 'FileManager',
    );
    gh.lazySingleton<_i6.CoffeeLocalDataSource>(
        () => _i7.RealCoffeeLocalDataSource(
              api: gh<_i4.CoffeeApi>(instanceName: 'CoffeeApi'),
              fileManager: gh<_i8.FileManager>(instanceName: 'FileManager'),
            ));
    gh.lazySingleton<_i6.CoffeeRepository>(() => _i7.RealCoffeeRepository(
          localDataSource: gh<_i6.CoffeeLocalDataSource>(),
          remoteDataSource: gh<_i6.CoffeeRemoteDataSource>(),
          coffeeMapper: gh<_i5.CoffeeMapper>(),
        ));
    gh.lazySingleton<_i6.CoffeeCubit>(
        () => _i6.CoffeeCubit(repository: gh<_i6.CoffeeRepository>()));
    return this;
  }
}

class _$FileSourceModule extends _i9.FileSourceModule {}

class _$HttpClientModule extends _i9.HttpClientModule {}
