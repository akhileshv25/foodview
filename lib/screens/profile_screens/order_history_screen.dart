import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class OrderHistoryScreen extends StatefulWidget {
  final String userId; // Pass the logged-in user ID
  const OrderHistoryScreen({super.key, required this.userId});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  String searchQuery = "";
  bool sortAsc = true;
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order History"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(sortAsc ? Icons.arrow_upward : Icons.arrow_downward),
            onPressed: () {
              setState(() {
                sortAsc = !sortAsc;
              });
            },
          )
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search by item...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(widget.userId)
                  .collection("orders")
                  .orderBy("timestamp", descending: !sortAsc)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                var orders = snapshot.data!.docs;

                // Filter orders based on search query
                orders = orders.where((doc) {
                  var items = doc['items'] as List;
                  return items.any((item) =>
                      item['name'].toString().toLowerCase().contains(searchQuery));
                }).toList();

                if (orders.isEmpty) {
                  return const Center(child: Text("No Orders Found"));
                }

                return ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    var order = orders[index].data() as Map<String, dynamic>;
                    var timestamp = (order['timestamp'] as Timestamp).toDate();
                    var formattedDate = DateFormat("dd MMM yyyy, hh:mm a").format(timestamp);
                    var totalAmount = order['items']
                        // ignore: avoid_types_as_parameter_names
                        .fold(0.0, (sum, item) => sum + (item['pricePerUnit'] * item['quantity']));

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Status & Date
                           Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: order['status'] == "pending"
                ? Colors.orange.shade200
                : Colors.green.shade200,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            order['status'].toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          formattedDate,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    ),
    if (order['status'] == "pending") // Show Pay Now button only if status is pending
      ElevatedButton(
        onPressed: () {
          // Implement your payment logic here
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text("Pay Now", style: TextStyle(fontSize: 12)),
      ),
  ],
),


                            const Divider(),

                            // Order Items
                            Column(
                              children: (order['items'] as List).map((item) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("${item['name']} x${item['quantity']}",
                                          style: const TextStyle(fontWeight: FontWeight.w600)),
                                      Text("₹${(item['pricePerUnit'] * item['quantity']).toStringAsFixed(2)}"),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                            const Divider(),

                            // Total Price
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Total",
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                Text("₹${totalAmount.toStringAsFixed(2)}",
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
