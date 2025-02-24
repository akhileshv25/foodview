import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ar_plugin/flutter_ar_plugin.dart';
import 'package:foodview/provider/favorite_provider.dart';
import 'package:foodview/screens/notify_icon.dart';
import 'package:foodview/utils/color.dart';
import 'package:iconsax/iconsax.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class FoodScreen extends StatefulWidget {
  final DocumentSnapshot<Object?> documentSnapshot;
  const FoodScreen({super.key, required this.documentSnapshot});

  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  bool _isLoading = true;

  // Simulate model loading
  Future<void> _loadModel() async {
    await Future.delayed(const Duration(seconds: 3)); // Simulate delay
    setState(() {
      _isLoading = false; // Model is loaded
    });
  }

  @override
  void initState() {
    super.initState();
    _loadModel(); // Start loading the model on init
  }

  @override
  Widget build(BuildContext context) {
    final provider = FavoriteProvider.of(context);

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: bottumButtonAndIcon(provider),
      backgroundColor: white,
      body: Stack(
        children: [
          Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 2.1,
                    child: ModelViewer(
                      backgroundColor: gray400,
                      src: widget.documentSnapshot['model_url'],
                      alt: 'A 3D food model',
                      ar: false,
                      autoRotate: true,
                      iosSrc: widget.documentSnapshot['ios_model_url'],
                      disableZoom: false,
                      debugLogging: true,
                      loading: Loading.eager, // Load model immediately
                    ),
                  ),

                  // Show loader while the model is loading
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
                  icon: Iconsax.notification,
                  pressed: () {},
                ),
              ],
            ),
          ),
        ],
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
            onPressed: () {
              FlutterArPlugin.launchARView(
                modelUrl: widget.documentSnapshot['model_url'],
                imageUrl:
                    "https://firebasestorage.googleapis.com/v0/b/arsample-595f2.appspot.com/o/Furniture%2Fqr.jpeg?alt=media&token=b39cb577-6f5e-42b6-8172-c2194da5ec27",
                scaleFactor: 10.0, // Adjust the scale as needed
              );
            },
            child: const Text(
              "Taste it!!!",
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
