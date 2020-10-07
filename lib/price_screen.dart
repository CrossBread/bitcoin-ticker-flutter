import 'package:bitcoin_ticker/crypto_currency.dart';
import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  CoinData coinData = CoinData();
  List<CryptoCards> cryptoCards = [];

  String selectedCurrency = 'USD';
  String btcPrice = '?';
  String ethPrice = '?';
  String ltcPrice = '?';

  DropdownButton<String> materialDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];

    for (String currency in currencySymbolsList) {
      DropdownMenuItem<String> item = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );

      dropdownItems.add(item);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          // updatePriceValues();
          updateUI();
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> items = [];

    for (String currency in currencySymbolsList) {
      Text item = Text(
        currency,
        style: TextStyle(
          color: Colors.white,
        ),
      );

      items.add(item);
    }

    return CupertinoPicker(
      scrollController: FixedExtentScrollController(initialItem: 19),
      looping: true,
      useMagnifier: true,
      magnification: 1.2,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = items[selectedIndex].data;
          // updatePriceValues();
          updateUI();
        });
      },
      children: items,
    );
  }

  @override
  void initState() {
    super.initState();

    cacheData();
  }

  void cacheData() async {
    try {
      await coinData.refreshCoinData();
      setState(() {
        updateUI();
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  void updateUI() async {
    // updatePriceValues();
    //
    // cryptoCards.add(CryptoCards(
    //     cryptoPrice: '10', selectedCurrency: 'USD', coinSymbol: 'BTC'));

    cryptoCards.clear();
    for (var cryptoSymbol in coinData.topCryptoMap.values) {
      cryptoCards.add(CryptoCards(
        cryptoPrice: cryptoSymbol.prices[selectedCurrency].toStringAsFixed(0),
        selectedCurrency: selectedCurrency,
        coinSymbol: cryptoSymbol.symbol,
        logoUrl: cryptoSymbol.imageUrl,
      ));

      if (cryptoCards.length > 5) break; // TODO: Remove after overflow is fixed
    }
  }

  void updatePriceValues() {
    btcPrice = coinData.getPriceIn('BTC', selectedCurrency);
    ethPrice = coinData.getPriceIn('ETH', selectedCurrency);
    ltcPrice = coinData.getPriceIn('LTC', selectedCurrency);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: cryptoCards,
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            // child: Platform.isIOS ? iOSPicker() : materialDropdown(),
            child: iOSPicker(),
          ),
        ],
      ),
    );
  }
}

class CryptoCards extends StatelessWidget {
  const CryptoCards({
    @required this.cryptoPrice,
    @required this.selectedCurrency,
    @required this.coinSymbol,
    @required this.logoUrl,
  });

  final String coinSymbol;
  final String cryptoPrice;
  final String selectedCurrency;
  final String logoUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 8.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 35.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '1 $coinSymbol = $cryptoPrice $selectedCurrency',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              CircleAvatar(
                radius: 20.0,
                backgroundColor: Colors.blue.shade800,
                backgroundImage: NetworkImage(logoUrl),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
