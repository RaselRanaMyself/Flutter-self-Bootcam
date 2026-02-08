import 'package:basic_landing_page/src/moded/coin_model.dart';
import 'package:basic_landing_page/src/services/crypto_service.dart';
import 'package:flutter/material.dart';

class AddCoinSection extends StatefulWidget {
  final Function(Coin) onCoinAdded;
  const AddCoinSection({required this.onCoinAdded, super.key});

  @override
  State<AddCoinSection> createState() => _AddCoinSectionState();
}

class _AddCoinSectionState extends State<AddCoinSection> {
  bool isAdding = false;
  TextEditingController coinController = TextEditingController();

  void _handleAddCoin() async {
    String input = coinController.text.toLowerCase().trim();
    if (input.isEmpty) return;
    setState(() {
      isAdding = true;
    });
    FocusScope.of(context).unfocus();
    Map<String, String> localMap = {
      'btc': 'bitcoin',
      'eth': 'ethereum',
      'sol': 'solana',
      'bnb': 'binancecoin',
      'doge': 'dogecoin',
    };

    String coinID = input;
    String coinSymbol = input;
    String coinName = input;

    if (localMap.containsKey(input)) {
      coinID = localMap[input]!;
      coinSymbol = input;
      coinName = coinID;
    } else {
      var searchResult = await CryptoService().searchCoin(input);
      if (searchResult != null) {
        coinID = searchResult['id'] ?? input;
        coinSymbol = searchResult['symbol'] ?? input;
        coinName = searchResult['name'] ?? input;
      } else {
        setState(() {
          isAdding = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Coin not found!"),
            ),
          );
        }
        return;
      }
    }
    double price = await CryptoService().getCoinPrice(coinID, 'usd');
    if (price > 0) {
      Coin newCoin = Coin(
        id: coinID,
        symbol: coinSymbol,
        name: coinName,
        price: price,
      );

      widget.onCoinAdded(newCoin);

      coinController.clear();
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Price data unavailable for $coinName"),
          ),
        );
      }
    }

    setState(() {
      isAdding = false;
    });
  }

  @override
  void dispose() {
    coinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: coinController, // ইনপুট কন্ট্রোলার
              decoration: InputDecoration(
                hintText: "Enter coin name (e.g. bitcoin)",
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 10),
          ElevatedButton(
            onPressed:
                isAdding ? null : _handleAddCoin, // বাটন চাপলে ফাংশন কল হবে
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
            child: isAdding
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2),
                  )
                : Text(
                    "Add",
                    style: TextStyle(color: Colors.white),
                  ),
          ),
        ],
      ),
    );
  }
}
