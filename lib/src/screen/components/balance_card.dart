import 'package:flutter/material.dart';

class BalanceCard extends StatelessWidget {
  final String balance;
  final VoidCallback onDeposit;
  const BalanceCard({
    required this.balance,
    required this.onDeposit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24), // প্যাডিং বাড়ালাম
      margin: EdgeInsets.only(bottom: 20, top: 10),
      decoration: BoxDecoration(
        // সলিড কালারের বদলে গ্রেডিয়েন্ট ব্যবহার করছি
        gradient: LinearGradient(
          colors: [Colors.indigo.shade800, Colors.indigo.shade500],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withOpacity(0.4),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Total Balance",
                style: TextStyle(fontSize: 18, color: Colors.white70),
              ),
              SizedBox(height: 8),
              Text(
                balance,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2, // অক্ষরগুলোর মাঝে ফাঁকা
                ),
              )
            ],
          ),

          // ডিপোজিট বাটন
          ElevatedButton(
            onPressed: onDeposit,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.indigo, // টেক্সট কালার
              shape: StadiumBorder(), // ক্যাপসুল শেপ
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            child: Row(
              children: [
                Icon(Icons.add, size: 18),
                Text(
                  "Deposit",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
