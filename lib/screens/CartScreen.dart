import 'package:flutter/material.dart';
import 'package:foodview/screens/order_service.dart';
import 'package:iconsax/iconsax.dart';
import 'package:foodview/utils/cart_items.dart'; // Import your global cart
import 'package:foodview/utils/color.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
void initState() {
  super.initState();
  loadCart().then((_) {
    setState(() {}); // Refresh UI after loading data
     print("Cart Loaded: $cartItems"); // Debug log
  });
}

  // Calculate Total Price
  double getTotalPrice() {
    return cartItems.fold(
        0, (sum, item) => sum + (item['price'] * item['quantity']));
  }

  // Update Quantity Function
  void updateQuantity(int index, int change) {
  setState(() {
    if (cartItems[index]['quantity'] + change > 0) {
      cartItems[index]['quantity'] += change;
      saveCart(); // Save after update
    }
  });
}

void removeItem(int index) {
  setState(() {
    cartItems.removeAt(index);
    saveCart(); // Save after deletion
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
  title: const Text(
    "My Cart",
    style: TextStyle(fontWeight: FontWeight.bold),
  ),
 
),

      body: cartItems.isEmpty
          ? const Center(
              child: Text(
                "Your cart is empty",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 15),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: gray300,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                spreadRadius: 2,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Food Image
                              Container(
                                width: 100,
                                height: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(item['image']),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),

                              // Item Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['name'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 5),

                                    // Calories & Price
                                    Row(
                                      children: [
                                        const Icon(Iconsax.flash_1,
                                            size: 16, color: Colors.black),
                                        Text(
                                          "${item['calories']} Cal",
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                        const Text(
                                          " • ",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const Icon(Iconsax.wallet_1,
                                            size: 16, color: Colors.black),
                                        const SizedBox(width: 5),
                                        Text(
                                          "₹${item['price']}",
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 8),

                                    // Quantity Controls & Delete
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () => updateQuantity(index, -1),
                                          child: const Icon(Iconsax.minus_square,
                                              color: Colors.deepPurple,
                                              size: 28),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          "${item['quantity']}",
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(width: 10),
                                        GestureDetector(
                                          onTap: () => updateQuantity(index, 1),
                                          child: const Icon(Iconsax.add_square,
                                              color: Colors.deepPurple,
                                              size: 28),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // Delete Button
                              GestureDetector(
                                onTap: () => removeItem(index),

                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.deepPurple,
                                  size: 28,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Total Price & Order Button
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        spreadRadius: 3,
                        offset: Offset(0, -3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Total Price Display
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total Price:",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "₹${getTotalPrice().toStringAsFixed(2)}",
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      // Order It Button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () async {
                          String userId = FirebaseAuth.instance.currentUser!.uid; // Get current user ID
    await OrderService().placeOrder(userId); // Place order

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Order placed successfully!")),
    );

    setState(() {}); // Refresh UI after clearing the cart
                        },
                        child: const Text(
                          "Order It",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
