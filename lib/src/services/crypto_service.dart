import 'dart:convert'; // JSON ডিকোড করার জন্য লাগে
import 'package:http/http.dart' as http; // http প্যাকেজ

class CryptoService {
  // ১. এপিআই এর ঠিকানা (Endpoint)
  // এটি CoinDesk এর ফ্রি এপিআই, যা বিটকয়েনের বর্তমান দাম দেয়
  // ২. ফিউচার ফাংশন (কারণ ইন্টারনেট থেকে ডাটা আসতে সময় লাগে)
  Future<double> getCoinPrice(String coinName, String currencyName) async {
    try {
      final String url =
          "https://api.coingecko.com/api/v3/simple/price?ids=$coinName&vs_currencies=$currencyName";

      // ৩. রিকোয়েস্ট পাঠানো (GET Request)
      final response = await http.get(Uri.parse(url));

      // ৪. চেক করা সার্ভার ঠিক আছে কিনা (StatusCode 200 মানে OK)
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // var price = data['coinName']['usd'].toDouble();
        // print(price);

        return data[coinName][currencyName].toDouble();
      } else {
        return 0.0;
      }
    } catch (e) {
      return 0.0;
    }
  }

  Future<Map<String, String>?> searchCoin(String query) async {
    try {
      // সার্চ এপিআই ইউআরএল
      final String url = "https://api.coingecko.com/api/v3/search?query=$query";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List coins = data['coins'];

        if (coins.isNotEmpty) {
          // প্রথম রেজাল্টটাই আমরা নেব (সবচেয়ে সঠিকটা)
          return {
            'id': coins[0]['id'], // bitcoin
            'symbol': coins[0]['symbol'], // btc
            'name': coins[0]['name'] // Bitcoin
          };
        }
      }
    } catch (e) {
      print("Search Error: $e");
    }
    return null; // কিছু না পেলে নাল রিটার্ন করব
  }
}
