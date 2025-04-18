import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodview/provider/favorite_provider.dart';
import 'package:foodview/utils/cart_items.dart';
import 'package:foodview/utils/color.dart';
import 'package:iconsax/iconsax.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = FavoriteProvider.of(context);
    final favoriteItems = provider.favorites;
    return Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          backgroundColor: white,
          centerTitle: true,
          title: const Text(
            "Favorite",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: favoriteItems.isEmpty
            ? const Center(
                child: Text(
                  "NO Favorites yet",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              )
            : ListView.builder(
                itemCount: favoriteItems.length,
                itemBuilder: (context, index) {
                  String favorite = favoriteItems[index];
                  return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection("food_data")
                          .doc(favorite)
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (!snapshot.hasData || snapshot.data == null) {
                          return const Center(
                            child: Text("Error loading Favorites"),
                          );
                        }
                        var favoriteItem = snapshot.data!;
                        return Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 15),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: gray300),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: gray300,
                                        borderRadius: BorderRadius.circular(20),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                            favoriteItem['image'],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          favoriteItem['name'],
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Iconsax.flash_1,
                                              size: 16,
                                              color: black,
                                            ),
                                            Text(
                                              "${favoriteItem['cal']}Cal",
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: black),
                                            ),
                                            const Text(
                                              " . ",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: black,
                                              ),
                                            ),
                                            const Icon(
                                              Iconsax.wallet_1,
                                              size: 16,
                                              color: black,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "₹${favoriteItem['rate']}",
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: black),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            Positioned(
  top: 40,
  right: 75, // Adjust position to be beside delete button
  child: GestureDetector(
    onTap: () {
      setState(() {
        cartItems.add({
          'name': favoriteItem['name'],
          'calories': favoriteItem['cal'],
          'quantity': 1, // Default quantity
          'price': favoriteItem['rate'],
          'image': favoriteItem['image'],
        });
        saveCart(); // Save to SharedPreferences
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Added to Cart")),
        );
      });
    },
    child: const Icon(
      Iconsax.add_square,
      color: deepPurple,
      size: 25,
    ),
  ),
),

                            Positioned(
                              top: 40,
                              right: 35,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    provider.toggleFavorite(favoriteItem);
                                  });
                                },
                                child: const Icon(
                                  Icons.delete,
                                  color: deepPurple,
                                  size: 25,
                                ),
                              ),
                            ),
                          ],
                        );
                      });
                },
              ));
  }
}
