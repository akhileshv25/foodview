import 'package:flutter/material.dart';
import 'package:foodview/screens/app_home_screen.dart';
import 'package:foodview/screens/favorite_screen.dart';
import 'package:foodview/utils/color.dart';
import 'package:iconsax/iconsax.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;
  late final List<Widget> page;
  @override
  void initState() {
    page = [
      const AppHomeScreen(),
      const FavoriteScreen(),
      navBarPage(Iconsax.calendar),
      navBarPage(Iconsax.user),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          elevation: 0,
          iconSize: 27,
          currentIndex: selectedIndex,
          selectedItemColor: deepPurple,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(
            color: deepPurple,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          onTap: (value) {
            setState(() {
              selectedIndex = value;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  selectedIndex == 0 ? Iconsax.home5 : Iconsax.home_1,
                ),
                label: "home"),
            BottomNavigationBarItem(
                icon: Icon(
                  selectedIndex == 1 ? Iconsax.heart5 : Iconsax.heart,
                ),
                label: "Favorite"),
            BottomNavigationBarItem(
                icon: Icon(
                  selectedIndex == 2 ? Iconsax.calendar5 : Iconsax.calendar,
                ),
                label: "Meal Plan"),
            BottomNavigationBarItem(
                icon: Icon(
                  selectedIndex == 3 ? Iconsax.user : Iconsax.user,
                ),
                label: "Profile"),
          ]),
      body: page[selectedIndex],
    );
  }

  navBarPage(iconName) {
    return Center(
      child: Icon(
        iconName,
        size: 100,
        color: deepPurple,
      ),
    );
  }
}
