import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/views/order_history_screen.dart';
import 'package:sandwich_shop/models/saved_order.dart';
import 'package:sandwich_shop/services/database_service.dart';

class FakeDatabaseService extends DatabaseService {
  final List<SavedOrder> _orders;
  FakeDatabaseService(this._orders);

  @override
  Future<List<SavedOrder>> getOrders() async {
    return _orders;
  }
}

void main() {
  testWidgets('OrderHistory shows no orders message when empty', (WidgetTester tester) async {
    final fakeDb = FakeDatabaseService([]);
    await tester.pumpWidget(MaterialApp(home: OrderHistoryScreen(databaseService: fakeDb)));
    await tester.pumpAndSettle();

    expect(find.text('No orders yet'), findsOneWidget);
  });

  testWidgets('OrderHistory lists saved orders', (WidgetTester tester) async {
    final orders = [
      SavedOrder(id: 1, orderId: 'ORD1', totalAmount: 12.5, itemCount: 2, orderDate: DateTime.now()),
    ];
    final fakeDb = FakeDatabaseService(orders);
    await tester.pumpWidget(MaterialApp(home: OrderHistoryScreen(databaseService: fakeDb)));
    await tester.pumpAndSettle();

    expect(find.text('ORD1'), findsOneWidget);
    expect(find.text('£12.50'), findsOneWidget);
  });
}
