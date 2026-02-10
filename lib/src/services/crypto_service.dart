import 'dart:convert'; // JSON ডিকোড করার জন্য লাগে
import 'package:http/http.dart' as http; // http প্যাকেজ

class CryptoService {
  // Future<Map<String, dynamic>> getCoinData(
  //     String coinName, String currencyName) async {
  //   try {
  //     final String url =
  //         "https://api.coingecko.com/api/v3/simple/price?ids=$coinName&vs_currencies=$currencyName&include_24hr_change=true";

  //     final response = await http.get(Uri.parse(url));

  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);

  //       double price =
  //           (data[coinName][currencyName] as num?)?.toDouble() ?? 0.0;
  //       double change = (data[coinName]['${currencyName}_24h_change'] as num?)
  //               ?.toDouble() ??
  //           0.0;
  //       return {
  //         'price': price,
  //         'change': change,
  //         'image': data['image'],
  //       };
  //     } else {
  //       return {};
  //     }
  //   } catch (e) {
  //     return {};
  //   }
  // }

  Future<List<dynamic>> getMarketData(List<String> coinIds) async {
    try {
      if (coinIds.isEmpty) return [];

      // আইডিগুলোকে কমা দিয়ে জয়েন করছি (যেমন: bitcoin,ethereum,dogecoin)
      String ids = coinIds.join(',');

      final String url =
          "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&ids=$ids&order=market_cap_desc&per_page=100&page=1&sparkline=false";

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print(data[0]['price']);
        return data;
      } else {
        return [];
      }
    } catch (e) {
      print("Market Data Error: $e");
      return [];
    }
  }

  Future<Map<String, String>?> searchCoin(String query) async {
    try {
      final String url = "https://api.coingecko.com/api/v3/search?query=$query";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List coins = data['coins'];

        if (coins.isNotEmpty) {
          return {
            'id': coins[0]['id'], // bitcoin
            'symbol': coins[0]['symbol'], // btc
            'name': coins[0]['name'],
            'image': coins[0]['large'], // Bitcoin
          };
        }
      }
      return null;
    } catch (e) {
      print("Search Error: $e");
    }
    return null; // কিছু না পেলে নাল রিটার্ন করব
  }
}
