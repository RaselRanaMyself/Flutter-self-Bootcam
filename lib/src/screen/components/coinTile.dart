import 'package:flutter/material.dart';
import 'package:basic_landing_page/src/moded/coin_model.dart'; // আপনার মডেল ইমপোর্ট করুন
import 'package:basic_landing_page/src/screen/components/transactionTile.dart'; // পুরনো ডিজাইন টাইল

class CoinTile extends StatelessWidget {
  final Coin coin;
  final VoidCallback onDelete; // প্যারেন্ট (HomePage) কে জানাবে ডিলিট করতে

  const CoinTile({
    super.key,
    required this.coin,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(coin.id),
      direction: DismissDirection.endToStart,

      // ২. ব্যাকগ্রাউন্ড ডিজাইন
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),

      // ৩. কনফার্মেশন লজিক (Dialog)
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Delete Coin?"),
              content: Text("Are you sure you want to remove ${coin.name}?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false), // Cancel
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true), // Delete
                  child:
                      const Text("Delete", style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          },
        );
      },

      // ৪. ডিলিট অ্যাকশন (প্যারেন্ট ফাংশন কল করবে)
      onDismissed: (direction) {
        onDelete();
      },

      // ৫. চাইল্ড হিসেবে আপনার পুরনো সুন্দর ডিজাইনটি
      child: TransactionTile(
        imageUrl: coin.image,
        itemName: coin.name.toUpperCase(),
        changeParcentage: "${(coin.changeParcentage).toStringAsFixed(2)}%",
        itemPrice: coin.price,
        changeParcentageColor:
            coin.changeParcentage >= 0 ? Colors.green : Colors.red,
        changeParcentageIcon: coin.changeParcentage >= 0
            ? Icons.arrow_drop_up
            : Icons.arrow_drop_down,
      ),
    );
  }
}
