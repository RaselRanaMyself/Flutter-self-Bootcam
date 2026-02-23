import 'package:basic_landing_page/providers/coin_provider.dart';
import 'package:basic_landing_page/src/screen/cion_details_screen.dart';
import 'package:basic_landing_page/src/screen/components/balance_card.dart';
import 'package:basic_landing_page/src/screen/components/portfolio_coin_card.dart';
import 'package:basic_landing_page/src/screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Portfolio"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black, // টেক্সট এবং আইকনের কালার
      ),
      body: Consumer<CoinProvider>(
        builder: (context, provider, child) {
          final formattedBalance =
              NumberFormat.currency(locale: 'en_US', symbol: '\$')
                  .format(provider.totalBalance);
          // ১. শুধুমাত্র সেই কয়েনগুলো ফিল্টার করছি যেগুলো ইউজারের কাছে আছে
          final ownedCoins =
              provider.myCoinList.where((coin) => coin.amountHeld > 0).toList();

          // ২. যদি ইউজারের কাছে কোনো কয়েন না থাকে
          if (ownedCoins.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.account_balance_wallet_outlined,
                      size: 80, color: Colors.grey),
                  SizedBox(height: 20),
                  Text(
                    "Your portfolio is empty!",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text("Buy some coins from the Home page.",
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          // ৩. যদি কয়েন থাকে, তবে লিস্ট আকারে দেখাবো
          return Column(
            children: [
              // মোট ইনভেস্টমেন্ট বা ব্যালেন্স দেখানোর জন্য একটি কার্ড
              BalanceCard(
                balance: formattedBalance,
                onDeposit: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainScreen()),
                  );
                },
                actionName: "Add Coin",
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Your Assets",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              // ইউজারের কেনা কয়েনগুলোর লিস্ট
              Expanded(
                child: ListView.builder(
                  itemCount: ownedCoins.length,
                  itemBuilder: (context, index) {
                    final currentCoin = ownedCoins[index];
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
                      child: PortfolioCoinCard(
                        coin: currentCoin,
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
