import 'package:basic_landing_page/src/moded/coin_model.dart';
import 'package:basic_landing_page/src/screen/add_money_screen.dart';
import 'package:basic_landing_page/src/screen/components/add_coin_section.dart';
import 'package:basic_landing_page/src/screen/components/balance_card.dart';
import 'package:basic_landing_page/src/screen/components/coinTile.dart';
import 'package:basic_landing_page/src/services/crypto_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ... State ক্লাসের ভেতরে

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double balance = 0;
  // double ethcoinPrice = 0.0;
  List<Coin> myCoinList = [];
  bool isRefreshing = false;

  void addMoney() async {
    final newAmount = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddMoneyScreen(),
      ),
    );

    if (newAmount != null) {
      setState(() {
        balance = balance + (newAmount as double);
      });
    }
  }

  void refreshAllCoinPrice() async {
    if (myCoinList.isEmpty) return;

    setState(() {
      isRefreshing = true;
    });

    for (int i = 0; i < myCoinList.length; i++) {
      String name = myCoinList[i].name;
      double newPrice = await CryptoService().getCoinPrice(name, 'usd');

      if (newPrice > 0) {
        myCoinList[i].price = newPrice;
      }
    }

    setState(() {
      isRefreshing = false;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final formattedBalance =
        NumberFormat.currency(locale: 'en_US', symbol: '\$').format(balance);
    return Scaffold(
      appBar: AppBar(
        title: Text("Dynamic Trading History List"),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              refreshAllCoinPrice();
            },
            icon: Icon(
              Icons.refresh,
              color: Colors.grey,
            ),
          )
        ],
        bottom: isRefreshing
            ? const PreferredSize(
                preferredSize: Size.fromHeight(4),
                child: LinearProgressIndicator(color: Colors.indigo),
              )
            : null,
      ),
      body: Column(
        children: [
          AddCoinSection(onCoinAdded: (Coin notCoin) {
            setState(() {
              myCoinList.add(notCoin);
            });
          }),
          BalanceCard(
            balance: formattedBalance,
            onDeposit: addMoney,
          ),
          Expanded(
            child: Opacity(
              opacity: isRefreshing ? 0.5 : 1,
              child: ListView.builder(
                  itemCount: myCoinList.length,
                  itemBuilder: (context, index) {
                    Coin currentCoin = myCoinList[index];
                    return CoinTile(
                      coin: currentCoin,
                      onDelete: () {
                        setState(() {
                          myCoinList.removeAt(index);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("${currentCoin.name} removed!"),
                          duration: Duration(seconds: 1),
                        ));
                      },
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
