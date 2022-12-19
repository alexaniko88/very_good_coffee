import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_coffee/data/managers/managers.dart';
import 'package:very_good_coffee/data/mappers/mappers.dart';
import 'package:very_good_coffee/data/network/network.dart';
import 'package:very_good_coffee/data/repositories/repositories.dart';
import 'package:very_good_coffee/di/di.dart';
import 'package:very_good_coffee/features/coffee/coffee.dart';

class MockClient extends Mock implements Client {}

class MockFileSource extends Mock implements FileSource {}

class FakeUri extends Fake implements Uri {}

class FakeDirectory extends Fake implements Directory {}

class FakeFile extends Fake implements File {}

class FakeResponse extends Fake implements Response {}

void main() {
  late CoffeeRepository repository;
  late MockClient client;
  late MockFileSource fileSource;

  group('Counter Cubit test ', () {
    setUpAll(() {
      TestWidgetsFlutterBinding.ensureInitialized();

      registerFallbackValue(FakeUri());
      registerFallbackValue(FakeDirectory());
      registerFallbackValue(FakeFile());
      registerFallbackValue(FakeResponse());

      getIt.registerLazySingleton<RandomCoffeeMapper>(
          () => RandomCoffeeMapper());
      getIt.registerLazySingleton<FavoriteCoffeeMapper>(
          () => FavoriteCoffeeMapper());
    });

    setUp(() {
      fileSource = MockFileSource();
      client = MockClient();
      final api = CoffeeApi(client: client);
      repository = RealCoffeeRepository(
        localDataSource: RealCoffeeLocalDataSource(
          api: api,
          fileManager: FileManager(
            fileSource: fileSource,
          ),
        ),
        remoteDataSource: RealCoffeeRemoteDataSource(api: api),
        coffeeMapper: RealCoffeeMapper(),
      );
      when(() => fileSource.getFavoriteDirectory()).thenAnswer(
        (invocation) => Future.value(Directory('path')),
      );
    });

    tearDownAll(() => getIt.reset());

    blocTest<CoffeeCubit, CoffeeState>(
      'emits [HideFavoriteState, GetCoffeeErrorState] when getRandomCoffee is called, failing from network with status code 400',
      build: () => CoffeeCubit(repository: repository),
      act: (bloc) {
        when(
          () => client.get(
            any(),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer(
          (invocation) => Future.value(
            Response(
              '''{"error": "Unexpected error"}''',
              400,
            ),
          ),
        );
        return bloc.getRandomCoffee();
      },
      expect: () => [
        isA<HideFavoriteState>(),
        isA<GetCoffeeErrorState>().having(
          (source) => source.failure.error,
          'unexpected error',
          'Unexpected error',
        ),
      ],
    );

    blocTest<CoffeeCubit, CoffeeState>(
      'emits [HideFavoriteState, GetCoffeeErrorState] when getRandomCoffee is called, failing as Platform exception',
      build: () => CoffeeCubit(repository: repository),
      act: (bloc) {
        when(
              () => client.get(
            any(),
            headers: any(named: 'headers'),
          ),
        ).thenThrow(PlatformException(code: '400'));
        return bloc.getRandomCoffee();
      },
      expect: () => [
        isA<HideFavoriteState>(),
        isA<GetCoffeeErrorState>().having(
              (source) => source.failure.error is PlatformException,
          'unexpected PlatformException',
          true,
        ),
      ],
    );


    blocTest<CoffeeCubit, CoffeeState>(
      'emits [HideFavoriteState, GetCoffeeSuccessState] when getRandomCoffee is called, ok from network',
      build: () => CoffeeCubit(repository: repository),
      act: (bloc) {
        when(
          () => client.get(
            any(),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer(
          (invocation) => Future.value(
            Response(
              '''{"file": "https://coffee.alexflipnote.dev/Rxw-9EXU_XU_coffee.jpg"}''',
              200,
            ),
          ),
        );
        return bloc.getRandomCoffee();
      },
      expect: () => [
        isA<HideFavoriteState>(),
        isA<GetCoffeeSuccessState>()
            .having(
              (source) => source.isFavorite,
              'not favorite',
              false,
            )
            .having(
              (source) => source.isFavoriteVisible,
              'is visible',
              true,
            )
            .having(
              (source) => source.imagePath.isNotEmpty,
              'image path is not empty',
              true,
            )
            .having(
              (source) => source.filePath.isEmpty,
              'file path is empty',
              true,
            ),
      ],
    );

    blocTest<CoffeeCubit, CoffeeState>(
      'emits [StoreFavoriteFailureState] when storeFavoriteCoffee is called, failing fon storing',
      build: () => CoffeeCubit(repository: repository),
      seed: () => const GetCoffeeSuccessState(
        imagePath: 'https://coffee.alexflipnote.dev/Rxw-9EXU_XU_coffee.jpg',
        filePath: '',
        isFavorite: false,
        isFavoriteVisible: true,
      ),
      act: (bloc) {
        when(() => fileSource.getFavoriteDirectory()).thenThrow(
          PlatformException(code: ''),
        );
        return bloc.storeFavoriteCoffee();
      },
      expect: () => [
        isA<StoreFavoriteFailureState>(),
      ],
    );

    blocTest<CoffeeCubit, CoffeeState>(
      'emits [StoreFavoriteSuccessState] when storeFavoriteCoffee is called, saving NOT favorite',
      build: () => CoffeeCubit(repository: repository),
      seed: () => const GetCoffeeSuccessState(
        imagePath: 'https://coffee.alexflipnote.dev/Rxw-9EXU_XU_coffee.jpg',
        filePath: '',
        isFavorite: false,
        isFavoriteVisible: true,
      ),
      act: (bloc) {
        when(
          () => fileSource.getFile(
            url: any(named: 'url'),
            dirPath: any(named: 'dirPath'),
          ),
        ).thenReturn(File('path'));

        when(
          () => fileSource.isEmpty(any()),
        ).thenAnswer((invocation) => Future.value(true));

        when(
          () => client.get(
            any(),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer(
          (invocation) => Future.value(
            Response(
              '''{"file": "https://coffee.alexflipnote.dev/Rxw-9EXU_XU_coffee.jpg"}''',
              200,
            ),
          ),
        );

        when(
          () => fileSource.writeToFile(
            file: any(named: 'file'),
            response: any(named: 'response'),
          ),
        ).thenAnswer((invocation) => Future.value());

        return bloc.storeFavoriteCoffee();
      },
      expect: () => [
        isA<StoreFavoriteSuccessState>()
            .having(
              (source) => source.isFavorite,
              'is favorite',
              true,
            )
            .having(
              (source) => source.isFavoriteVisible,
              'is visible',
              true,
            )
            .having(
              (source) => source.imagePath.isNotEmpty,
              'image path is not empty',
              true,
            )
            .having(
              (source) => source.filePath.isNotEmpty,
              'file path is not empty',
              true,
            ),
      ],
      verify: (_) {
        verify(() => client.get(
              any(),
              headers: any(named: 'headers'),
            )).called(1);
      },
    );

    blocTest<CoffeeCubit, CoffeeState>(
      'emits [HideFavoriteState, GetCoffeeSuccessState] when storeFavoriteCoffee is called, UN saving favorite',
      build: () => CoffeeCubit(repository: repository),
      seed: () => const GetCoffeeSuccessState(
        imagePath: 'https://coffee.alexflipnote.dev/Rxw-9EXU_XU_coffee.jpg',
        filePath: '',
        isFavorite: true,
        isFavoriteVisible: true,
      ),
      act: (bloc) {
        when(
          () => fileSource.getFile(
            url: any(named: 'url'),
            dirPath: any(named: 'dirPath'),
          ),
        ).thenReturn(File('path'));

        when(
          () => fileSource.isEmpty(any()),
        ).thenAnswer((invocation) => Future.value(false));

        when(
          () => fileSource.removeFile(
            dir: any(named: 'dir'),
            fileToRemovePath: any(named: 'fileToRemovePath'),
          ),
        ).thenAnswer((invocation) => Future.value(true));

        when(
          () => fileSource.writeToFile(
            file: any(named: 'file'),
            response: any(named: 'response'),
          ),
        ).thenAnswer((invocation) => Future.value());

        when(
          () => client.get(
            any(),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer(
          (invocation) => Future.value(
            Response(
              '''{"file": "https://coffee.alexflipnote.dev/Rxw-9EXU_XU_coffee.jpg"}''',
              200,
            ),
          ),
        );

        return bloc.storeFavoriteCoffee();
      },
      expect: () => [
        isA<HideFavoriteState>(),
        isA<GetCoffeeSuccessState>()
            .having(
              (source) => source.isFavorite,
              'is favorite',
              false,
            )
            .having(
              (source) => source.isFavoriteVisible,
              'is visible',
              true,
            )
            .having(
              (source) => source.imagePath.isNotEmpty,
              'image path is not empty',
              true,
            )
            .having(
              (source) => source.filePath.isEmpty,
              'file path is empty',
              true,
            ),
      ],
      verify: (_) {
        verify(() => client.get(
              any(),
              headers: any(named: 'headers'),
            )).called(1);
      },
    );

    blocTest<CoffeeCubit, CoffeeState>(
      'emits [StoreFavoriteSuccessState] when storeFavoriteCoffee is called, saving new favorite',
      build: () => CoffeeCubit(repository: repository),
      seed: () => const GetCoffeeSuccessState(
        imagePath: 'https://coffee.alexflipnote.dev/Rxw-9EXU_XU_coffee.jpg',
        filePath: '',
        isFavorite: false,
        isFavoriteVisible: true,
      ),
      act: (bloc) {
        when(
          () => fileSource.getFile(
            url: any(named: 'url'),
            dirPath: any(named: 'dirPath'),
          ),
        ).thenReturn(File('path'));

        when(
          () => fileSource.isEmpty(any()),
        ).thenAnswer((invocation) => Future.value(false));

        when(
          () => fileSource.removeFile(
            dir: any(named: 'dir'),
            fileToRemovePath: any(named: 'fileToRemovePath'),
          ),
        ).thenAnswer((invocation) => Future.value(false));

        when(
          () => fileSource.writeToFile(
            file: any(named: 'file'),
            response: any(named: 'response'),
          ),
        ).thenAnswer((invocation) => Future.value());

        when(
          () => client.get(
            any(),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer(
          (invocation) => Future.value(
            Response(
              '''{"file": "https://coffee.alexflipnote.dev/Rxw-9EXU_XU_coffee.jpg"}''',
              200,
            ),
          ),
        );

        return bloc.storeFavoriteCoffee();
      },
      expect: () => [
        isA<StoreFavoriteSuccessState>()
            .having(
              (source) => source.isFavorite,
              'is favorite',
              true,
            )
            .having(
              (source) => source.isFavoriteVisible,
              'is visible',
              true,
            )
            .having(
              (source) => source.imagePath.isNotEmpty,
              'image path is not empty',
              true,
            )
            .having(
              (source) => source.filePath.isNotEmpty,
              'file path is not empty',
              true,
            ),
      ],
      verify: (_) {
        verify(() => client.get(
              any(),
              headers: any(named: 'headers'),
            )).called(1);
      },
    );

    blocTest<CoffeeCubit, CoffeeState>(
      'emits [HideFavoriteState, GetCoffeeErrorState] when getFavoriteCoffee is called, failing from network with status code 400, without favorite',
      build: () => CoffeeCubit(repository: repository),
      seed: () => const GetCoffeeSuccessState(
        imagePath: 'https://coffee.alexflipnote.dev/Rxw-9EXU_XU_coffee.jpg',
        filePath: '',
        isFavorite: false,
        isFavoriteVisible: true,
      ),
      act: (bloc) {
        when(
          () => client.get(
            any(),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer(
          (invocation) => Future.value(
            Response(
              '''{"error": "Unexpected error"}''',
              400,
            ),
          ),
        );

        when(
          () => fileSource.getFavoritePath(),
        ).thenThrow(PlatformException(code: '400'));

        return bloc.getFavoriteCoffee();
      },
      expect: () => [
        isA<HideFavoriteState>(),
        isA<GetCoffeeErrorState>().having(
          (source) => source.failure.error,
          'unexpected error',
          'Unexpected error',
        ),
      ],
      verify: (_) {
        verify(() => client.get(
              any(),
              headers: any(named: 'headers'),
            )).called(1);
        verify(() => fileSource.getFavoritePath()).called(1);
      },
    );

    blocTest<CoffeeCubit, CoffeeState>(
      'emits [HideFavoriteState, GetCoffeeSuccessState] when getFavoriteCoffee is called, taking from favorite',
      build: () => CoffeeCubit(repository: repository),
      seed: () => const GetCoffeeSuccessState(
        imagePath: 'https://coffee.alexflipnote.dev/Rxw-9EXU_XU_coffee.jpg',
        filePath: '',
        isFavorite: false,
        isFavoriteVisible: true,
      ),
      act: (bloc) {
        when(
          () => fileSource.getFavoritePath(),
        ).thenAnswer((invocation) => Future.value('path'));

        return bloc.getFavoriteCoffee();
      },
      expect: () => [
        isA<HideFavoriteState>(),
        isA<GetCoffeeSuccessState>()
            .having(
              (source) => source.isFavorite,
              'is favorite',
              true,
            )
            .having(
              (source) => source.isFavoriteVisible,
              'is visible',
              true,
            )
            .having(
              (source) => source.imagePath.isNotEmpty,
              'image path is not empty',
              true,
            )
            .having(
              (source) => source.filePath.isNotEmpty,
              'file path is not empty',
              true,
            ),
      ],
      verify: (_) {
        verifyNever(() => client.get(
              any(),
              headers: any(named: 'headers'),
            ));
        verify(() => fileSource.getFavoritePath()).called(1);
      },
    );

    blocTest<CoffeeCubit, CoffeeState>(
      'emits [HideFavoriteState, GetCoffeeErrorState] when getFavoriteCoffee is called, no favorite, taking from network and failing with 400',
      build: () => CoffeeCubit(repository: repository),
      seed: () => const GetCoffeeSuccessState(
        imagePath: 'https://coffee.alexflipnote.dev/Rxw-9EXU_XU_coffee.jpg',
        filePath: '',
        isFavorite: false,
        isFavoriteVisible: true,
      ),
      act: (bloc) {
        when(
          () => client.get(
            any(),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer(
          (invocation) => Future.value(
            Response(
              '''{"error": "Unexpected error"}''',
              400,
            ),
          ),
        );

        when(
          () => fileSource.getFavoritePath(),
        ).thenAnswer((invocation) => Future.value(''));

        return bloc.getFavoriteCoffee();
      },
      expect: () => [
        isA<HideFavoriteState>(),
        isA<GetCoffeeErrorState>().having(
          (source) => source.failure.error,
          'unexpected error',
          'Unexpected error',
        ),
      ],
      verify: (_) {
        verify(() => client.get(
              any(),
              headers: any(named: 'headers'),
            )).called(1);
        verify(() => fileSource.getFavoritePath()).called(1);
      },
    );

    blocTest<CoffeeCubit, CoffeeState>(
      'emits [HideFavoriteState, GetCoffeeErrorState] when getFavoriteCoffee is called, no favorite, taking from network correctly',
      build: () => CoffeeCubit(repository: repository),
      seed: () => const GetCoffeeSuccessState(
        imagePath: 'https://coffee.alexflipnote.dev/Rxw-9EXU_XU_coffee.jpg',
        filePath: '',
        isFavorite: false,
        isFavoriteVisible: true,
      ),
      act: (bloc) {
        when(
          () => client.get(
            any(),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer(
          (invocation) => Future.value(
            Response(
              '''{"file": "https://coffee.alexflipnote.dev/Rxw-9EXU_XU_coffee.jpg"}''',
              200,
            ),
          ),
        );
        when(
          () => fileSource.getFavoritePath(),
        ).thenAnswer((invocation) => Future.value(''));

        return bloc.getFavoriteCoffee();
      },
      expect: () => [
        isA<HideFavoriteState>(),
        isA<GetCoffeeSuccessState>()
            .having(
              (source) => source.isFavorite,
              'is favorite',
              false,
            )
            .having(
              (source) => source.isFavoriteVisible,
              'is visible',
              true,
            )
            .having(
              (source) => source.imagePath.isNotEmpty,
              'image path is not empty',
              true,
            )
            .having(
              (source) => source.filePath.isEmpty,
              'file path is empty',
              true,
            ),
      ],
      verify: (_) {
        verify(() => client.get(
              any(),
              headers: any(named: 'headers'),
            )).called(1);
        verify(() => fileSource.getFavoritePath()).called(1);
      },
    );
  });
}
