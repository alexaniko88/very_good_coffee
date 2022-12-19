import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_coffee/di/di.dart';
import 'package:very_good_coffee/observers/simple_bloc_observer.dart';
import 'package:very_good_coffee/presentation/coffee.dart';
import 'package:very_good_coffee/presentation/common/restart_widget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RestartWidget(
      child: MaterialApp(
        title: 'Very Good Coffee',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const MyCoffee(title: 'My Very Good Coffee'),
      ),
    );
  }
}
