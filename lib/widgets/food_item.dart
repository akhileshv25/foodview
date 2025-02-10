import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodview/provider/favorite_provider.dart';
import 'package:foodview/screens/food_screen.dart';
import 'package:foodview/utils/color.dart';
import 'package:iconsax/iconsax.dart';

class FoodItem extends StatelessWidget {
  final DocumentSnapshot<Object?> documentSnapshot;

  const FoodItem({super.key, required this.documentSnapshot});

  @override
  Widget build(BuildContext context) {
    final provider = FavoriteProvider.of(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FoodScreen(
              documentSnapshot: documentSnapshot,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        width: 190,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: documentSnapshot['image'],
                  child: Container(
                    width: double.infinity,
                    height: 140,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          documentSnapshot['image'],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  documentSnapshot['name'],
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    const Icon(
                      Iconsax.flash_1,
                      size: 16,
                      color: gray500,
                    ),
                    Text(
                      "${documentSnapshot['cal']}Cal",
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: gray500),
                    ),
                    const Text(
                      " . ",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: gray500,
                      ),
                    ),
                    const Icon(
                      Iconsax.wallet_1,
                      size: 16,
                      color: gray500,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      "₹${documentSnapshot['time']}",
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: gray500),
                    ),
                  ],
                )
              ],
            ),
            Positioned(
              top: 5,
              right: 5,
              child: CircleAvatar(
                radius: 17,
                backgroundColor: white,
                child: InkWell(
                  onTap: () {
                    provider.toggleFavorite(documentSnapshot);
                  },
                  child: Icon(
                    provider.isExist(documentSnapshot)
                        ? Iconsax.heart5
                        : Iconsax.heart,
                    color:
                        provider.isExist(documentSnapshot) ? deepPurple : black,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
