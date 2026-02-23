// lib/providers/coin_provider.dart

import 'package:basic_landing_page/src/model/coin_model.dart';
import 'package:basic_landing_page/src/services/crypto_service.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CoinProvider extends ChangeNotifier {
  List<Coin> myCoinList = [];
  double assetBalance = 0.0;
  double depositBalance = 0.0;
  double totalBalance = 0.0;
  bool isLoading = true;

  final myBox = Hive.box('cryptoBox');

  // ১. অ্যাপ চালুর সময় ডাটা লোড করা
  Future<void> fetchAndLoadData() async {
    isLoading = true;
    notifyListeners();

    // Hive থেকে সেভ করা Coin ID গুলো নিচ্ছি
    List<dynamic> savedIds = myBox.get('myList', defaultValue: []);
    List<String> coinIds = savedIds.cast<String>();

    if (coinIds.isNotEmpty) {
      // API থেকে লেটেস্ট ডাটা আনছি
      List<dynamic> marketData = await CryptoService().getMarketData(coinIds);
      
      myCoinList.clear(); // পুরোনো ডাটা মুছে নতুন ডাটা বসাচ্ছি

      for (var data in marketData) {
        String coinId = data['id'];
        double savedAmount = myBox.get(coinId, defaultValue: 0.0); // Hive থেকে ব্যালেন্স

        myCoinList.add(
          Coin(
            id: coinId,
            symbol: data['symbol'],
            name: data['name'],
            image: data['image'],
            price: (data['current_price'] as num?)?.toDouble() ?? 0.0,
            changeParcentage: (data['price_change_percentage_24h'] as num?)?.toDouble() ?? 0.0,
            marketCap: (data['market_cap'] as num?)?.toDouble() ?? 0.0,
            rank: (data['market_cap_rank'] as num?)?.toInt() ?? 0,
            high24h: (data['high_24h'] as num?)?.toDouble() ?? 0.0,
            low24h: (data['low_24h'] as num?)?.toDouble() ?? 0.0,
            sparklineIn7d: List<double>.from(data['sparkline_in_7d']['price']),
            amountHeld: savedAmount,
          ),
        );
      }
    }

    calculateTotalBalance();
    isLoading = false;
    notifyListeners();
  }

  // ২. ব্যালেন্স হিসাব করা
  void calculateTotalBalance() {
    double total = 0.0;
    for (var coin in myCoinList) {
      total += coin.amountHeld * coin.price;
    }
    assetBalance = total;
    totalBalance = depositBalance + assetBalance;
    notifyListeners();
  }

  // ৩. ডিপোজিট অ্যাড করা (Add Money)
  void addDeposit(double amount) {
    depositBalance += amount;
    calculateTotalBalance();
  }

  // ৪. নতুন কয়েন লিস্টে অ্যাড করা (AddCoinSection থেকে)
  void addNewCoinToList(Coin newCoin) {
    // ডুপ্লিকেট চেক (আগে থেকে থাকলে আর অ্যাড করবে না)
    bool alreadyExists = myCoinList.any((coin) => coin.id == newCoin.id);
    
    if (!alreadyExists) {
      myCoinList.add(newCoin);
      _updateDatabaseIds();
      calculateTotalBalance();
      notifyListeners();
    }
  }

  // ৫. লিস্ট থেকে কয়েন ডিলিট করা
  void removeCoin(int index) {
    myCoinList.removeAt(index);
    _updateDatabaseIds();
    calculateTotalBalance();
    notifyListeners();
  }

  // ৬. কয়েন কেনা
  Future<void> buyCoin(Coin coin, double amount) async {
    coin.amountHeld += amount;
    await myBox.put(coin.id, coin.amountHeld);
    calculateTotalBalance();
    notifyListeners();
  }

  // ৭. কয়েন বিক্রি করা
  Future<void> sellCoin(Coin coin, double amount) async {
    if (amount > coin.amountHeld) return;
    
    coin.amountHeld -= amount;
    await myBox.put(coin.id, coin.amountHeld);
    calculateTotalBalance();
    notifyListeners();
  }

  // ৮. Hive এ ID গুলো সেভ রাখা
  void _updateDatabaseIds() {
    List<String> coinIds = myCoinList.map((coin) => coin.id).toList();
    myBox.put('myList', coinIds);
  }
}