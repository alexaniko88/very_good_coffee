import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_coffee/data/models/result/result.dart';
import 'package:very_good_coffee/di/di.dart';
import 'package:very_good_coffee/features/coffee/coffee.dart';
import 'package:very_good_coffee/presentation/coffee.dart';

import '../widget_tests_helper.dart';

class MockCoffeeRepository extends Mock implements CoffeeRepository {}

void main() {
  late MockCoffeeRepository repository;
  late CoffeeCubit cubit;

  group('Support page tests', () {
    setUpAll(() {
      repository = MockCoffeeRepository();
    });

    tearDownAll(() {});

    setUp(() {
      cubit = CoffeeCubit(repository: repository);

      getIt.registerLazySingleton<CoffeeCubit>(
        () => cubit,
        dispose: (coffeeCubit) => coffeeCubit.close(),
      );
    });

    tearDown(() => getIt.reset(dispose: true));

    testWidgets(
      'Having my coffee widget, When is directly called, Then builds an error',
      (WidgetTester tester) async {
        when(() => repository.getFavoriteCoffee()).thenAnswer(
          (invocation) => Future.value(
            FailureResult(const FavoriteNotExistsFailure()),
          ),
        );
        when(() => repository.getRandomCoffee()).thenAnswer(
          (invocation) => Future.value(
            FailureResult(const FavoriteNotExistsFailure()),
          ),
        );
        await WidgetTestsHelper.testWidget(
          tester,
          const MyCoffee(title: 'Title'),
          doAfter: () async {
            await tester.pumpAndSettle();
            await WidgetTestsHelper.expectGolden(
              'my_coffee_1',
            );

            await tester.tap(find.byType(FloatingActionButton).first);
            await tester.pumpAndSettle();
            await WidgetTestsHelper.expectGolden(
              'my_coffee_2',
            );
            await tester.tap(find.byType(FloatingActionButton).last);
            await tester.pumpAndSettle();
            await WidgetTestsHelper.expectGolden(
              'my_coffee_3',
            );

            await tester.tap(find.byType(Tab).last);
            await tester.pumpAndSettle();
            await WidgetTestsHelper.expectGolden(
              'my_coffee_4',
            );
          },
        );
      },
    );

    testWidgets(
      'Having my coffee widget, When is directly called, Then widget is built from network, not favorite, failing',
      (WidgetTester tester) async {
        when(() => repository.getFavoriteCoffee()).thenAnswer(
          (invocation) => Future.value(
            SuccessResult(const Coffee(file: '', isFavorite: false)),
          ),
        );
        when(() => repository.getRandomCoffee()).thenAnswer(
          (invocation) => Future.value(
            SuccessResult(const Coffee(file: '', isFavorite: false)),
          ),
        );
        await WidgetTestsHelper.testWidget(
          tester,
          const MyCoffee(title: 'Title'),
          doAfter: () async {
            await tester.pumpAndSettle();
            await WidgetTestsHelper.expectGolden(
              'my_coffee_5',
            );

            await tester.tap(find.byType(FloatingActionButton).first);
            await tester.pumpAndSettle();
            await WidgetTestsHelper.expectGolden(
              'my_coffee_6',
            );
            await tester.tap(find.byType(FloatingActionButton).last);
            await tester.pumpAndSettle();
            await WidgetTestsHelper.expectGolden(
              'my_coffee_7',
            );

            await tester.tap(find.byType(Tab).last);
            await tester.pumpAndSettle();
            await WidgetTestsHelper.expectGolden(
              'my_coffee_8',
            );
          },
        );
      },
    );

    testWidgets(
      'Having my coffee widget, When is directly called, Then widget is built from network, not favorite',
      (WidgetTester tester) async {
        when(() => repository.getFavoriteCoffee()).thenAnswer(
          (invocation) => Future.value(
            SuccessResult(
              const Coffee(
                file: 'https://example.com/some_image.jpg',
                isFavorite: false,
              ),
            ),
          ),
        );
        when(() => repository.getRandomCoffee()).thenAnswer(
          (invocation) => Future.value(
            SuccessResult(
              const Coffee(
                file: 'https://example.com/some_image.jpg',
                isFavorite: false,
              ),
            ),
          ),
        );
        when(() => repository.storeFavoriteCoffee(any())).thenAnswer(
          (invocation) => Future.value(
            SuccessResult('https://example.com/some_image.jpg'),
          ),
        );
        await WidgetTestsHelper.testWidget(
          tester,
          const MyCoffee(title: 'Title'),
          wrapWithMockNetworkImage: true,
          doAfter: () async {
            await tester.pumpAndSettle();
            await WidgetTestsHelper.expectGolden(
              'my_coffee_9',
            );
            await tester.tap(find.byIcon(Icons.favorite_outline));
            await tester.pumpAndSettle();
            await WidgetTestsHelper.expectGolden(
              'my_coffee_10',
            );

            await tester.tap(find.byType(FloatingActionButton).first);
            await tester.pumpAndSettle();
            await WidgetTestsHelper.expectGolden(
              'my_coffee_11',
            );
            await tester.tap(find.byType(FloatingActionButton).last);
            await tester.pumpAndSettle();
            await WidgetTestsHelper.expectGolden(
              'my_coffee_12',
            );

            await tester.tap(find.byType(Tab).last);
            await tester.pumpAndSettle();
            await WidgetTestsHelper.expectGolden(
              'my_coffee_13',
            );
          },
        );
      },
    );

    testWidgets(
      'Having my coffee widget, When is directly called, Then widget is built from network, is favorite',
      (WidgetTester tester) async {
        when(() => repository.getFavoriteCoffee()).thenAnswer(
          (invocation) => Future.value(
            SuccessResult(
              const Coffee(
                file: 'https://example.com/some_image.jpg',
                isFavorite: true,
              ),
            ),
          ),
        );
        when(() => repository.getRandomCoffee()).thenAnswer(
          (invocation) => Future.value(
            SuccessResult(
              const Coffee(
                file: 'https://example.com/some_image.jpg',
                isFavorite: false,
              ),
            ),
          ),
        );
        when(() => repository.storeFavoriteCoffee(any())).thenAnswer(
          (invocation) => Future.value(
            SuccessResult(''),
          ),
        );
        await WidgetTestsHelper.testWidget(
          tester,
          const MyCoffee(title: 'Title'),
          doAfter: () async {
            await tester.pumpAndSettle();
            await WidgetTestsHelper.expectGolden(
              'my_coffee_14',
            );
            await tester.tap(find.byIcon(Icons.favorite));
            await tester.pumpAndSettle();
            await WidgetTestsHelper.expectGolden(
              'my_coffee_15',
            );

            await tester.tap(find.byType(FloatingActionButton).first);
            await tester.pumpAndSettle();
            await WidgetTestsHelper.expectGolden(
              'my_coffee_16',
            );
            await tester.tap(find.byType(FloatingActionButton).last);
            await tester.pumpAndSettle();
            await WidgetTestsHelper.expectGolden(
              'my_coffee_17',
            );

            await tester.tap(find.byType(Tab).last);
            await tester.pumpAndSettle();
            await WidgetTestsHelper.expectGolden(
              'my_coffee_18',
            );
          },
        );
      },
    );
  });
}
