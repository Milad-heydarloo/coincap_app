class Model_Coin {
  String id;
  String name;
  String symbol;
  double changePercent24hr;
  double priceUsd;
  double marketCapUsd;
  int rank;

  Model_Coin(
    this.id,
    this.name,
    this.symbol,
    this.changePercent24hr,
    this.priceUsd,
    this.marketCapUsd,
    this.rank,
  );

  factory Model_Coin.formJsonObject(Map<String, dynamic> jsonobject) {
    return Model_Coin(
      jsonobject['id'],
      jsonobject['name'],
      jsonobject['symbol'],
      double.parse(jsonobject['changePercent24Hr']),
      double.parse(jsonobject['priceUsd']),
      double.parse(jsonobject['marketCapUsd']),
      int.parse(jsonobject['rank']),
    );
  }
}
