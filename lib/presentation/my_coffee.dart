part of coffee;

const double _imageRadius = 200;
const double _messageMarginTop = 200;
const double _errorIconSize = 300;

class MyCoffee extends StatefulWidget {
  const MyCoffee({super.key, required this.title});

  final String title;

  @override
  State<MyCoffee> createState() => _MyCoffeeState();
}

class _MyCoffeeState extends State<MyCoffee> {
  @override
  void initState() {
    getIt<CoffeeCubit>().getFavoriteCoffee();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          bottom: const TabBar(
            tabs: [
              Tab(child: Text('Random coffee')),
              Tab(child: Text('Favorite')),
            ],
          ),
        ),
        body: BlocBuilder<CoffeeCubit, CoffeeState>(
          bloc: getIt(),
          builder: (context, state) {
            return TabBarView(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: ClipOval(
                              child: SizedBox.fromSize(
                                size: const Size.fromRadius(_imageRadius),
                                child: !state.isFavorite &&
                                        state.imagePath.isNotEmpty
                                    ? Image.network(
                                        state.imagePath,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            const Icon(
                                          Icons.image,
                                          size: _errorIconSize,
                                        ),
                                      )
                                    : Image.file(
                                        File(state.filePath),
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            const Icon(
                                          Icons.image,
                                          size: _errorIconSize,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: state.isFavoriteVisible,
                            child: Positioned(
                              right: 20,
                              top: 20,
                              child: CircleAvatar(
                                child: IconButton(
                                  onPressed: () => getIt<CoffeeCubit>()
                                      .storeFavoriteCoffee(),
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
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          FloatingActionButton.large(
                            onPressed: () => RestartWidget.restartApp(context),
                            tooltip: 'Reload',
                            child: const Icon(Icons.restart_alt),
                          ),
                          FloatingActionButton.large(
                            onPressed: () =>
                                getIt<CoffeeCubit>().getRandomCoffee(),
                            tooltip: 'Next',
                            child: const Icon(Icons.skip_next_outlined),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: state.filePath.isNotEmpty,
                  replacement: const Padding(
                    padding: EdgeInsets.only(top: _messageMarginTop),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Text('No favorite coffee yet'),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: ClipOval(
                        child: SizedBox.fromSize(
                          size: const Size.fromRadius(_imageRadius),
                          child: Image.file(
                            File(state.filePath),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, trace) => const Icon(
                              Icons.image,
                              size: _errorIconSize,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
