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

  String selectedCurrency = 'USD';
  String btcPrice = '?';
  String ethPrice = '?';
  String ltcPrice = '?';

  DropdownButton<String> materialDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];

    for (String currency in currenciesList) {
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
          btcPrice = coinData.getPriceIn(selectedCurrency);
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> items = [];

    for (String currency in currenciesList) {
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
          btcPrice = coinData.getPriceIn(selectedCurrency);
        });
      },
      children: items,
    );
  }

  @override
  void initState() {
    super.initState();

    updateUI();
  }

  void updateUI() async {
    try {
      await coinData.refreshCoinData();
      setState(() {
        this.btcPrice = coinData.getPriceIn(selectedCurrency);
      });
    } on Exception catch (e) {
      print(e);
    }
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
            children: [
              PriceRow(
                  coinSymbol: 'BTC',
                  btcPrice: btcPrice,
                  selectedCurrency: selectedCurrency),
              PriceRow(
                  coinSymbol: 'ETH',
                  btcPrice: ethPrice,
                  selectedCurrency: selectedCurrency),
              PriceRow(
                  coinSymbol: 'LTC',
                  btcPrice: ltcPrice,
                  selectedCurrency: selectedCurrency),
            ],
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

class PriceRow extends StatelessWidget {
  const PriceRow({
    @required this.btcPrice,
    @required this.selectedCurrency,
    @required this.coinSymbol,
  });

  final String coinSymbol;
  final String btcPrice;
  final String selectedCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 35.0),
          child: Text(
            '1 $coinSymbol = $btcPrice $selectedCurrency',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
