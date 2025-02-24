import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:foodview/utils/color.dart';

class BannerCarousel extends StatefulWidget {
  const BannerCarousel({super.key});

  @override
  _BannerCarouselState createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  final List<Map<String, String>> banners = [
    {
      "image":
          "https://firebasestorage.googleapis.com/v0/b/arsample-595f2.appspot.com/o/Food%2FPizza-removebg-preview.png?alt=media&token=6c5c6838-2222-447a-a8af-b195dea825da",
      "text": "Delicious Pizza \nJust for You!"
    },
    {
      "image":
          "https://firebasestorage.googleapis.com/v0/b/arsample-595f2.appspot.com/o/Food%2FPizza-removebg-preview.png?alt=media&token=6c5c6838-2222-447a-a8af-b195dea825da",
      "text": "Tasty Burgers,\n Made Fresh!"
    },
    {
      "image":
          "https://firebasestorage.googleapis.com/v0/b/arsample-595f2.appspot.com/o/Food%2FPizza-removebg-preview.png?alt=media&token=6c5c6838-2222-447a-a8af-b195dea825da",
      "text": "Authentic Pasta,\n Rich Flavors!"
    },
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 170,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 3),
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        enlargeCenterPage: true,
        viewportFraction: 0.9,
        onPageChanged: (index, reason) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      items: banners.asMap().entries.map((entry) {
        int index = entry.key;
        Map<String, String> banner = entry.value;
        return BannerTo(
          imageUrl: banner["image"]!,
          text: banner["text"]!,
          isActive: index == _currentIndex, // Pass active state
          totalBanners: banners.length,
          currentIndex: _currentIndex,
        );
      }).toList(),
    );
  }
}

class BannerTo extends StatelessWidget {
  final String imageUrl;
  final String text;
  final bool isActive;
  final int totalBanners;
  final int currentIndex;

  const BannerTo({
    super.key,
    required this.imageUrl,
    required this.text,
    required this.isActive,
    required this.totalBanners,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: deepPurple,
      ),
      child: Stack(
        children: [
          Positioned(
            top: 30,
            left: 15,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: const TextStyle(
                      height: 1.1,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: white),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 33),
                      backgroundColor: white,
                      elevation: 0,
                    ),
                    onPressed: () {},
                    child: const Text(
                      "Explore",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: black,
                      ),
                    ))
              ],
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            right: 4,
            child: Image.network(imageUrl, fit: BoxFit.cover),
          ),

          // Dots inside the banner at the bottom
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(totalBanners, (index) {
                return Container(
                  width: currentIndex == index ? 12 : 8,
                  height: 8,
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: currentIndex == index ? white : Colors.white54,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
