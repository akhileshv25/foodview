import 'package:flutter/material.dart';
import 'package:foodview/provider/auth_provider.dart';
import 'package:foodview/screens/home_screen.dart';
import 'package:foodview/screens/register_screen.dart';
import 'package:foodview/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/image1.png",
                height: 300,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Let's Get Start",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Never a better time then now to start!",
                style: TextStyle(
                  fontSize: 10,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              // Custom Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: CustomButton(
                  text: "Get Start",
                  onPressed: () async {
                    if (ap.isSignedIn == true) {
                      await ap.getDataFromSP().whenComplete(
                            () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeScreen(),
                              ),
                            ),
                          );
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterScreen(),
                        ),
                      );
                    }
                  },
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
