import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:foodview/utils/cart_items.dart'; 

class OrderService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> placeOrder(String userId) async {
    final userRef = _db.collection('users').doc(userId);
    final ordersRef = userRef.collection('orders');

    try {
      // 1. Check if there's a pending order
      final pendingOrderQuery = await ordersRef.where('status', isEqualTo: 'pending').get();


      if (pendingOrderQuery.docs.isNotEmpty) {
        // 2. If a pending order exists, update it
        final existingOrderDoc = pendingOrderQuery.docs.first;
        final existingOrderId = existingOrderDoc.id;

        // Get existing items and update them
        List<dynamic> existingItems = existingOrderDoc.data()['items'];
        for (var newItem in cartItems) {
          bool found = false;
          for (var item in existingItems) {
            if (item['name'] == newItem['name']) {
              item['quantity'] += newItem['quantity'];
              found = true;
              break;
            }
          }
          if (!found) {
            existingItems.add({
              'name': newItem['name'],
              'quantity': newItem['quantity'],
              'pricePerUnit': newItem['price'],
            });
          }
        }

        // Update the existing order
        await ordersRef.doc(existingOrderId).update({'items': existingItems});
        print("Updated existing order: $existingOrderId");
      } else {
        // 3. If no pending order, create a new order
        String orderId = DateTime.now().millisecondsSinceEpoch.toString();

        await ordersRef.doc(orderId).set({
          'orderId': orderId,
          'items': cartItems.map((item) {
            return {
              'name': item['name'],
              'quantity': item['quantity'],
              'pricePerUnit': item['price'],
            };
          }).toList(),
          'status': 'pending',
          'timestamp': FieldValue.serverTimestamp(),
        });

        print("Created new order: $orderId");
      }

      // 4. Clear the cart after ordering
      cartItems.clear();
      await saveCart(); // Save empty cart to storage
    } catch (e) {
      print("Error placing order: $e");
    }
  }
}
