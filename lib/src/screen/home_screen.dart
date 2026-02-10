import 'package:basic_landing_page/src/moded/coin_model.dart';
import 'package:basic_landing_page/src/screen/add_money_screen.dart';
import 'package:basic_landing_page/src/screen/components/add_coin_section.dart';
import 'package:basic_landing_page/src/screen/components/balance_card.dart';
import 'package:basic_landing_page/src/screen/components/coinTile.dart';
import 'package:basic_landing_page/src/services/crypto_service.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

// ... State ক্লাসের ভেতরে

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double balance = 0;
  final myBox = Hive.box('cryptoBox');
  List<Coin> myCoinList = [];
  bool isRefreshing = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() {
    List<dynamic> coinIds = myBox.get('myList', defaultValue: []);
    if (coinIds.isNotEmpty) {
      myCoinList.clear();
      for (String id in coinIds) {
        myCoinList.add(
          Coin(
            id: id,
            symbol: id,
            name: id,
            image:
                "https://assets.coingecko.com/coins/images/1/large/bitcoin.png",
            price: 0,
            changeParcentage: 0,
          ),
        );
      }
      setState(() {});
      refreshAllCoinPrice();
    }
  }

  void updateDatabase() {
    List<String> coinIds = myCoinList.map((coin) => coin.id).toList();

    myBox.put('myList', coinIds);
  }

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
    List<String> coinIds = myCoinList.map((coin) => coin.id).toList();
    if (coinIds.isEmpty) return;

    setState(() {
      isRefreshing = true;
    });
    List<dynamic> marketData = await CryptoService().getMarketData(coinIds);

    if (marketData.isNotEmpty) {
      setState(() {
        for (var data in marketData) {
          print(data['price']);
          Coin coinToUpdate =
              myCoinList.firstWhere((element) => element.id == data['id']);
          coinToUpdate.price = (data['price'] as num?)?.toDouble() ?? 0.0;
          coinToUpdate.changeParcentage =
              (data['price_change_percentage_24h'] as num?)?.toDouble() ?? 0.0;
          coinToUpdate.image = data['image'];
        }
      });
      setState(() {
        isRefreshing = false;
      });
    }

    setState(() {
      isRefreshing = false;
    });
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
          AddCoinSection(onCoinAdded: (Coin newCoin) {
            setState(() {
              myCoinList.add(newCoin);
            });
            updateDatabase();
            refreshAllCoinPrice();
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
                        updateDatabase();
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
