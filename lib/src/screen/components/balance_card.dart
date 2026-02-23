import 'package:flutter/material.dart';

class BalanceCard extends StatelessWidget {
  final String balance;
  final VoidCallback onDeposit;
  final String actionName;
  const BalanceCard({
    required this.balance,
    required this.onDeposit,
    required this.actionName,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.blue, Colors.purple], // সুন্দর গ্র্যাডিয়েন্ট
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.5),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Total Portfolio Balance",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 10),
                Text(
                  balance, // 👈 এখানে টোটাল দেখাচ্ছি
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            // ডিপোজিট বাটন
          ),
        ),
        ElevatedButton(
          onPressed: onDeposit,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white, // টেক্সট কালার
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          child: Row(
            children: [
              Icon(
                Icons.add,
                size: 18,
                color: Colors.white,
              ),
              Text(
                actionName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 10,
        )
      ],
    );
  }
}
