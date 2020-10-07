import 'dart:io';

import 'package:http/http.dart' as Html;
import 'dart:convert';

import 'crypto_currency.dart';

const List<String> currencySymbolsList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> defaultCryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const apiKey =
    '286567abd9afaecc54408971b58234c8f316b028e580341065b2f5206adf634a';
final fiatCurrencySymbols = currencySymbolsList.join(',');
final cryptoCurrencySymbols = defaultCryptoList.join(',');
final defaultPriceUrl =
    'https://min-api.cryptocompare.com/data/pricemulti?fsyms=$cryptoCurrencySymbols&tsyms=$fiatCurrencySymbols';
final topCryptoUrl =
    'https://min-api.cryptocompare.com/data/top/totalvolfull?limit=10&tsym=USD';

class CoinData {
  Map<String, CryptoSymbol> topCryptoMap = {};
  String topCryptoPriceUrl;

  dynamic cryptoTopSybmolData;
  dynamic cryptoSymbolPriceData;

  Future<void> refreshCoinData() async {
    cryptoTopSybmolData = await getData(topCryptoUrl);
    print('Top Symbol Data fetched!');

    for (var node in cryptoTopSybmolData['Data']) {
      // /Data/CoinInfo/Name
      // /Data/CoinInfo/FullName
      // /Data/CoinInfo/ImageUrl
      // /Data/CoinInfo/Url
      // /Data/CoinInfo/Rating/Weiss/Market/PerformanceRating
      CryptoSymbol crypto = CryptoSymbol(
          symbol: node['CoinInfo']['Name'],
          name: node['CoinInfo']['FullName'],
          imageUrl: node['CoinInfo']['ImageUrl'],
          infoUrl: node['CoinInfo']['Url'],
          performanceRating: node['CoinInfo']['Rating']['Weiss']
              ['MarketPerformanceRating']);

      topCryptoMap[crypto.symbol] = crypto;
      // topCryptoSymbolsList.add(crypto.symbol);
    }

    if (topCryptoMap.keys.length == 0) {
      cryptoSymbolPriceData = await getData(defaultPriceUrl);
    } else {
      String topCryptoSymbols = topCryptoMap.keys.join(',');
      topCryptoPriceUrl =
          'https://min-api.cryptocompare.com/data/pricemulti?fsyms=$topCryptoSymbols&tsyms=$fiatCurrencySymbols';
      cryptoSymbolPriceData = await getData(topCryptoPriceUrl);

      for (var cryptoSymbol in cryptoSymbolPriceData.keys) {
        var pricesMap = cryptoSymbolPriceData[cryptoSymbol];
        for (var fiatSymbol in pricesMap.keys) {
          topCryptoMap[cryptoSymbol].prices[fiatSymbol] =
              double.parse(pricesMap[fiatSymbol].toString());
        }
      }
    }
    print('Price Data fetched!');
  }

  String getPriceIn(String cryptoSymbol, String fiatSymbol) {
    // return cryptoSymbolPriceData != null
    //     ? cryptoSymbolPriceData[cryptoSymbol][fiatSymbol].toString()
    //     : 'N/A';
    return topCryptoMap[cryptoSymbol].getPrice(fiatSymbol).toStringAsFixed(0);
  }

  Future<dynamic> getData(String url) async {
    Html.Response response = await Html.get(url, headers: {'Apikey': apiKey});
    if (response.statusCode == 200) {
      if (response.body.toLowerCase().contains('error')) {
        throw HttpException(
            'Request for data returned an error:\n$url\nbody:${response.body}');
      }

      JsonDecoder decoder = JsonDecoder();
      return decoder.convert(response.body);
    } else {
      print('Status: ${response.statusCode}');
      print('URL: $url');
    }
  }
}
