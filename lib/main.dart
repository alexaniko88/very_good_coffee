import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_coffee/di/di.dart';
import 'package:very_good_coffee/features/coffee/coffee.dart';
import 'package:very_good_coffee/observers/simple_bloc_observer.dart';
import 'package:very_good_coffee/presentation/coffee.dart';
import 'package:very_good_coffee/presentation/common/restart_widget.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();
  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RestartWidget(
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => CoffeeCubit(
              repository: getIt<CoffeeRepository>(),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Very Good Coffee',
          theme: ThemeData(primarySwatch: Colors.blue),
          home: const MyCoffee(title: 'Very Good Coffee'),
        ),
      ),
    );
  }
}


