import 'package:basic_landing_page/src/model/coin_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TransactionDetailsScreen extends StatelessWidget {
  final Coin coin;

  const TransactionDetailsScreen({
    super.key,
    required this.coin,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300], // হালকা ব্যাকগ্রাউন্ড
      appBar: AppBar(
        title: Text(coin.name),
        backgroundColor: Colors.grey[300],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // একটি বড় আইকন
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.indigo.shade100,
                  backgroundImage: NetworkImage(coin.image),
                ),
                const SizedBox(height: 30),

                // ডিটেইলস টেক্সট
                Text(
                  coin.name,
                  style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  "${coin.changeParcentage.toStringAsFixed(2)}%".toString(),
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                Divider(), // একটি লাইন টানে
                const SizedBox(height: 20),
                Text(
                  coin.price.toString(),
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    // color: color,
                  ),
                ),
                const SizedBox(height: 20),

                // 👇 চার্ট উইজেটটি এখানে কল করলাম
                SizedBox(
                  height: 250, // চার্টের উচ্চতা
                  child: CoinLineChart(
                    prices: coin.sparklineIn7d, // ৭ দিনের ডাটা পাঠালাম
                    color: coin.changeParcentage >= 0
                        ? Colors.green
                        : Colors.red, // লাভ হলে সবুজ, লস হলে লাল
                  ),
                ),

                const SizedBox(height: 20),
                _buildDetailRow("Market Cap", "\$${coin.marketCap}"),
                const Divider(),
                _buildDetailRow("Market Rank", "#${coin.rank}"),
                const Divider(),
                _buildDetailRow("24h High", "\$${coin.high24h}"),
                const Divider(),
                _buildDetailRow("24h Low", "\$${coin.low24h}"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildDetailRow(String title, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, color: Colors.grey)),
        Text(value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    ),
  );
}

class CoinLineChart extends StatelessWidget {
  final List<double> prices;
  final Color color;

  const CoinLineChart({super.key, required this.prices, required this.color});

  @override
  Widget build(BuildContext context) {
    // ১. ডাটা চেক: যদি ডাটা না থাকে বা কম থাকে
    if (prices.isEmpty) {
      return const Center(child: Text("No chart data available"));
    }

    // ২. স্পট তৈরি: প্রাইসগুলোকে গ্রাফের পয়েন্টে (X, Y) রূপান্তর করা
    // X = সময় (0, 1, 2...), Y = দাম
    List<FlSpot> spots = prices.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value);
    }).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: AspectRatio(
        aspectRatio: 1.70, // গ্রাফের সাইজ রেশিও
        child: LineChart(
          LineChartData(
            // গ্রাফের পেছনের গ্রিড লাইন বন্ধ করে দিলাম (ক্লিন লুকের জন্য)
            gridData: FlGridData(show: false),

            // বর্ডার বা টাইটেল বন্ধ
            titlesData: FlTitlesData(show: false),
            borderData: FlBorderData(show: false),

            // ৩. লাইন এবং কালার কনফিগারেশন
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true, // লাইনটা স্মুথ হবে
                color: color, // গ্রিন বা রেড কালার
                barWidth: 3, // লাইনের মোটা
                dotData: FlDotData(show: false), // পয়েন্টে ডট দেখাব না

                // লাইনের নিচে হালকা শ্যাডো কালার
                belowBarData: BarAreaData(
                  show: true,
                  color: color.withOpacity(0.2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
