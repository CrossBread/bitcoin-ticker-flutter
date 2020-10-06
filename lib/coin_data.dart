import 'package:http/http.dart' as Html;

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
const url = 'https://min-api.cryptocompare.com/data/price?fsym=BTC&tsyms=';

class CoinData {
  dynamic getCoinData() async {
    Html.Response response =
        await Html.get('${url}USD', headers: {'Apikey': apiKey});
    if (response.statusCode == 200) {
      print(response.body);
    } else {
      print('Status: ${response.statusCode}');
    }
  }
}
