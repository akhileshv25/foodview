import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodview/provider/favorite_provider.dart';
import 'package:foodview/screens/notify_icon.dart';
import 'package:foodview/utils/color.dart';
import 'package:foodview/widgets/food_item.dart';
import 'package:iconsax/iconsax.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class FoodScreen extends StatefulWidget {
  final DocumentSnapshot<Object?> documentSnapshot;
  const FoodScreen({super.key, required this.documentSnapshot});

  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = FavoriteProvider.of(context);

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: bottumButtonAndIcon(provider),
      backgroundColor: white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 2.1,
                  child: const ModelViewer(
                    backgroundColor: gray400,
                    src:
                        'https://firebasestorage.googleapis.com/v0/b/ardemo-70dc1.appspot.com/o/CharModel%2Fpink_rose.glb?alt=media&token=2ca1a7f5-8541-4da1-98f6-3c3d4645f35d',
                    alt: 'A 3D food model',
                    ar: true,
                    autoRotate: true,
                    // iosSrc: widget.documentSnapshot['ios_model_url'],
                    disableZoom: false,
                    debugLogging: false,
                  ),
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
                      Spacer(),
                      NotifyIcon(
                        icon: Iconsax.notification,
                        pressed: () {},
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: MediaQuery.of(context).size.width,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  FloatingActionButton bottumButtonAndIcon(FavoriteProvider provider) {
    return FloatingActionButton.extended(
      backgroundColor: Colors.transparent,
      elevation: 0,
      onPressed: () {},
      label: Row(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: deepPurple,
              padding:
                  const EdgeInsets.symmetric(horizontal: 100, vertical: 10),
              foregroundColor: white,
            ),
            onPressed: () {},
            child: const Text(
              "Tast it!!!",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            style: IconButton.styleFrom(
              shape: const CircleBorder(
                side: BorderSide(color: deepPurple, width: 2),
              ),
            ),
            onPressed: () {
              provider.toggleFavorite(widget.documentSnapshot);
            },
            icon: Icon(
              provider.isExist(widget.documentSnapshot)
                  ? Iconsax.heart5
                  : Iconsax.heart,
              color: provider.isExist(widget.documentSnapshot)
                  ? deepPurple
                  : black,
              size: 20,
            ),
          )
        ],
      ),
    );
  }
}
