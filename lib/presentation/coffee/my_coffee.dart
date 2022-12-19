part of coffee;

const double _imageRadius = 150;
const double _messageMarginTop = 200;
const double _errorIconSize = 200;

enum ImageSource {
  network,
  file,
}

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
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: _CircleCoffee(
                          imageSource:
                              state.isFavorite
                                  ? ImageSource.file
                                  : ImageSource.network,
                          imagePath: state.imagePath,
                          filePath: state.filePath,
                        ),
                      ),
                      Visibility(
                        visible: state.isFavoriteVisible &&
                            state.imagePath.isNotEmpty,
                        child: Positioned(
                          right: 20,
                          top: 20,
                          child: CircleAvatar(
                            child: IconButton(
                              onPressed: () =>
                                  getIt<CoffeeCubit>().storeFavoriteCoffee(),
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
                      child: _CircleCoffee(
                        imageSource: ImageSource.file,
                        filePath: state.filePath,
                        imagePath: state.imagePath,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FloatingActionButton.large(
              onPressed: () => RestartWidget.restartApp(context),
              tooltip: 'Reload',
              child: const Icon(Icons.restart_alt),
            ),
            const SizedBox(height: 12),
            FloatingActionButton.large(
              onPressed: () => getIt<CoffeeCubit>().getRandomCoffee(),
              tooltip: 'Next',
              child: const Icon(Icons.skip_next_outlined),
            )
          ],
        ),
      ),
    );
  }
}

class _CircleCoffee extends StatelessWidget {
  const _CircleCoffee({
    Key? key,
    required this.imageSource,
    required this.imagePath,
    required this.filePath,
  }) : super(key: key);

  final ImageSource imageSource;
  final String imagePath;
  final String filePath;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox.fromSize(
        size: const Size.fromRadius(_imageRadius),
        child: _buildBySource(),
      ),
    );
  }

  Widget _buildBySource() {
    switch (imageSource) {
      case ImageSource.network:
        return imagePath.isNotEmpty
            ? Image.network(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildErrorIcon(),
              )
            : _buildErrorIcon();
      case ImageSource.file:
        return filePath.isNotEmpty
            ? Image.file(
                File(filePath),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildErrorIcon(),
              )
            : _buildErrorIcon();
    }
  }

  Icon _buildErrorIcon() {
    return const Icon(
      Icons.image,
      size: _errorIconSize,
    );
  }
}
