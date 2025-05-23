import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ar_plugin/flutter_ar_plugin.dart';
import 'package:foodview/provider/favorite_provider.dart';
import 'package:foodview/screens/notify_icon.dart';
import 'package:foodview/screens/order_service.dart';
import 'package:foodview/utils/color.dart';
import 'package:iconsax/iconsax.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:foodview/utils/cart_items.dart'; // Import global cart

class FoodScreen extends StatefulWidget {
  final DocumentSnapshot<Object?> documentSnapshot;
  const FoodScreen({super.key, required this.documentSnapshot});

  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  bool _isLoading = true;
  late int quantity;
  late String quantityUnit;
  late Map<String, dynamic> nutrients;
  late double baseCalories;
  late int baseQuantity;
  final OrderService orderService = OrderService();

  Future<void> _loadModel() async {
    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadModel();
    quantity = 1;
    quantityUnit = widget.documentSnapshot['quantity']?['unit'] ?? "g";
    baseQuantity = widget.documentSnapshot['quantity']?['value'] ?? 1;
    baseCalories = double.tryParse(widget.documentSnapshot['cal']?.toString() ?? "0") ?? 0;

    nutrients = {
      'protein': double.tryParse(widget.documentSnapshot['nutrients']?['protein']?.toString() ?? "0") ?? 0,
      'carbs': double.tryParse(widget.documentSnapshot['nutrients']?['carbs']?.toString() ?? "0") ?? 0,
      'fats': double.tryParse(widget.documentSnapshot['nutrients']?['fats']?.toString() ?? "0") ?? 0,
      'fiber': double.tryParse(widget.documentSnapshot['nutrients']?['fiber']?.toString() ?? "0") ?? 0,
    };
  }

  void updateNutrients() {
    setState(() {
      final factor = quantity.toDouble();
      nutrients.updateAll((key, value) =>
          double.tryParse(widget.documentSnapshot['nutrients']?[key]?.toString() ?? "0")! * factor);
    });
  }

  void incrementQuantity() {
    setState(() {
      quantity += 1;
      updateNutrients();
    });
  }

  void decrementQuantity() {
    setState(() {
      if (quantity > 1) quantity -= 1;
      updateNutrients();
    });
  }

  String getCurrentUserId() {
    return FirebaseAuth.instance.currentUser?.uid ?? "";
  }

  @override
  Widget build(BuildContext context) {
    final provider = FavoriteProvider.of(context);
    return Scaffold(
      backgroundColor: white,
      body: Stack(
        children: [
          Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 2.1,
                    child: ModelViewer(
                      backgroundColor: gray400,
                      src: widget.documentSnapshot['model_url'] ?? '',
                      iosSrc: widget.documentSnapshot['ios_model_url'] ?? '',
                      alt: 'A 3D food model',
                      ar: false,
                      autoRotate: true,
                      disableZoom: false,
                      debugLogging: true,
                      loading: Loading.eager,
                    ),
                  ),
                  if (_isLoading)
                    const Positioned(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(
                            strokeWidth: 6,
                            color: Colors.deepPurple,
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Loading...",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              foodDetails(),
              nutritionDetails(),
            ],
          ),
          Positioned(
            top: 40,
            left: 10,
            right: 10,
            child: Row(
              children: [
                NotifyIcon(
                  icon: Icons.arrow_back_ios_new,
                  pressed: () {
                    Navigator.pop(context);
                  },
                ),
                const Spacer(),
                NotifyIcon(
                  icon: provider.isExist(widget.documentSnapshot)
                      ? Iconsax.heart5
                      : Iconsax.heart,
                  color: provider.isExist(widget.documentSnapshot) ? deepPurple : black,
                  pressed: () {
                    provider.toggleFavorite(widget.documentSnapshot);
                  },
                ),
              ],
            ),
          ),
          bottomButtons(context),
        ],
      ),
    );
  }

  Widget bottomButtons(BuildContext context) {
    return Positioned(
      bottom: 50,
      left: 20,
      right: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () {
              cartItems.add({
                'name': widget.documentSnapshot['name'] ?? '',
                'calories': widget.documentSnapshot['cal'] ?? '',
                'quantity': quantity,
                'price': widget.documentSnapshot['rate'] ?? 0,
                'image': widget.documentSnapshot['image'] ?? '',
              });
              saveCart();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Added to Cart")),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Icon(Icons.shopping_cart),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: deepPurple,
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
              foregroundColor: white,
            ),
            onPressed: () {
              try {
                FlutterArPlugin.launchARView(
                  modelUrl: widget.documentSnapshot['model_url'] ?? '',
                  imageUrl:
                      "https://firebasestorage.googleapis.com/v0/b/arsample-595f2.appspot.com/o/Furniture%2Fqr.jpeg?alt=media&token=b39cb577-6f5e-42b6-8172-c2194da5ec27",
                  scaleFactor: 10.0,
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("AR view error: $e")),
                );
              }
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.view_in_ar),
                SizedBox(width: 8),
                Text(
                  "Taste it!!!",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget foodDetails() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.documentSnapshot['name'] ?? '',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                    onPressed: decrementQuantity,
                  ),
                  Text(
                    "$quantity",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                    onPressed: incrementQuantity,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Iconsax.tag, color: Colors.orange.shade700, size: 22),
              const SizedBox(width: 4),
              Text(
                "₹${((widget.documentSnapshot['rate'] ?? 0) * quantity).toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              const Icon(Icons.favorite, color: Colors.red, size: 30),
              const SizedBox(width: 5),
              Text("${widget.documentSnapshot['likes'] ?? 0} Likes",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Spacer(),
              const Icon(Icons.local_fire_department, color: Colors.red, size: 30),
              const SizedBox(width: 5),
              Text("${(baseCalories * quantity).toStringAsFixed(2)} kcal",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Spacer(),
              const Icon(Icons.restaurant, color: Colors.green, size: 30),
              const SizedBox(width: 5),
              Text(
                "${(baseQuantity * quantity)} $quantityUnit",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget nutritionDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          nutritionCard("Proteins", formatNumber(nutrients['protein']), Icons.science_outlined),
          nutritionCard("Carbs", formatNumber(nutrients['carbs']), Icons.bakery_dining_outlined),
          nutritionCard("Fats", formatNumber(nutrients['fats']), Icons.opacity),
          nutritionCard("Fiber", formatNumber(nutrients['fiber']), Icons.grass),
        ],
      ),
    );
  }

  Widget nutritionCard(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 24, color: Colors.grey.shade700),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  String formatNumber(dynamic value) {
    if (value is num) {
      return "${value.toStringAsFixed(2)} g";
    }
    return "0.00 g";
  }
}
