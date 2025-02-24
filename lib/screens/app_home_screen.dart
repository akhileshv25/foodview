import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodview/provider/auth_provider.dart';
import 'package:foodview/screens/notify_icon.dart';
import 'package:foodview/screens/view_item.dart';
import 'package:foodview/screens/welcome_screen.dart';
import 'package:foodview/utils/color.dart';
import 'package:foodview/widgets/banner.dart';
import 'package:foodview/widgets/food_item.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class AppHomeScreen extends StatefulWidget {
  const AppHomeScreen({super.key});

  @override
  State<AppHomeScreen> createState() => _AppHomeScreenState();
}

class _AppHomeScreenState extends State<AppHomeScreen> {
  String category = "All";

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    final CollectionReference categoryItems =
        FirebaseFirestore.instance.collection("food_category");

    Query filteredFood = FirebaseFirestore.instance
        .collection("food_data")
        .where('category', isEqualTo: category);

    Query allFood = FirebaseFirestore.instance.collection("food_data");
    Query selectedFood = category == "All" ? allFood : filteredFood;

    return Scaffold(
      backgroundColor: white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Header(ap),
                    SearchBar(),
                    const BannerCarousel(),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "Categories",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Categories(categoryItems),
                  ],
                ),
              ),

              /// Food Sections
              FoodCategorySection(title: "Quick & Easy", query: selectedFood),
              FoodCategorySection(
                title: "Breakfast",
                query: FirebaseFirestore.instance
                    .collection("food_data")
                    .where('category', isEqualTo: "Breakfast"),
              ),
              FoodCategorySection(
                title: "Lunch",
                query: FirebaseFirestore.instance
                    .collection("food_data")
                    .where('category', isEqualTo: "Lunch"),
              ),
              FoodCategorySection(
                title: "Dinner",
                query: FirebaseFirestore.instance
                    .collection("food_data")
                    .where('category', isEqualTo: "Dinner"),
              ),
              FoodCategorySection(
                title: "Drinks",
                query: FirebaseFirestore.instance
                    .collection("food_data")
                    .where('category', isEqualTo: "Drinks"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Food Category Section Widget
  StreamBuilder<QuerySnapshot<Object?>> Categories(
      CollectionReference categoryItems) {
    return StreamBuilder(
      stream: categoryItems.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        if (streamSnapshot.hasData) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                streamSnapshot.data!.docs.length,
                (index) => GestureDetector(
                  onTap: () {
                    setState(() {
                      category = streamSnapshot.data!.docs[index]["name"];
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color:
                          category == streamSnapshot.data!.docs[index]["name"]
                              ? deepPurple
                              : gray300,
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    margin: const EdgeInsets.only(right: 20),
                    child: Text(
                      streamSnapshot.data!.docs[index]["name"],
                      style: TextStyle(
                        color:
                            category == streamSnapshot.data!.docs[index]["name"]
                                ? white
                                : gray900,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  /// Search Bar Widget
  Padding SearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 22),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: const Icon(Iconsax.search_normal),
          filled: true,
          fillColor: white,
          border: InputBorder.none,
          hintText: "Search Any Food You Like!",
          hintStyle: const TextStyle(
            color: gray500,
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: black),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: purple300),
          ),
        ),
      ),
    );
  }

  /// Header Widget
  Row Header(AuthProvider ap) {
    return Row(
      children: [
        const Text(
          "What Would You \nLove to Order?",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            height: 1,
          ),
        ),
        const Spacer(),
        NotifyIcon(
          icon: Iconsax.logout,
          pressed: () {
            ap.userSignOut().then(
                  (value) => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WelcomeScreen(),
                    ),
                  ),
                );
          },
        ),
      ],
    );
  }
}

/// Reusable Section Widget for Different Food Categories
class FoodCategorySection extends StatelessWidget {
  final String title;
  final Query query;

  const FoodCategorySection(
      {super.key, required this.title, required this.query});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ViewItem(),
                    ),
                  );
                },
                child: const Text(
                  "View All",
                  style:
                      TextStyle(color: deepPurple, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        StreamBuilder(
          stream: query.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              final List<DocumentSnapshot> food = snapshot.data?.docs ?? [];
              return Padding(
                padding: const EdgeInsets.only(left: 15),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children:
                        food.map((e) => FoodItem(documentSnapshot: e)).toList(),
                  ),
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ],
    );
  }
}
