import 'package:flutter/material.dart';

class NotifyIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback pressed;
  final Color? color; // Optional color parameter

  const NotifyIcon({
    super.key,
    required this.icon,
    required this.pressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: IconButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        backgroundColor: Colors.white,
        fixedSize: const Size(50, 50),
      ),
      onPressed: pressed,
      icon: Icon(icon, color: color),
    );
  }
}
