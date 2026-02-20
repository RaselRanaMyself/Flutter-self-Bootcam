import 'package:basic_landing_page/src/model/coin_model.dart';
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
  final FocusNode _focusNode = FocusNode();

  void _handleAddCoin() async {
    String input = coinController.text.toLowerCase().trim();
    if (input.isEmpty) return;

    setState(() {
      isAdding = true;
    });
    FocusScope.of(context).unfocus();

    var searchResult = await CryptoService().searchCoin(input);

    if (searchResult != null) {
      String coinId = searchResult['id'] ?? "";
      String name = searchResult['name'] ?? "";

      List<dynamic> marketData = await CryptoService().getMarketData([coinId]);

      if (marketData.isNotEmpty) {
        var data = marketData[0];
        // print("API DATA CHECK: $data");
        Coin newCoin = Coin(
          id: coinId,
          symbol: data['symbol'],
          name: name,
          image: data['image'], // 👈 মডেলে ছবি ঢোকালাম
          price: (data['current_price'] as num?)?.toDouble() ?? 0.0,
          changeParcentage:
              (data['price_change_percentage_24h'] as num?)?.toDouble() ?? 0.0,
          marketCap: (data['market_cap'] as num?)?.toDouble() ?? 0.0,
          rank: (data['market_cap_rank'] as num?)?.toInt() ?? 0,
          high24h: (data['high_24h'] as num?)?.toDouble() ?? 0.0,
          low24h: (data['low_24h'] as num?)?.toDouble() ?? 0.0,
          sparklineIn7d: List<double>.from(data['sparkline_in_7d']['price']),
        );

        widget.onCoinAdded(newCoin);
        coinController.clear();
        FocusScope.of(context).unfocus();
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Price data unavailable for $name"),
            ),
          );
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Coin not found! Check spelling."),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }

    setState(() {
      isAdding = false;
    });
    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    coinController.dispose();
    _focusNode.dispose();
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
              controller: coinController,
              focusNode: _focusNode,
              autofocus: false,
              onTapOutside: (event) {
                _focusNode.unfocus();
              },
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
