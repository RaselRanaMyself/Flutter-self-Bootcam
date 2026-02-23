import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // হালকা ব্যাকগ্রাউন্ড কালার
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),

            // ইউজারের ছবি (আপাতত ইন্টারনেট থেকে একটি ডামি ছবি ব্যবহার করছি)
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  const CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(
                      'https://cdn-icons-png.flaticon.com/512/3135/3135715.png', // ডামি অ্যাভাটার
                    ),
                    backgroundColor: Colors.transparent,
                  ),
                  // ছবির উপরে একটি ছোট এডিট আইকন
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.indigo,
                      shape: BoxShape.circle,
                    ),
                    child:
                        const Icon(Icons.edit, color: Colors.white, size: 20),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),

            // ইউজারের নাম ও ইমেইল
            const Text(
              "Crypto Trader",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              "trader@example.com",
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 30),

            // সেটিংস অপশনগুলো
            _buildProfileOption(context, Icons.person_outline, "Edit Profile"),
            _buildProfileOption(context, Icons.security, "Security & PIN"),
            _buildProfileOption(
                context, Icons.notifications_none, "Notifications"),
            _buildProfileOption(context, Icons.help_outline, "Help & Support"),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Divider(), // একটি চিকন দাগ
            ),

            // লগআউট বাটন (একটু লাল রঙের হবে)
            _buildProfileOption(context, Icons.logout, "Logout",
                isDestructive: true),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // অপশনগুলো বারবার না লিখে একটি রিইউজেবল উইজেট (Reusable Widget) তৈরি করলাম
  Widget _buildProfileOption(BuildContext context, IconData icon, String title,
      {bool isDestructive = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDestructive
                ? Colors.red.withOpacity(0.1)
                : Colors.indigo.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: isDestructive ? Colors.red : Colors.indigo,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDestructive ? Colors.red : Colors.black87,
          ),
        ),
        trailing:
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: () {
          // বাটনে ক্লিক করলে একটি স্ন্যাপবার দেখাবে (আপাতত)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("$title clicked! (Coming soon)"),
              duration: const Duration(seconds: 1),
            ),
          );
        },
      ),
    );
  }
}
