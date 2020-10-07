import 'package:flutter/cupertino.dart';

class CryptoSymbol {
  String symbol;
  String name;
  String imageUrl;
  String infoUrl;
  String performanceRating;

  CryptoSymbol(
      {@required this.symbol,
      @required this.name,
      @required this.imageUrl,
      @required this.infoUrl,
      @required this.performanceRating});

  @override
  String toString() {
    return 'CryptoSymbol{symbol: $symbol, name: $name, imageUrl: $imageUrl, infoUrl: $infoUrl, performanceRating: $performanceRating}';
  }

// /Data/CoinInfo/Name
// /Data/CoinInfo/FullName
// /Data/CoinInfo/ImageUrl
// /Data/CoinInfo/Url
// /Data/CoinInfo/Rating/Weiss/Market/PerformanceRating

/*
https://weissratings.com/help/rating-definitions
What Does Each Letter Grade Mean?

Both the Weiss Investment Ratings (stocks, ETFs and mutual funds) and the Weiss Safety Ratings (banks, credit unions and insurers) use the same grade scale, as follows:

A = excellent
B = good
C = fair
D = weak
E = very weak

Plus sign (+): upper third of each grade
No sign: middle third of each grade
Minus sign (-): lower third of each grade
 */
}
