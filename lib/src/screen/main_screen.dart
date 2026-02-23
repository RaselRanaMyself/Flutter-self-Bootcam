// lib/src/screen/main_screen.dart

import 'package:basic_landing_page/src/screen/home_screen.dart';
import 'package:basic_landing_page/src/screen/portfolio_screen.dart';
import 'package:basic_landing_page/src/screen/profile_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // বর্তমানে কোন পেজটি সিলেক্ট করা আছে তার ইনডেক্স
  int _currentIndex = 0;

  // আমাদের অ্যাপের পেজগুলোর লিস্ট
  final List<Widget> _pages = [
    const HomePage(), // Index 0: আমাদের মূল হোমপেজ

    // Index 1: Portfolio পেজ (এটি আমরা পরে বানাবো, আপাতত শুধু টেক্সট রাখছি)
    const PortfolioScreen(),

    // Index 2: Profile পেজ (এটিও পরে বানাবো)
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // বডিতে আমরা _pages লিস্ট থেকে বর্তমান ইনডেক্সের পেজটি দেখাবো
      body: _pages[_currentIndex],

      // নিচের নেভিগেশন বার
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          // আইকনে ক্লিক করলে ইনডেক্স চেঞ্জ হবে এবং পেজ আপডেট হবে
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.indigo, // সিলেক্ট করা আইকনের রঙ
        unselectedItemColor: Colors.grey, // অন্য আইকনের রঙ
        backgroundColor: Colors.white,
        elevation: 10,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: "Portfolio",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
