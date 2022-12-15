import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_coffee/di/di.dart';
import 'package:very_good_coffee/features/coffee/coffee.dart';
import 'package:very_good_coffee/observers/simple_bloc_observer.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();
  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
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
        home: const MyHomePage(title: 'Very Good Coffee'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    getIt<CoffeeCubit>().getCoffee();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: BlocBuilder<CoffeeCubit, CoffeeState>(
            bloc: getIt(),
            builder: (context, state) {
              return Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: CachedNetworkImage(
                      imageUrl: state.imagePath,
                      imageBuilder: (context, imageProvider) {
                        //getIt<CoffeeCubit>().showFavoriteIndicator();
                        return Container(
                          width: 350.0,
                          height: 350.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                      errorWidget: (context, url, error) => const Icon(
                        Icons.image,
                        size: 350,
                      ),
                      useOldImageOnUrlChange: true,
                    ),
                  ),
                  Visibility(
                    visible: state.isFavoriteVisible,
                    child: Positioned(
                      right: 50,
                      top: 30,
                      child: CircleAvatar(
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            state.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_outline,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () => getIt<CoffeeCubit>().getCoffee(),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
