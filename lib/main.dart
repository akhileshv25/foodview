import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foodview/provider/auth_provider.dart';
import 'package:foodview/provider/favorite_provider.dart';
import 'package:foodview/screens/main_screen.dart';
import 'package:foodview/screens/welcome_screen.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MainScreen(),
        title: "FlutterPhoneAuth",
      ),
    );
  }
}
