import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

enum SandwichSize { footlong, sixInch }
// Unit prices per sandwich size (USD)
const Map<SandwichSize, double> _priceMap = {
  SandwichSize.footlong: 8.99,
  SandwichSize.sixInch: 5.49,
};

class OrderItem {
  final int quantity;
  final String itemType;
  final String? note;
  final double unitPrice;
  final DateTime createdAt;

  OrderItem({
    required this.quantity,
    required this.itemType,
    this.note,
    required this.unitPrice,
    required this.createdAt,
  });

  double get total => unitPrice * quantity;
}

void main() {
  runApp(const App());
}

// Main App
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Sandwich Shop App',
      home: OrderScreen(maxQuantity: 5),
    );
  }
}

class OrderItemDisplay extends StatelessWidget {
  final String itemType;
  final int quantity;
  final String? note;

  const OrderItemDisplay(this.quantity, this.itemType, {this.note, super.key});

  @override
  Widget build(BuildContext context) {
    final sandwiches = List.filled(quantity, '🥪').join();
    return Container(
      width: 400,
      height: 200,
      color: Colors.blue,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$quantity $itemType sandwich(es): $sandwiches',
            style: const TextStyle(color: Colors.black, fontSize: 18),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (note != null && note!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Note: $note',
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ]
        ],
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
  void _incrementCounter() {
    setState(() {
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

class OrderScreen extends StatefulWidget {
  final int maxQuantity;

  const OrderScreen({super.key, this.maxQuantity = 10});

  @override
  State<OrderScreen> createState() {
    return _OrderScreenState();
  }
}

class _OrderScreenState extends State<OrderScreen> {
  int _quantity = 0;
  final TextEditingController _noteController = TextEditingController();
  SandwichSize _selectedSize = SandwichSize.footlong;
  final List<OrderItem> _orders = [];

  String _sizeLabel(SandwichSize s) => s == SandwichSize.footlong ? 'Footlong' : 'Six-inch';

  double get _unitPrice => _priceMap[_selectedSize]!;
  double get _totalPrice => _unitPrice * _quantity;

  double get _ordersTotal => _orders.fold(0.0, (sum, o) => sum + o.total);

  void _handleAddOrder() {
    if (_quantity <= 0) return;
    final item = OrderItem(
      quantity: _quantity,
      itemType: _sizeLabel(_selectedSize),
      note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
      unitPrice: _unitPrice,
      createdAt: DateTime.now(),
    );
    setState(() {
      _orders.insert(0, item);
      _quantity = 0;
      _noteController.clear();
    });
  }

  void _increaseQuantity() {
    if (_quantity < widget.maxQuantity) {
      setState(() {
        _quantity++;
        // Temporary debug line (only in debug builds)
        if (kDebugMode) {
          debugPrint('Current quantity: $_quantity');
        }
      });
    }
  }


  void _decreaseQuantity() {
    if (_quantity > 0) {
      setState(() => _quantity--);
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sandwich Counter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: SegmentedButton<SandwichSize>(
                segments: const <ButtonSegment<SandwichSize>>[
                  ButtonSegment<SandwichSize>(value: SandwichSize.footlong, label: Text('Footlong')),
                  ButtonSegment<SandwichSize>(value: SandwichSize.sixInch, label: Text('Six-inch')),
                ],
                selected: <SandwichSize>{_selectedSize},
                onSelectionChanged: (Set<SandwichSize> newSelection) {
                  if (newSelection.isNotEmpty) {
                    setState(() {
                      _selectedSize = newSelection.first;
                    });
                  }
                },
              ),
            ),
            OrderItemDisplay(
              _quantity,
              _sizeLabel(_selectedSize),
              note: _noteController.text,
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: TextField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  hintText: 'e.g., no onions, extra pickles',
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
            const SizedBox(height: 12),
            // Price display
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Unit price: \$${_unitPrice.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 4),
                  Text('Total: \$${_totalPrice.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _quantity < widget.maxQuantity ? _increaseQuantity : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.greenAccent,
                    disabledForegroundColor: Colors.white70,
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text('Add'),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _quantity > 0 ? _decreaseQuantity : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.redAccent.shade100,
                    disabledForegroundColor: Colors.white70,
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  icon: const Icon(Icons.remove),
                  label: const Text('Remove'),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _quantity > 0 ? _handleAddOrder : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.blue.shade100,
                    disabledForegroundColor: Colors.white70,
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  icon: const Icon(Icons.shopping_cart),
                  label: const Text('Add to Orders'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Order history', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('Grand total: \$${_ordersTotal.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _orders.isEmpty
                  ? const Center(child: Text('No orders yet'))
                  : ListView.separated(
                      itemCount: _orders.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, index) {
                        final o = _orders[index];
                        return ListTile(
                          title: Text('${o.quantity} x ${o.itemType} — \$${o.total.toStringAsFixed(2)}'),
                          subtitle: o.note != null ? Text(o.note!) : null,
                          trailing: Text('\$${o.unitPrice.toStringAsFixed(2)} ea'),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

