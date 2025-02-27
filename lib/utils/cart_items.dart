import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

List<Map<String, dynamic>> cartItems = [];

Future<void> saveCart() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('cart', jsonEncode(cartItems));
  print("Cart Saved: $cartItems"); // Debugging
}

Future<void> loadCart() async {
  final prefs = await SharedPreferences.getInstance();
  String? cartData = prefs.getString('cart');

  if (cartData != null) {
    cartItems = List<Map<String, dynamic>>.from(jsonDecode(cartData));
    print("Cart Loaded: $cartItems"); // Debugging
  }
}
