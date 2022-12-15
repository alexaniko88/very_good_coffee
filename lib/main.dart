import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Very Good Coffee',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(title: 'Very Good Coffee'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: SizedBox.square(
                dimension: 350,
                child: Image.network(
                  "https://coffee.alexflipnote.dev/random",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              right: 50,
              top: 15,
              child: CircleAvatar(
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.favorite_outline),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () {},
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
