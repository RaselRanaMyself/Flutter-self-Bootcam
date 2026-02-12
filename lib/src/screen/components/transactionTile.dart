import 'package:basic_landing_page/src/model/coin_model.dart';
import 'package:basic_landing_page/src/screen/transaction_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionTile extends StatefulWidget {
  final Coin coin;

  const TransactionTile({
    super.key,
    required this.coin,
  });

  @override
  State<TransactionTile> createState() => _TransactionTileState();
}

class _TransactionTileState extends State<TransactionTile> {
  bool isLiked = false;

  void onPressed() {
    setState(() {
      isLiked = !isLiked;
    });
  }

  @override
  Widget build(BuildContext context) {
    final formattedBalance =
        NumberFormat.currency(locale: 'en_US', symbol: '\$')
            .format(widget.coin.price
                // widget.itemPrice,
                );
    return GestureDetector(
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TransactionDetailsScreen(
              coin: widget.coin,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        // height: 80,
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey.shade100,
              backgroundImage: NetworkImage(widget.coin.image),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.coin.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          widget.coin.changeParcentage >= 0
                              ? Icons.arrow_drop_up
                              : Icons.arrow_drop_down,
                          size: 26,
                          color: widget.coin.changeParcentage >= 0
                              ? Colors.green
                              : Colors.red,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          "${widget.coin.changeParcentage.toStringAsFixed(2)}%"
                              .toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: widget.coin.changeParcentage >= 0
                                ? Colors.green
                                : Colors.red,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Text(
              formattedBalance,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                // color: widget.priceColor
              ),
            ),
            IconButton(
              icon: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                color: isLiked ? Colors.red : Colors.grey,
              ),
              onPressed: onPressed,
            ),
          ],
        ),
      ),
    );
  }
}
