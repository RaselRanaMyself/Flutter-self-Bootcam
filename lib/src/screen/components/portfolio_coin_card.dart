import 'package:basic_landing_page/src/model/coin_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PortfolioCoinCard extends StatelessWidget {
  final Coin coin;
  // final double holdingValue;
  const PortfolioCoinCard({
    super.key,
    required this.coin,
    // required this.holdingValue,
  });

  @override
  Widget build(BuildContext context) {
    final formattedholdingValue =
        NumberFormat.currency(locale: 'en_US', symbol: '\$')
            .format(coin.amountHeld * coin.price);
    // final holdingValue = coin.amountHeld * coin.price;
    final coinPrice =
        NumberFormat.currency(locale: 'en_US', symbol: '\$').format(coin.price);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: CircleAvatar(
          backgroundColor: Colors.transparent,
          backgroundImage: NetworkImage(coin.image),
        ),
        title: Text(coin.name,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
            "${coin.amountHeld.toStringAsFixed(4)} ${coin.symbol.toUpperCase()}"),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              formattedholdingValue,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              coinPrice,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
