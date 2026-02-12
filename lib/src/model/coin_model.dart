class Coin {
  String id;
  String symbol;
  String name;
  String image;
  double price;
  double changeParcentage;
  double marketCap;
  int rank;
  double high24h;
  double low24h;
  List<double> sparklineIn7d;

  Coin({
    required this.id,
    required this.symbol,
    required this.name,
    required this.image,
    required this.price,
    required this.changeParcentage,
    this.marketCap = 0,
    this.rank = 0,
    this.high24h = 0,
    this.low24h = 0,
    this.sparklineIn7d = const [],
  });
}
