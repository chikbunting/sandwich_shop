import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:sandwich_shop/models/sandwich.dart';

/// Load sandwiches list from assets/sandwiches.json.
Future<List<Sandwich>> loadSandwichData() async {
  final String jsonString = await rootBundle.loadString('assets/sandwiches.json');
  final Map<String, dynamic> jsonData = json.decode(jsonString) as Map<String, dynamic>;
  final List<dynamic> items = jsonData['sandwiches'] as List<dynamic>? ?? [];
  return items.map((e) => Sandwich.fromJson(Map<String, dynamic>.from(e))).toList();
}
