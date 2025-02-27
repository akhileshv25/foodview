// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodview/screens/profile_screens/order_history_screen.dart';

class ProfilePage extends StatelessWidget {
  
  
  const ProfilePage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(),

            _buildSectionTitle("Order History"),
            ListTile(
              leading: const Icon(Icons.receipt_long, color: Colors.black),
              title: const Text("View Orders"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              onTap: () {
                 Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OrderHistoryScreen(userId:FirebaseAuth.instance.currentUser?.uid ?? "")),
    );
              },
            ),

            _buildSectionTitle("Favorites & Preferences"),
            ListTile(
              leading: const Icon(Icons.favorite, color: Colors.black),
              title: const Text("Favorite Dishes"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              onTap: () {
                // Navigate to favorite dishes
              },
            ),
            

            _buildSectionTitle("Wallet & Payments"),
            
            ListTile(
              leading: const Icon(Icons.credit_card, color: Colors.black),
              title: const Text("Payment Methods"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              onTap: () {
                // Navigate to saved payment methods
              },
            ),
            ListTile(
              leading: const Icon(Icons.local_offer, color: Colors.black),
              title: const Text("Coupons & Discounts"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              onTap: () {
                // Navigate to coupons
              },
            ),

            _buildSectionTitle("Settings & Notifications"),
            ListTile(
              leading: const Icon(Icons.notifications, color: Colors.black),
              title: const Text("Notification Settings"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              onTap: () {
                // Navigate to notification settings
              },
            ),
            ListTile(
              leading: const Icon(Icons.language, color: Colors.black),
              title: const Text("Language Preferences"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              onTap: () {
                // Navigate to language preferences
              },
            ),
            ListTile(
              leading: const Icon(Icons.dark_mode, color: Colors.black),
              title: const Text("Dark Mode"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              onTap: () {
                // Toggle dark mode
              },
            ),

            _buildSectionTitle("Support"),
            ListTile(
              leading: const Icon(Icons.help, color: Colors.black),
              title: const Text("Help & Support"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              onTap: () {
                // Navigate to help & support
              },
            ),
            ListTile(
              leading: const Icon(Icons.feedback, color: Colors.black),
              title: const Text("Give Feedback"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              onTap: () {
                // Navigate to feedback form
              },
            ),

            _buildSectionTitle("Account"),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.black),
              title: const Text("Logout"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              onTap: () {
                // Handle logout
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text(
                "Delete Account",
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
              trailing: const Icon(Icons.warning, color: Colors.red),
              onTap: () {
                // Handle delete account
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.deepPurple.shade100,
      child: Row(
        children: [
          CircleAvatar(
  radius: 40,
  backgroundColor: Colors.deepPurple.shade200, // Background color for better visibility
  child: Icon(
    Icons.person, // Profile icon
    size: 40, 
    color: Colors.white, // Adjust color as needed
  ),
),

          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "John Doe",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text("johndoe@example.com", style: TextStyle(color: Colors.grey[700])),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepPurple),
      ),
    );
  }
}
