import 'package:flutter/material.dart';

class TransactionDetailsScreen extends StatelessWidget {
  final String image;
  final String itemName;
  final double price;
  final String changeParcentage;
  // final Color color;

  const TransactionDetailsScreen({
    super.key,
    required this.image,
    required this.itemName,
    required this.price,
    required this.changeParcentage,
    // required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transaction Details"),
        backgroundColor: Colors.indigo,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // একটি বড় আইকন
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.indigo.shade100,
                backgroundImage: NetworkImage(image),
              ),
              const SizedBox(height: 30),

              // ডিটেইলস টেক্সট
              Text(
                itemName,
                style:
                    const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                changeParcentage,
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              Divider(), // একটি লাইন টানে
              const SizedBox(height: 20),
              Text(
                price.toString(),
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  // color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
