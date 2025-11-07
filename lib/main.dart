import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

// Main App
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sandwich Shop App',
      home: Scaffold(
        appBar: AppBar(title: const Text('Sandwich Counter')),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12.0, left: 12.0, right: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Expanded(child: OrderCompactDisplay(3, 'BLT sandwich(es)')),
                  SizedBox(width: 8),
                  Expanded(child: OrderCompactDisplay(3, 'Club sandwich(es)')),
                  SizedBox(width: 8),
                  Expanded(child: OrderCompactDisplay(2, 'Veggie sandwich(es)')),
                ],
              ),
            ),
            const Expanded(
              child: Center(
                child: OrderItemDisplay(5, 'Footlong'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderItemDisplay extends StatelessWidget {
  final String itemType;
  final int quantity;

  const OrderItemDisplay(this.quantity, this.itemType, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 200,
      color: Colors.blue,
      alignment: Alignment.center,
      child: Text(
        '$quantity $itemType sandwich(es): ${List.filled(quantity, '🥪').join()}',
        style: const TextStyle(color: Colors.black, fontSize: 18),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

// Compact display for top row
class OrderCompactDisplay extends StatelessWidget {
  final String itemType;
  final int quantity;

  const OrderCompactDisplay(this.quantity, this.itemType, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Quantity first
          Text(
            '$quantity ',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          // Sandwich name and emoji together
          Expanded(
            child: Text(
              '$itemType ${List.filled(quantity, '🥪').join()}',
              style: const TextStyle(fontSize: 16),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// Example leftover template widgets (you can remove if not needed)
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sandwich Shop App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: const MyHomePage(title: 'My Sandwich Shop'),
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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome to my shop!',
              style: TextStyle(
                fontSize: 24,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

