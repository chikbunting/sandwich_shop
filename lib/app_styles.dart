import 'package:flutter/material.dart';

class AppStyles {
  // Colors
  static const Color primary = Colors.blue;
  static const Color positive = Colors.green;
  static const Color negative = Colors.red;

  // Text styles
  static const TextStyle itemText = TextStyle(
    color: Colors.black,
    fontSize: 18,
  );

  static const TextStyle noteText = TextStyle(
    color: Colors.white,
    fontSize: 14,
  );

  static const TextStyle headerText = TextStyle(
    fontSize: 24,
    color: Colors.green,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle normalText = TextStyle(
    fontSize: 16,
    color: Colors.black,
  );

  static const TextStyle bold16 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  // Button styles (use .copyWith if you need small variations)
  static final ButtonStyle addButton = ElevatedButton.styleFrom(
    backgroundColor: positive,
    foregroundColor: Colors.white,
    textStyle: const TextStyle(fontWeight: FontWeight.bold),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  );

  static final ButtonStyle removeButton = ElevatedButton.styleFrom(
    backgroundColor: negative,
    foregroundColor: Colors.white,
    textStyle: const TextStyle(fontWeight: FontWeight.bold),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  );

  static final ButtonStyle cartButton = ElevatedButton.styleFrom(
    backgroundColor: primary,
    foregroundColor: Colors.white,
    textStyle: const TextStyle(fontWeight: FontWeight.bold),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  );
}