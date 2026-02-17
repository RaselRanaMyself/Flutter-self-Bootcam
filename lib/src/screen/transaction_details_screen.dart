import 'package:basic_landing_page/src/model/coin_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TransactionDetailsScreen extends StatefulWidget {
  final Coin coin;

  const TransactionDetailsScreen({
    super.key,
    required this.coin,
  });

  @override
  State<TransactionDetailsScreen> createState() =>
      _TransactionDetailsScreenState();
}

class _TransactionDetailsScreenState extends State<TransactionDetailsScreen> {
  // DetailsPage ক্লাসের ভেতরে
  void _showBuyDialog(BuildContext context) {
    TextEditingController amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Buy ${widget.coin.name}"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Current Price: \$${widget.coin.price}"),
              const SizedBox(height: 10),
              // ইনপুট ফিল্ড
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number, // শুধু নাম্বার কীবোর্ড আসবে
                decoration: const InputDecoration(
                  labelText: "Amount to buy",
                  hintText: "Ex: 0.5",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            // Cancel Button
            TextButton(
              onPressed: () {
                Navigator.pop(context); // ডায়ালগ বন্ধ
              },
              child: const Text("Cancel"),
            ),

            // Confirm Buy Button
            ElevatedButton(
              onPressed: () {
                // ১. ইনপুট থেকে সংখ্যা নেওয়া
                double amountToBuy =
                    double.tryParse(amountController.text) ?? 0.0;

                // ২. আপনার ওয়ালেটে যোগ করা
                setState(() {
                  widget.coin.amountHeld += amountToBuy;
                });

                print("Bought: $amountToBuy ${widget.coin.symbol}");
                print("Total Held: ${widget.coin.amountHeld}");

                // ৩. ডায়ালগ বন্ধ করা
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text("Confirm Buy",
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300], // হালকা ব্যাকগ্রাউন্ড
      appBar: AppBar(
        title: Text(widget.coin.name),
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
                  backgroundImage: NetworkImage(widget.coin.image),
                ),
                const SizedBox(height: 30),

                // ডিটেইলস টেক্সট
                Text(
                  widget.coin.name,
                  style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  "${widget.coin.changeParcentage.toStringAsFixed(2)}%"
                      .toString(),
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                Divider(), // একটি লাইন টানে
                const SizedBox(height: 20),
                Text(
                  widget.coin.price.toString(),
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    // color: color,
                  ),
                ),
                const SizedBox(height: 10),

// 👇 নতুন: আপনার কাছে কত টাকার কয়েন আছে
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.blue),
                  ),
                  child: Text(
                    "Your Assets: ${widget.coin.amountHeld} ${widget.coin.symbol.toUpperCase()}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // ২. টাইম সিলেক্টর বাটন (নতুন যোগ করা হলো) 👇
                _buildTimeButtons(),
                const SizedBox(height: 20),

                // 👇 চার্ট উইজেটটি এখানে কল করলাম
                SizedBox(
                  height: 250, // চার্টের উচ্চতা
                  child: CoinLineChart(
                    prices: widget.coin.sparklineIn7d, // ৭ দিনের ডাটা পাঠালাম
                    color: widget.coin.changeParcentage >= 0
                        ? Colors.green
                        : Colors.red, // লাভ হলে সবুজ, লস হলে লাল
                  ),
                ),

                const SizedBox(height: 20),
                _buildDetailRow("Market Cap", "\$${widget.coin.marketCap}"),
                const Divider(),
                _buildDetailRow("Market Rank", "#${widget.coin.rank}"),
                const Divider(),
                _buildDetailRow("24h High", "\$${widget.coin.high24h}"),
                const Divider(),
                _buildDetailRow("24h Low", "\$${widget.coin.low24h}"),
              ],
            ),
          ),
        ),
      ),
      // DetailsPage -> Scaffold এর ভেতরে

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            // SELL Button
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "SELL",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(width: 20), // মাঝখানে ফাঁকা

            // BUY Button
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  _showBuyDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "BUY",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
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

// DetailsPage ক্লাসের ভেতরে

Widget _buildTimeButtons() {
  List<String> times = ['1H', '24H', '7D', '1M', '1Y', 'ALL'];

  return SizedBox(
    height: 50,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: times.length,
      itemBuilder: (context, index) {
        // আমরা আপাতত শুধু '7D' কে সিলেক্টেড দেখাবো
        bool isSelected = times[index] == '7D';

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? Colors.grey[300] : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                times[index],
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
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
