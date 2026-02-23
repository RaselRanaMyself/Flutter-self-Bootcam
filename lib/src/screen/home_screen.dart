// import 'package:basic_landing_page/src/model/coin_model.dart';
// import 'package:basic_landing_page/src/screen/add_money_screen.dart';
// import 'package:basic_landing_page/src/screen/components/add_coin.dart';
// import 'package:basic_landing_page/src/screen/components/balance_card.dart';
// import 'package:basic_landing_page/src/screen/components/coinTile.dart';
// import 'package:basic_landing_page/src/screen/cion_details_screen.dart';
// import 'package:basic_landing_page/src/services/crypto_service.dart';
// import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:intl/intl.dart';

// // ... State ক্লাসের ভেতরে

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   double totalBalance = 0;
//   final myBox = Hive.box('cryptoBox');
//   List<Coin> myCoinList = [];
//   bool isRefreshing = false;

//   @override
//   void initState() {
//     super.initState();
//     loadData();
//   }

//   void loadData() {
//     List<dynamic> coinIds = myBox.get('myList', defaultValue: []);
//     if (coinIds.isNotEmpty) {
//       myCoinList.clear();
//       for (String id in coinIds) {
//         double savedAmount = myBox.get(id, defaultValue: 0.0);

//         myCoinList.add(
//           Coin(
//             id: id,
//             symbol: id,
//             name: id,
//             image:
//                 "https://assets.coingecko.com/coins/images/1/large/bitcoin.png",
//             price: 0,
//             changeParcentage: 0,
//             amountHeld: savedAmount, // <-- Add this to your Model constructor
//           ),
//         );
//       }
//       setState(() {});
//       _calculateTotalBalance(); // 👇 এখানে কল করুন

//       refreshAllCoinPrice();
//     }
//   }

//   void updateDatabase() {
//     List<String> coinIds = myCoinList.map((coin) => coin.id).toList();

//     myBox.put('myList', coinIds);
//   }

//   double assetBalance = 0.0; //মোট ব্যালেন্স রাখার জন্য

// // 👇 এই ফাংশনটি হিসাব করবে
//   void _calculateTotalBalance() {
//     double total = 0.0;
//     for (var coin in myCoinList) {
//       total += coin.amountHeld * coin.price;
//     }

//     setState(() {
//       assetBalance = total;
//       totalBalance = depostiBalance + assetBalance;
//     });
//   }

//   double depostiBalance = 0.0;

//   void addMoney() async {
//     final newAmount = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => const AddMoneyScreen(),
//       ),
//     );

//     if (newAmount != null) {
//       setState(() {
//         depostiBalance = depostiBalance + (newAmount as double);
//         totalBalance = depostiBalance + assetBalance;
//       });
//     }
//   }

//   Future<void> refreshAllCoinPrice() async {
//     List<String> coinIds = myCoinList.map((coin) => coin.id).toList();
//     if (coinIds.isEmpty) return;

//     setState(() {
//       isRefreshing = true;
//     });
//     List<dynamic> marketData = await CryptoService().getMarketData(coinIds);

//     if (marketData.isNotEmpty) {
//       setState(() {
//         for (var data in marketData) {
//           // print(data['price']);
//           Coin coinToUpdate =
//               myCoinList.firstWhere((element) => element.id == data['id']);
//           coinToUpdate.price =
//               (data['current_price'] as num?)?.toDouble() ?? 0.0;
//           coinToUpdate.changeParcentage =
//               (data['price_change_percentage_24h'] as num?)?.toDouble() ?? 0.0;
//           coinToUpdate.image = data['image'];
//           coinToUpdate.marketCap =
//               (data['market_cap'] as num?)?.toDouble() ?? 0.0;
//           coinToUpdate.rank = (data['market_cap_rank'] as num?)?.toInt() ?? 0;
//           coinToUpdate.high24h = (data['high_24h'] as num?)?.toDouble() ?? 0.0;
//           coinToUpdate.low24h = (data['low_24h'] as num?)?.toDouble() ?? 0.0;
//           coinToUpdate.sparklineIn7d =
//               List<double>.from(data['sparkline_in_7d']['price']);
//         }
//       });
//       setState(() {
//         isRefreshing = false;
//       });
//     }

//     setState(() {
//       isRefreshing = false;
//     });
//     _calculateTotalBalance(); // 👇 এখানে কল করুন
//   }

//   @override
//   Widget build(BuildContext context) {
//     final formattedBalance =
//         NumberFormat.currency(locale: 'en_US', symbol: '\$')
//             .format(totalBalance);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Dynamic Trading History List"),
//         centerTitle: true,
//         elevation: 0,
//         // actions: [
//         //   IconButton(
//         //     onPressed: () {
//         //       refreshAllCoinPrice();
//         //     },
//         //     icon: Icon(
//         //       Icons.refresh,
//         //       color: Colors.grey,
//         //     ),
//         //   )
//         // ],
//         bottom: isRefreshing
//             ? const PreferredSize(
//                 preferredSize: Size.fromHeight(4),
//                 child: LinearProgressIndicator(color: Colors.indigo),
//               )
//             : null,
//       ),
//       body: Column(
//         children: [
//           BalanceCard(
//             balance: formattedBalance,
//             onDeposit: addMoney,
//           ),
//           AddCoinSection(onCoinAdded: (Coin newCoin) {
//             setState(() {
//               myCoinList.add(newCoin);
//             });
//             updateDatabase();
//             refreshAllCoinPrice();
//           }),
//           Expanded(
//             child: RefreshIndicator
//                 //  Opacity
//                 (
//               color: Colors.blue,
//               onRefresh: () async {
//                 await refreshAllCoinPrice();
//               },
//               child: Opacity(
//                 opacity: isRefreshing ? 0.5 : 1,
//                 child: ListView.builder(
//                     itemCount: myCoinList.length,
//                     itemBuilder: (context, index) {
//                       Coin currentCoin = myCoinList[index];
//                       return GestureDetector(
//                         onTap: () async {
//                           // 👇 পেজে যাওয়া
//                           await Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => TransactionDetailsScreen(
//                                   coin: myCoinList[index]),
//                             ),
//                           );

//                           // 👇 পেজ থেকে ফিরে আসার পর হিসাব আপডেট
//                           _calculateTotalBalance();
//                         },
//                         child: CoinTile(
//                           coin: currentCoin,
//                           onDelete: () {
//                             setState(() {
//                               myCoinList.removeAt(index);
//                             });
//                             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                               content: Text("${currentCoin.name} removed!"),
//                               duration: Duration(seconds: 1),
//                             ));
//                             updateDatabase();
//                           },
//                         ),
//                       );
//                     }),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// lib/src/screen/home_page.dart

import 'package:basic_landing_page/src/model/coin_model.dart';
import 'package:basic_landing_page/src/screen/add_money_screen.dart';
import 'package:basic_landing_page/src/screen/components/add_coin.dart';
import 'package:basic_landing_page/src/screen/components/balance_card.dart';
import 'package:basic_landing_page/src/screen/components/coinTile.dart';
import 'package:basic_landing_page/src/screen/cion_details_screen.dart'; // আপনার ফাইলের নাম অনুযায়ী
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart'; // 👈 Provider ইমপোর্ট
import '../../providers/coin_provider.dart'; // 👈 আপনার প্রোভাইডার ইমপোর্ট

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // ১. অ্যাপ চালু হলেই Provider কে বলছি ডাটা লোড করতে
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CoinProvider>(context, listen: false).fetchAndLoadData();
    });
  }

  // ২. টাকা ডিপোজিট করার ফাংশন
  void addMoney(BuildContext context) async {
    final newAmount = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddMoneyScreen(),
      ),
    );

    if (newAmount != null) {
      // Provider এর মাধ্যমে ব্যালেন্স আপডেট
      Provider.of<CoinProvider>(context, listen: false)
          .addDeposit(newAmount as double);
    }
  }

  @override
  Widget build(BuildContext context) {
    // ৩. Consumer দিয়ে পুরো পেজ র‍্যাপ করছি, যাতে ডাটা চেঞ্জ হলে অটো আপডেট হয়
    return Consumer<CoinProvider>(
      builder: (context, provider, child) {
        final formattedBalance =
            NumberFormat.currency(locale: 'en_US', symbol: '\$')
                .format(provider.totalBalance);

        return Scaffold(
          appBar: AppBar(
            title: const Text("Dynamic Trading History List"),
            centerTitle: true,
            elevation: 0,
            bottom: provider.isLoading // 👈 Provider থেকে লোডিং স্টেট
                ? const PreferredSize(
                    preferredSize: Size.fromHeight(4),
                    child: LinearProgressIndicator(color: Colors.indigo),
                  )
                : null,
          ),
          body: Column(
            children: [
              BalanceCard(
                balance: formattedBalance,
                onDeposit: () => addMoney(context),
                actionName: "Deposit",
              ),

              // AddCoinSection কল করছি
              AddCoinSection(onCoinAdded: (Coin newCoin) {
                // 👈 Provider এর মাধ্যমে নতুন কয়েন অ্যাড
                provider.addNewCoinToList(newCoin);
              }),

              Expanded(
                child: RefreshIndicator(
                  color: Colors.blue,
                  onRefresh: () async {
                    // 👈 Provider এর ডাটা রিফ্রেশ
                    await provider.fetchAndLoadData();
                  },
                  child: Opacity(
                    opacity: provider.isLoading ? 0.5 : 1.0,
                    child: ListView.builder(
                      itemCount: provider.myCoinList.length,
                      itemBuilder: (context, index) {
                        Coin currentCoin = provider.myCoinList[index];

                        return GestureDetector(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    TransactionDetailsScreen(coin: currentCoin),
                              ),
                            );
                            // ফিরে আসার পর Provider অটো ব্যালেন্স আপডেট করবে!
                            // এখানে আলাদা করে _calculateTotalBalance() কল করার দরকার নেই।
                          },
                          child: CoinTile(
                            coin: currentCoin,
                            onDelete: () {
                              // 👈 Provider থেকে কয়েন ডিলিট
                              provider.removeCoin(index);

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("${currentCoin.name} removed!"),
                                duration: const Duration(seconds: 1),
                              ));
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
