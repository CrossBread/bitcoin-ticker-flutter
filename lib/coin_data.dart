import 'package:http/http.dart' as Html;
import 'dart:convert';

const List<String> currenciesList = [
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

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const apiKey =
    '286567abd9afaecc54408971b58234c8f316b028e580341065b2f5206adf634a';
final symbolsList = currenciesList.join(',');
final url =
    'https://min-api.cryptocompare.com/data/price?fsym=BTC&tsyms=$symbolsList';

class CoinData {
  dynamic cryptoSymbolData;

  Future<void> refreshCoinData() async {
    cryptoSymbolData = await getData();
    print('Data fetched!');
  }

  String getPriceIn(String currencyCode) {
    return cryptoSymbolData != null
        ? cryptoSymbolData[currencyCode].toString()
        : 'N/A';
  }

  Future<dynamic> getData() async {
    Html.Response response = await Html.get(url, headers: {'Apikey': apiKey});
    if (response.statusCode == 200) {
      print(response.body);
      JsonDecoder decoder = JsonDecoder();
      return decoder.convert(response.body);
    } else {
      print('Status: ${response.statusCode}');
    }
  }
}
