import 'package:basic_landing_page/src/screen/transaction_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionTile extends StatefulWidget {
  final String imageUrl;
  final String itemName;
  final String changeParcentage;
  final double itemPrice;
  final Color changeParcentageColor;
  final IconData changeParcentageIcon;

  const TransactionTile(
      {super.key,
      required this.imageUrl,
      required this.itemName,
      required this.changeParcentage,
      required this.itemPrice,
      required this.changeParcentageColor,
      required this.changeParcentageIcon});

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
            .format(widget.itemPrice);
    return GestureDetector(
      onTap: () async {
        
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TransactionDetailsScreen(
              image: widget.imageUrl,
              itemName: widget.itemName,
              price: widget.itemPrice,
              changeParcentage: widget.changeParcentage,
              // color: widget.priceColor,
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
              backgroundImage: NetworkImage(widget.imageUrl),
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
                      widget.itemName,
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
                          widget.changeParcentageIcon,
                          size: 26,
                          color: widget.changeParcentageColor,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          widget.changeParcentage,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: widget.changeParcentageColor,
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
